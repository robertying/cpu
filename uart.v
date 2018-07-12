module uart(
    input sysclk,
    input [7:0] tx_data,
    output reg [7:0] rx_data,
    input tx_enable,
    input rx_enable,
    output reg tx_flag,
    output reg rx_flag,
    output reg tx_status,
    input PC_Uart_rxd,
    output PC_Uart_txd);

    reg baudx16_clk;
    reg [9:0] baudx16_rate_count;
    
    initial 
    begin
        baudx16_rate_count = 0;
        baudx16_clk = 0;
    end

    // x16 baud rate generator
    always @(posedge sysclk)
    begin
        if (baudx16_rate_count == 0)  baudx16_clk = ~baudx16_clk;
        baudx16_rate_count = baudx16_rate_count + 2;
        if (baudx16_rate_count == 650) baudx16_rate_count = 0;
    end

    // modules
    rx _rx(PC_Uart_rxd, baudx16_clk, rx_flag, rx_data);
    tx _tx(baudx16_clk, tx_data, tx_enable, tx_flag, tx_status, PC_Uart_txd);
    
endmodule 

module rx (
    input rx_in,
    input clk,
    output reg rx_flag,
    output reg [7:0] rx_data);
    
    reg sample_signal;
    reg last_sample;
    reg start_rx;
    reg [4:0] clk_count;
    reg [3:0] sample_signal_count;
    reg [3:0] bit_count;
    reg [7:0] rx_data_tmp;
    
    initial
    begin
        last_sample = 1;
        sample_signal = 0;
        start_rx = 0;
        clk_count = 0;
        sample_signal_count = 0;
        bit_count = 0;
        rx_data_tmp = 0;
        rx_data = 0;
        rx_flag = 0;
    end
        
    always @(posedge clk)
    begin
        rx_flag = 0;
        // check if the transmission begins
        if (rx_in == 0 && last_sample == 1) start_rx = 1;
        // begin sampling
        if (start_rx) clk_count = clk_count + 1;
        if (clk_count == 9) 
        begin
            // sampling in the middle    
            sample_signal = 1;
        end
        else sample_signal = 0;
        // finish one cycle
        if (clk_count == 16)
        begin
            clk_count = 0;
            bit_count = bit_count + 1;
        end
        // finish all data bits
        if (bit_count == 10) 
        begin
            bit_count = 0;
            start_rx = 0;
            rx_data = rx_data_tmp;
            rx_flag = 1;
        end
        last_sample = rx_in;
    end
    
    // sampling and save data
    always @(posedge sample_signal) 
    begin
        sample_signal_count = sample_signal_count + 1; 
        if (sample_signal_count == 10)
        begin
            sample_signal_count = 0;  
        end
        rx_data_tmp[sample_signal_count - 2] = rx_in;  
    end

endmodule    

module tx(
    input clk,
    input [7:0] tx_data,
    input tx_enable,
    output reg tx_flag,
    output reg tx_status,
    output reg tx_out);
    
    reg send_signal;
    reg start_tx;
    reg [4:0] clk_count;
    reg [3:0] send_signal_count;
    reg [3:0] bit_count;
    reg [7:0] tx_data_tmp;
    
    initial
    begin
        send_signal = 0;
        start_tx = 0;
        clk_count = 0;
        send_signal_count = 0;
        bit_count = 0;
        tx_data_tmp = 0;
        tx_out = 1;
        tx_status = 0;
    end
        
    always @(posedge clk)
    begin
        // begin sending
        if (tx_enable)
        begin
            start_tx = 1;
            tx_data_tmp = tx_data;
            tx_status = 1;
        end
        // generate 9600 sending signal
        if (start_tx) clk_count = clk_count + 1;
        if (clk_count == 1) 
        begin   
            send_signal = 1;
        end
        else send_signal = 0;
        // finish one 9600 cycle
        if (clk_count == 16)
        begin
            clk_count = 0;
            bit_count = bit_count + 1;
        end
        // finish all data bits
        if (bit_count == 10) 
        begin
            bit_count = 0;
            start_tx = 0;
            tx_status = 0;
            tx_flag = 1;
        end
    end
    
    // send data
    always @(posedge send_signal) 
    begin
        if (send_signal_count == 0) tx_out = 0;
        else tx_out = tx_data_tmp[send_signal_count - 1];
        send_signal_count = send_signal_count + 1;
        if (send_signal_count == 10)
        begin
            tx_out = 1;
            send_signal_count = 0;  
        end       
    end
   
endmodule
