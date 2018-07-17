`timescale 1ns/1ps

module PipelineCPU_tb;

reg sysclk;
reg reset;
reg UART_RX;

wire [7:0] leds;
wire [7:0] switch;
wire [11:0] digi;
wire UART_TX;

initial begin
	sysclk <= 0;
	reset <= 1;
	UART_RX <= 1;

	#10 reset <= 0;
	#10 reset <= 1;
end

always #5 sysclk = ~sysclk;

PipelineCPU PipelineCPU_test(.reset(reset), .sysclk(sysclk),
							  .led(led), .switch(switch), .digi(digi),
							  .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule
