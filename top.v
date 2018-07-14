module top(sysclk, reset, UART_RX, led, switch, digi, UART_TX);
input sysclk;
input reset;
input UART_RX;
output [7:0] led;
output [7:0] switch;
output [11:0] digi;
output UART_TX;

wire clk;

FreqDiv freqDiv(.sysclk(sysclk), .clk(clk));
SingleCycleCPU CPU(.clk(clk), .reset(reset), .switch(switch), .led(led), .digi(digi), .UART_RX(UART_RX), .UART_TX(UART_TX));

endmodule