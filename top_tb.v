`timescale 1ns/1ps

module top_tb;

reg sysclk;
reg reset;
reg UART_RX;

wire [7:0] led;
wire [11:0] digi;
wire [7:0] switch;
wire UART_TX;

initial begin
	sysclk <= 0;
	reset <= 1;
	UART_RX <= 1;

	#10 reset <= 0;
	#10 reset <= 1;

	// first number = 84
	#208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;

	// second number = 12
	#416666 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;
    #208333 UART_RX = 1;
    #208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 0;
    #208333 UART_RX = 1;
end

always #5 sysclk = ~sysclk;

top top_test(.sysclk(sysclk), .reset(reset),
									   .led(led), .switch(switch), .digi(digi),
									   .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule