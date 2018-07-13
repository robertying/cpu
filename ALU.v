
module ALU (A, B, ALUFun, Sign, OUT);
	input [31:0] A, B;
	input [5:0] ALUFun;
	input Sign;
	output reg [31:0] OUT;
	

	wire [31:0] OUT_00;
	reg OUT_11;
	reg [31:0] OUT_01;
	reg [31:0] OUT_10;
	
	wire nonzero;
	reg negative;
	reg compare_zero;
	
	wire [31:0] B_left_1;
	wire [31:0] B_left_2;
	wire [31:0] B_left_4;
	wire [31:0] B_left_8;
	wire [31:0] B_left;
	wire [31:0] B_right_1;
	wire [31:0] B_right_2;
	wire [31:0] B_right_4;
	wire [31:0] B_right_8;
	wire [31:0] B_right;
	wire [31:0] B_right_a_1;
	wire [31:0] B_right_a_2;
	wire [31:0] B_right_a_4;
	wire [31:0] B_right_a_8;
	wire [31:0] B_right_a;

	assign OUT_00 = A + (ALUFun[0]? (~B) + 32'h00000001: B);

	assign nonzero = | OUT_00;
	
	always @(*)
		case ({A[31], B[31]})
			2'b10: negative <= Sign;
			2'b01: negative <= ~Sign;
			default: negative <= OUT_00[31];
		endcase
	
	always @(*)
	 	case ({ALUFun[2], Sign})
			2'b11: compare_zero <= A[31] | ~(|A);
			2'b10: compare_zero <= ~(|A);
			2'b01: compare_zero <= A[31];
			default: compare_zero <= 0;
		endcase

	always @(*)
		case (ALUFun[3:2])
			2'b11: OUT_11 <= compare_zero ^ ALUFun[1];
			2'b10: OUT_11 <= compare_zero;
			2'b01: OUT_11 <= negative;
			default: OUT_11 <= nonzero ^ ALUFun[1];
		endcase

	always @(*)
		case (ALUFun[3:0])
			4'b1000: OUT_01 <= A & B;
			4'b1110: OUT_01 <= A | B;
			4'b0110: OUT_01 <= A ^ B;
			4'b0001: OUT_01 <= ~(A | B);
			default: OUT_01 <= A;
		endcase

	assign B_left_1 = A[0]? {B[30:0], 1'h0}: B;
	assign B_left_2 = A[1]? {B_left_1[29:0], 2'h0}: B_left_1;
	assign B_left_4 = A[2]? {B_left_2[27:0], 4'h0}: B_left_2;
	assign B_left_8 = A[3]? {B_left_4[23:0], 8'h0}: B_left_4;
	assign B_left = A[4]? {B_left_8[15:0], 16'h0}: B_left_8;

	assign B_right_1 = A[0]? {1'h0, B[31:1]}: B;
	assign B_right_2 = A[1]? {2'h0, B_right_1[31:2]}: B_right_1;
	assign B_right_4 = A[2]? {4'h0, B_right_2[31:4]}: B_right_2;
	assign B_right_8 = A[3]? {8'h0, B_right_4[31:8]}: B_right_4;
	assign B_right = A[4]? {16'h0, B_right_8[31:16]}: B_right_8;

	assign B_right_a_1 = A[0]? {1'b1, B[31:1]}: B;
	assign B_right_a_2 = A[1]? {2'b11, B_right_a_1[31:2]}: B_right_a_1;
	assign B_right_a_4 = A[2]? {4'b1111, B_right_a_2[31:4]}: B_right_a_2;
	assign B_right_a_8 = A[3]? {8'b1111_1111, B_right_a_4[31:8]}: B_right_a_4;
	assign B_right_a = A[4]? {16'b1111_1111_1111_1111, B_right_a_8[31:16]}: B_right_a_8;

	always @(*)
		if(ALUFun[0])
		begin
			if(ALUFun[1] & B[31])
				OUT_10 <= B_right_a;
			else
				OUT_10 <= B_right;
		end
		else
			OUT_10 <= B_left;

	always @(*)
		case (ALUFun[5:4])
			2'b00: OUT <= OUT_00;
			2'b11: OUT <= {31'h00000000, OUT_11};
			2'b01: OUT <= OUT_01;
			2'b10: OUT <= OUT_10;
			default: OUT <= 32'h00000000;
		endcase

endmodule