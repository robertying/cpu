`timescale 1ns/1ps

module UART_tb();
    reg sysclk, clk, reset, rd, wr, PC_Uart_rxd;
    wire irqout, PC_Uart_txd;
    reg [31:0] addr, wdata;
    reg [7:0] switch;
    wire [7:0] led;
    wire [31:0] rdata;
    wire [11:0] digi;

    Peripheral peripheral(sysclk,
                            reset,
                            clk,
                            rd,
                            wr,
                            addr,
                            wdata,
                            switch,
                            rdata,
                            led,
                            digi,
                            irqout,
                            PC_Uart_rxd,
                            PC_Uart_txd);

    always #10 clk <= ~clk; // 50M
    always #5 sysclk <= ~sysclk; // 100M

    initial begin
      sysclk <= 0;
      clk <= 0;
      reset <= 1;
      rd <= 0;
      wr <= 0;
      PC_Uart_rxd <= 1;

      #10 reset <= ~reset;
      #10 reset <= ~reset;

      #10 begin
        wr <= 1;
        addr <= 32'h40000018; // Write should enable UART sending
        wdata <= {24'b0, 8'b00101101}; // [7:0] as send data
      end

      #10 begin
        wr <= 0; // Disable writing
        addr <= 32'h40000018; // Write should enable UART sending
        wdata <= {24'b0, 8'b00101101}; // [7:0] as send data
      end

      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;
      #104167 PC_Uart_rxd <= 1;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;

      #200000 begin
        rd <= 1;
        addr <= 32'h4000001C;
      end

      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;
      #104167 PC_Uart_rxd <= 0;
      #104167 PC_Uart_rxd <= 1;

      #200000 begin
        rd <= 1;
        addr <= 32'h4000001C;
      end
    end

endmodule
