`timescale 1ns/1ps

module PipelineCPU_tb;

reg clk;
reg reset;
reg UART_RX;

wire [7:0] leds;
wire [7:0] switch;
wire [11:0] digi;
wire UART_TX;

initial begin
	clk <= 0;
	reset <= 1;
	UART_RX <= 0;
	#10 reset <= 0;
	#10 reset <= 1;
end

always #10 clk = ~clk;

PipelineCPU Pipeline_CPU_test(.clk(clk), .reset(reset),
									   .led(led), .switch(switch), .digi(digi),
									   .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule