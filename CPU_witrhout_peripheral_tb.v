`timescale 1ns/1ps

module Pipeline_Cycle_CPU_tb;

reg clk;
reg reset;
reg UART_RX;

wire [7:0] leds;
wire [11:0] digi;
wire UART_TX;

initial begin
	clk <= 0;
	reset <= 1;
	UART_RX <= 0;
	#50 reset <= 0;
	#50 reset <= 1;
end

always #50 clk = ~clk;

Pipeline_CPU Pipeline_CPU_test(.clk(clk), .reset(reset),
									   .led(led), .digi(digi),
									   .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule