`timescale 1 ns / 1 ns
module test();
reg sign;
reg [5:0] alufun;
reg [31:0] a, b;
wire [31:0] out;
reg [4:0]counter;

ALU alu(.A(a), .B(b), .ALUFun(alufun), .Sign(sign), .OUT(out));

initial begin
	counter = 5'd0;
	forever #5 counter = counter + 1'd1;
end

initial begin
    alufun = 6'b000000;
	#5 alufun = 6'b000001;

	#5 alufun = 6'b011000;
	#5 alufun = 6'b011110;
	#5 alufun = 6'b010110;
	#5 alufun = 6'b010001;
	#5 alufun = 6'b011010;

	#5 alufun = 6'b100000;
	#5 alufun = 6'b100001;
	#5 alufun = 6'b100011;

	#5 alufun = 6'b110011;
	#5 alufun = 6'b110001;
	#5 alufun = 6'b110101;
	#5 alufun = 6'b111101;
	#10 alufun = 6'b111011;
	#10 alufun = 6'b111111;

	#10 alufun = 6'b000000;
end

initial begin
    a = 32'h0000000f;
	#5 a = 32'hf111111f;

	#5 a = 32'h000011f0;
	#5 a = 32'h0000011f;
	#5 a = 32'h000011f0;
	#5 a = 32'h0000011f;
	#5 a = 32'h000011f0;

	#5 a = 32'h0000000a;
	#5 a = 32'h0000000b;
	#5 a = 32'h00000009;

	#5 a = 32'hf1111110;
	#5 a = 32'hf111111f;
	#5 a = 32'h000000f1;
	#5 a = 32'hf00000f1;
	#5 a = 32'h00000000;
	#5 a = 32'hf00000f1;
	#5 a = 32'h00000000;
	#5 a = 32'hf00000f1;
	#5 a = 32'h00000000;

	#5 a = 32'h00000000;
end

initial begin
	b = 32'h0000000f;
	#5 b = 32'h00000900;

	#5 b = 32'hf111111f;
	#5 b = 32'h000021a0;
	#5 b = 32'hf111111f;
	#5 b = 32'h000021a0;
	#5 b = 32'hf111111f;

	#5 b = 32'hf111111f;
	#5 b = 32'hf111111f;
	#3 b = 32'hf111111f;
	#2 b = 32'h0111111f;
		
	#3 b = 32'hf111111f;
	#2 b = 32'hf1111110;
	#3 b = 32'hf111111f;
	#2 b = 32'hf1111110;
	#5 b = 32'hfffffff1;
	#5 b = 32'h00000011;
	#10 b = 32'h00000011;
	#10 b = 32'h00000011;

	#10 b = 32'h00000000;
end

initial begin
	sign = 0;
	#60 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
	#3 sign = 0;
	#2 sign = 1;
end

endmodule