module FreqDiv(sysclk, clk);
input sysclk;
output reg clk;

initial begin
	clk <= 0;
end

always @(posedge sysclk)
	clk = ~clk;

endmodule
