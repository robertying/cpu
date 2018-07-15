module SingleCycleCPU (reset, sysclk, led, switch, digi, UART_RX, UART_TX);
input reset;
input sysclk;
input UART_RX;
output [7:0] led;
output [7:0] switch;
output [11:0] digi;
output UART_TX;

parameter INT_PC = 32'h8000_0004;
parameter EXP_PC = 32'h8000_0008;

wire clk;
FreqDiv freqDiv(.sysclk(sysclk), .clk(clk));

reg [31:0] PC;
wire [31:0] PC_next;
always @(posedge clk or negedge reset) begin
	if(~reset)
		PC <= 32'h0000_0000;
	else
		PC <= PC_next;
end

wire [31:0] PC_plus_4;
assign PC_plus_4 = PC + 32'h4;

wire [31:0] Instruct;
ROM instructionMem(.addr(PC[30:0]), .data(Instruct));

wire [25:0] JT;
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd;
wire [4:0] Rt;
wire [4:0] Rs;
assign JT = Instruct[25:0];
assign Imm16 = Instruct[15:0];
assign Shamt = Instruct[10:6];
assign Rd = Instruct[15:11];
assign Rt = Instruct[20:16];
assign Rs = Instruct[25:21];

wire IRQ;
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
Control control(.Instruct(Instruct), .IRQ(IRQ), .PC31(PC[31]),
				.PCSrc(PCSrc), .RegDst(RegDst), .RegWr(RegWr), .ALUSrc1(ALUSrc1),
				.ALUSrc2(ALUSrc2), .ALUFun(ALUFun), .Sign(Sign), .MemWr(MemWr),
				.MemRd(MemRd), .MemToReg(MemToReg), .ExtOp(ExtOp), .LUOp(LUOp));

wire [4:0] Rw;
assign Rw = (RegDst == 2'b00) ? Rd :
			(RegDst == 2'b01) ? Rt :
			(RegDst == 2'b10) ? 5'b11111 :
			(RegDst == 2'b11) ? 5'b11010 : 5'b00000;

wire [31:0] DataBusA;
wire [31:0] DataBusB;
wire [31:0] DataBusC;
RegFile regFile(.reset(reset), .clk(clk), .addr1(Rs), .data1(DataBusA),.addr2(Rt),
				.data2(DataBusB), .wr(RegWr), .addr3(Rw), .data3(DataBusC));

wire [31:0] Imm32;
wire [31:0] ALU_In_A;
wire [31:0] ALU_In_B;
assign Imm32 = (ExtOp && Imm16[15] ) ? {16'hffff, Imm16} : {16'h0000, Imm16};
assign ALU_In_A = ALUSrc1 ? Shamt : DataBusA;
assign ALU_In_B = ALUSrc2 ? (LUOp ? {Imm16, 16'b0} : Imm32) : DataBusB;

wire [31:0] ALUOut;
ALU alu(.A(ALU_In_A), .B(ALU_In_B), .ALUFun(ALUFun), .Sign(Sign), .OUT(ALUOut));

wire [31:0] DataMemOut;
DataMem dataMem(.reset(reset), .clk(clk), .rd(MemRd), .wr(MemWr),
				.addr(ALUOut), .wdata(DataBusB), .rdata(DataMemOut));

wire [31:0] PeripheralOut;
Peripheral peripheral(.sysclk(sysclk), .reset(reset), .clk(clk), .rd(MemRd), .wr(MemWr), .addr(ALUOut),
					  .wdata(DataBusB), .rdata(PeripheralOut), .led(led), .switch(switch),
					  .digi(digi), .irqout(IRQ), .PC_Uart_rxd(UART_RX), .PC_Uart_txd(UART_TX));

wire [31:0] MemOut;
assign MemOut = ALUOut[30] ? PeripheralOut : DataMemOut;

assign DataBusC = (MemToReg == 2'b00) ? ALUOut :
				  (MemToReg == 2'b01) ? MemOut :
				  (MemToReg == 2'b10) ? PC_plus_4 :
				  (MemToReg == 2'b11) ? PC : PC_plus_4;

wire [31:0] ConBA;
assign ConBA = PC_plus_4 + {Imm32[29:0], 2'b00};
assign PC_next = (PCSrc == 3'b000) ? PC_plus_4 :
				 (PCSrc == 3'b001) ? (ALUOut[0] ? ConBA : PC_plus_4) :
				 (PCSrc == 3'b010) ? {PC_plus_4[31:28], JT, 2'b00} :
				 (PCSrc == 3'b011) ? DataBusA :
				 (PCSrc == 3'b100) ? INT_PC :
				 (PCSrc == 3'b101) ? EXP_PC : EXP_PC;

endmodule
