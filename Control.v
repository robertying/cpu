module Control (Instruct, IRQ, PC31,
	PCSrc, RegDst, RegWr, ALUSrc1,
	ALUSrc2, ALUFun, Sign, MemWr,
	MemRd, MemToReg, ExtOp, LUOp);
	input [31:0] Instruct;
	input IRQ;
	input PC31;
	output reg [2:0] PCSrc;
	output reg [1:0] RegDst;
	output reg RegWr;
	output ALUSrc1;
	output ALUSrc2;
	output reg [5:0] ALUFun;
	output Sign;
	output MemWr;
	output MemRd;
	output reg [1:0] MemToReg;
	output ExtOp;
	output LUOp;
    
	wire [5:0] OpCode;
	wire [5:0] Funct;
	wire IRQ_valid;
	wire Undefine;

	assign OpCode = Instruct[31:26];
	assign Funct = Instruct[5:0];
	assign IRQ_valid = IRQ & (~PC31);
	assign Undefine = PC31 ? 0 :
			~((OpCode >= 6'h00 && OpCode <= 6'h0c) || OpCode == 6'h0f || OpCode == 6'h23 || OpCode == 6'h2b) ? 1 :
			((OpCode != 0) || ((OpCode == 0) && (Funct[5:3] >= 3'b100 || Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h08 || Funct == 6'h09 || Funct == 6'h2a))) ? 0 : 1; 
	// PCSrc 
	always @(*)
		if(IRQ_valid)
			PCSrc <= 3'd4;
		else if(Undefine)
			PCSrc <= 3'd5;
		else if(OpCode == 6'h01 || OpCode >= 6'h04 && OpCode <= 6'h07)
			PCSrc <= 3'd1;
		else if(OpCode == 6'h02 || OpCode == 6'h03)
			PCSrc <= 3'd2;
		else if(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))
			PCSrc <= 3'd3;
		else
			PCSrc <= 3'd0;
	// RegDst
	always @(*)
		if(IRQ_valid || Undefine)
			RegDst <= 2'd3;
		else if(OpCode == 6'h03 || OpCode == 6'h00 && Funct == 6'h09)
			RegDst <= 2'd2;
		else if(OpCode == 6'h00)
			RegDst <= 2'd0;
		else
			RegDst <= 2'd1;
	// RegWr
	always @(*)
		if(IRQ_valid || Undefine)
			RegWr <= 1;
		else if(Instruct == 32'h0000_0000 || OpCode == 6'h2b || (OpCode == 6'h00 && Funct == 6'h08) || (OpCode >= 6'h01 && OpCode <= 6'h07 && OpCode != 6'h03))
			RegWr <= 0;
		else
			RegWr <= 1;
	// MemToReg
	always @(*)
		if(IRQ_valid)
			MemToReg <= 2'd3;
		else if(Undefine || OpCode == 6'h00 && Funct == 6'h09 || OpCode == 6'h03)
			MemToReg <= 2'd2;
		else if(OpCode == 6'h23)
			MemToReg <= 2'd1;
		else
			MemToReg <= 2'd0;
	// ALUFun
	always @(*)
		if(OpCode == 6'h00)
			case(Funct)
				6'h00: ALUFun <= 6'b100000;
				6'h02: ALUFun <= 6'b100001;
				6'h03: ALUFun <= 6'b100011;
				6'h20: ALUFun <= 6'b000000;
				6'h21: ALUFun <= 6'b000000;
				6'h22: ALUFun <= 6'b000001;
				6'h23: ALUFun <= 6'b000001;
				6'h24: ALUFun <= 6'b011000;
				6'h25: ALUFun <= 6'b011110;
				6'h26: ALUFun <= 6'b010110;
				6'h27: ALUFun <= 6'b010001;
				6'h2a: ALUFun <= 6'b110101;
				default: ALUFun <= 6'b000000;
			endcase
		else
			case(OpCode)
				6'h01: ALUFun <= 6'b111011;
				6'h04: ALUFun <= 6'b110011;
				6'h05: ALUFun <= 6'b110001;
				6'h06: ALUFun <= 6'b111101;
				6'h07: ALUFun <= 6'b111111;
				6'h08: ALUFun <= 6'b000000;
				6'h09: ALUFun <= 6'b000000;
				6'h0a: ALUFun <= 6'b110101;
				6'h0b: ALUFun <= 6'b110101;
				6'h0c: ALUFun <= 6'b011000;
				6'h0f: ALUFun <= 6'b000000;
				6'h23: ALUFun <= 6'b000000;
				6'h2b: ALUFun <= 6'b000000;
				default: ALUFun <= 6'b000000;
			endcase

	assign ALUSrc1 = (OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03))? 1 : 0;
	assign ALUSrc2 = (OpCode >= 6'h08) ? 1 : 0;
	assign Sign = (OpCode == 6'h0b) ? 0 : 1;
	assign MemWr = (OpCode == 6'h2b) ? 1 : 0;
	assign MemRd = (OpCode == 6'h23) ? 1 : 0;
	assign ExtOp = (OpCode == 6'h0c) ? 0 : 1;
	assign LUOp = (OpCode == 6'h0f) ? 1 : 0;

endmodule