module uart_tb(
);

    reg clk, reset, rd, wr, PC_Uart_rxd;
    wire irqout, PC_Uart_txd;
    reg [31:0] addr, wdata;
    wire [7:0] switch, led;
    wire [31:0] rdata;
    wire [11:0] digi;

    peripheral _peripheral(reset,
                            clk,
                            rd,
                            wr,
                            addr,
                            wdata,
                            rdata,
                            led,
                            switch,
                            digi,
                            irqout,
                            PC_Uart_rxd,
                            PC_Uart_txd);

    initial begin
      clk = 0;
      reset = 1;
      rd = 0;
      wr = 0;
      PC_Uart_rxd = 1;

      #10 reset = ~reset;
      #10 reset = ~reset;

      #10 begin
        wr = 1;
        addr = 32'h40000018; // write should enable UART sending
        wdata = {24'b0, 8'b00101101}; // [7:0] as send data
      end

      #10 begin
        wr = 0; // disable writing
        addr = 32'h40000018; // write should enable UART sending
        wdata = {24'b0, 8'b00101101}; // [7:0] as send data
      end

      #208333 PC_Uart_rxd = 0;
      #208333 PC_Uart_rxd = 1;
      #208333 PC_Uart_rxd = 0;
      #208333 PC_Uart_rxd = 1;
      #208333 PC_Uart_rxd = 1;
      #208333 PC_Uart_rxd = 0;
      #208333 PC_Uart_rxd = 0;
      #208333 PC_Uart_rxd = 1;
      #208333 PC_Uart_rxd = 0;
      #208333 PC_Uart_rxd = 1;

      #300000 begin
        rd <= 1;
        addr <= 32'h4000001C;
      end
    end

    always #10 clk = ~clk;
    
endmodule
