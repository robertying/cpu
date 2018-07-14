module FreqDiv_tb;

reg sysclk;
wire clk;

initial begin
	sysclk <= 0;
end

always #5 sysclk <= ~sysclk;

FreqDiv FreqDiv_test(.sysclk(sysclk), .clk(clk));

endmodule