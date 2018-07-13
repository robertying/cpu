module Single_Cycle_CPU (clk, reset, led, digi, UART_RX, UART_TX);
input clk;
input reset;
input UART_RX;
output [7:0] led;
output [11:0] digi;
output UART_TX;

parameter ILLOP = 32'h8000_0004;
parameter XADR = 32'h8000_0008;

reg [31:0] PC;
reg [31:0] PC_next;
wire [31:0] PC_4;
wire [31:0] ConBA;
wire [31:0] Instruction;

wire [25:0] JT;
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd;
wire [4:0] Rt;
wire [4:0] Rs;
reg [4:0] Rc;

wire [31:0] DataBusA;
wire [31:0] DataBusB;
reg [31:0] DataBusC;
wire [31:0] ALU_In_A;
wire [31:0] ALU_In_B;
wire [31:0] ALUOut;
wire [31:0] MemOut;
wire [31:0] Imm32;

wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWr;
wire ALUSrc1;
wire ALUSrc2;
wire [5:0] ALUFun;
wire Sign;
wire MemWr;
wire MemRd;
wire [1:0] MemToReg;
wire ExtOp;
wire LUOp;

assign PC_4 = PC +3'h4;
assign ConBA = PC_4 + {Imm32[29:0], 2'b00};

assign JT = {PC_4[31:28], Instruction[25:0], 2'b00};
assign Imm16 = Instruction[15:0];
assign Shamt = Instruction[10:6];
assign Rd = Instruction[15:11];
assign Rt = Instruction[20:16];
assign Rs = Instruction[25:21];

assign ALU_In_A = ALUSrc1 ? Shamt : DataBusA;
assign ALU_In_B = ALUSrc2 ? (LUOp ? {Imm16, 16'b0} : Imm32) : DataBusB;
assign Imm32 = (ExtOp && Imm16[15] ) ? {16'hffff, Imm16} : {16'h0000, Imm16};

always @(*)
	case (RegDst)
		2'b00: Rc <= Rd;
		2'b01: Rc <= Rt;
		2'b10: Rc <= 5'b11111;
		2'b11: Rc <= 5'b11010;
		default: Rc <= 5'b00000;
	endcase

always @(*)
	case (MemToReg)
		2'b00: DataBusC <= ALUOut;
		2'b01: DataBusC <= MemOut;
		2'b10: DataBusC <= PC_4;
		default: DataBusC <= PC_4;
	endcase

always @(*)
	case (PCSrc)
		3'b000: PC_next <= PC_4;
		3'b001: PC_next <= ALUOut[0] ? ConBA : PC_4;
		3'b010: PC_next <= JT;
		3'b011: PC_next <= DataBusA;
		3'b100: PC_next <= ILLOP;
		3'b101: PC_next <= XADR;
		default: PC_next <= XADR;
	endcase

always @(posedge clk or negedge reset) begin
	if(~reset)
		PC <= 32'h0000_0000;
	else
		PC <= PC_next;
end

ROM instruction_memory(.addr(PC[30:0]), .data(Instruction));
Control control(.Instruct(Instruction), .IRQ(IRQ), .PC31(PC[31]),
				.PCSrc(PCSrc), .RegDst(RegDst), .RegWr(RegWr), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2),
				.ALUFun(ALUFun), .Sign(Sign), .MemWr(MemWr), .MemRd(MemRd), .MemToReg(MemToReg), 
				.ExtOp(ExtOp), .LUOp(LUOp));
RegFile regfile(.reset(reset), .clk(clk), .addr1(Rs), .data1(DataBusA),
				.addr2(Rt), .data2(DataBusB), .wr(RegWr), .addr3(Rc), .data3(DataBusC));
ALU alu(.A(ALU_In_A), .B(ALU_In_B), .ALUFun(ALUFun), .Sign(Sign), .OUT(ALUOut));
DataMem datamem(.reset(reset), .clk(clk), .rd(MemRd), .wr(MemWr), .addr(ALUOut), .wdata(DataBusB), .rdata(MemOut));
//Peripheral peripheral(.reset(reset), .clk(clk), .rd(), .wr(), .addr(), .wdata(), .rdata(), .led(led), .switch(), .digi(digi), .irqout());
endmodule
