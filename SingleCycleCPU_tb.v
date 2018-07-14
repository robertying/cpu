`timescale 1ns/1ps

module SingleCycleCPU_tb;

reg clk;
reg reset;
reg UART_RX;

wire [7:0] led;
wire [11:0] digi;
wire [7:0] switch;
wire UART_TX;

initial begin
	clk <= 0;
	reset <= 1;
	UART_RX <= 1;

	#10 reset <= 0;
	#10 reset <= 1;

	// first number = 84
	#104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;

	// second number = 12
	#104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;
    #104167 UART_RX = 1;
    #104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 0;
    #104167 UART_RX = 1;
end

always #10 clk = ~clk;

SingleCycleCPU SingleCycleCPU_test(.clk(clk), .reset(reset),
									   .led(led),.switch(switch), .digi(digi),
									   .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule