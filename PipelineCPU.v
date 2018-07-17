module PipelineCPU(reset, sysclk, led, switch, digi, UART_RX, UART_TX);
input reset;
input sysclk;
input UART_RX;
output [7:0] led;
output [7:0] switch;
output [11:0] digi;
output UART_TX;

parameter ILLOP = 32'h8000_0004;
parameter XADR = 32'h8000_0008;

wire clk;
FreqDiv freqDiv(.sysclk(sysclk), .clk(clk));

reg [31:0] PC;
wire [31:0] PC_plus_4;
wire [31:0] ConBA;
wire [31:0] Instruction;
wire [25:0] JT;
wire [15:0] Imm16;
wire [4:0] Shamt;
wire [4:0] Rd;
wire [4:0] Rt;
wire [4:0] Rs;
wire [4:0] Rc;
wire IRQ;

wire [31:0] DataBusA;
wire [31:0] DataBusB;
wire [31:0] DataBusC;
wire [31:0] ALU_In_A;
wire [31:0] ALU_In_B;
wire [31:0] ALUOut;
wire [31:0] MemOut;
wire [31:0] DataMemOut;
wire [31:0] PeripheralOut;
wire [31:0] Imm32;
// signals from control
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
wire branch;
wire load_use;
wire jump;
wire jump_reg;
wire illop;
wire xadr;
// reg in IF/ID
reg [31:0] IF_ID_Instruction;
reg [31:0] IF_ID_PC;
reg [31:0] IF_ID_PC4;
// reg in ID/EX
reg [31:0] ID_EX_DATA1;
reg [31:0] ID_EX_DATA2;
reg [31:0] ID_EX_PC;
reg [31:0] ID_EX_Imm32;
reg [31:0] ID_EX_ConBA;
reg [2:0] ID_EX_PCSrc;
reg [4:0] ID_EX_Shamt;
reg [4:0] ID_EX_Rs;
reg [4:0] ID_EX_Rt;
reg [4:0] ID_EX_Rc;
reg [31:0] ID_EX_jump_addr;
reg ID_EX_RegWr;
reg ID_EX_ALUSrc1;
reg ID_EX_ALUSrc2;
reg ID_EX_Sign;
reg ID_EX_MemWr;
reg ID_EX_MemRd;
reg [1:0] ID_EX_MemToReg;
reg [5:0] ID_EX_ALUFun;
reg ID_EX_jump;
// reg in EX/MEM
reg EX_MEM_RegWr;
reg EX_MEM_MemWr;
reg EX_MEM_MemRd;
reg EX_MEM_branch;
reg [31:0] EX_MEM_PC;
reg [31:0] EX_MEM_DATA2;
reg [31:0] EX_MEM_ALUOut;
reg [4:0] EX_MEM_Rc;
reg [1:0] EX_MEM_MemToReg;
reg [31:0] EX_MEM_ConBA;
// reg in MEM/WB
reg MEM_WB_RegWr;
//reg [31:0] MEM_WB_PC4;
reg [31:0] MEM_WB_DataBusC;
reg [4:0] MEM_WB_Rc;
// IF
assign PC_plus_4 = PC + 3'd4;

always @(posedge clk or negedge reset) begin
    if(~reset)
        PC <= 32'd0;
    else if(illop && ~branch)
        PC <= ILLOP;
    else if(xadr && ~branch)
        PC <= XADR;
    else if(~load_use) begin
        if(branch)
            PC <= ID_EX_ConBA;
        else if(jump)
            PC <= {IF_ID_PC4[31:28], JT, 2'b00};
        else if(jump_reg)
            PC <= DataBusA;
        else
            PC <= PC_plus_4;
    end
end

ROM instruction_memory(.addr(PC[30:0]), .data(Instruction));
// IF/ID
always @(posedge clk or negedge reset) begin
    if(~reset) begin
        IF_ID_Instruction <= 32'd0;
        IF_ID_PC <= 32'd0;
        IF_ID_PC4 <= 32'd0;
    end
    else if(illop || xadr) begin
        IF_ID_Instruction <= 32'd0;
        IF_ID_PC <= 32'h8000_0000;
        IF_ID_PC4 <= 32'h8000_0000;
    end
    else if(branch || jump || jump_reg) begin
        IF_ID_Instruction <= 32'd0;
        IF_ID_PC <= {IF_ID_PC[31], 31'd0};
        IF_ID_PC4 <= {IF_ID_PC4[31], 31'd0};
    end
    else if(~load_use) begin
        IF_ID_Instruction <= Instruction;
        IF_ID_PC <= PC;
        IF_ID_PC4 <= PC_plus_4;
    end
end
// ID
Control control(.Instruct(IF_ID_Instruction), .IRQ(IRQ), .PC31(IF_ID_PC4[31]),
				.PCSrc(PCSrc), .RegDst(RegDst), .RegWr(RegWr), .ALUSrc1(ALUSrc1), .ALUSrc2(ALUSrc2),
				.ALUFun(ALUFun), .Sign(Sign), .MemWr(MemWr), .MemRd(MemRd), .MemToReg(MemToReg), 
				.ExtOp(ExtOp), .LUOp(LUOp));

assign JT = IF_ID_Instruction[25:0];
assign Imm16 = IF_ID_Instruction[15:0];
assign Imm32 = (ExtOp && Imm16[15]) ? {16'hffff, Imm16} : {16'h0000, Imm16};
assign Shamt = IF_ID_Instruction[10:6];
assign Rd = IF_ID_Instruction[15:11];
assign Rt = IF_ID_Instruction[20:16];
assign Rs = IF_ID_Instruction[25:21];
assign Rc = (RegDst == 2'b00)? Rd:
            (RegDst == 2'b01)? Rt:
    		(RegDst == 2'b10)? 5'd31:
		    (RegDst == 2'b11)? 5'd26:5'd0;
assign ConBA = {Imm32[29:0], 2'd0} + IF_ID_PC4;
assign load_use = (ID_EX_MemRd && (ID_EX_Rt == Rs || ID_EX_Rt == Rt));
assign jump = (PCSrc == 3'd2);
assign jump_reg = (PCSrc == 3'd3);
assign illop = (PCSrc == 3'd4);
assign xadr = (PCSrc == 3'd5);

RegFile regfile(.reset(reset), .clk(clk), .addr1(Rs), .data1(DataBusA), .addr2(Rt), .data2(DataBusB),
             .wr(MEM_WB_RegWr), .addr3(MEM_WB_Rc), .data3(MEM_WB_DataBusC));
// ID/EX
always @(posedge clk or negedge reset) begin
    if(~reset) begin
        ID_EX_DATA1 <= 32'd0;
        ID_EX_DATA2 <= 32'd0;
        ID_EX_PC <= 32'd0;
        ID_EX_Imm32 <= 32'd0;
        ID_EX_ConBA <= 32'd0;
        ID_EX_PCSrc <= 2'd0;
        ID_EX_Shamt <= 5'd0;
        ID_EX_Rs <= 5'd0;
        ID_EX_Rt <= 5'd0;
        ID_EX_Rc <= 5'd0;
        ID_EX_RegWr <= 0;
        ID_EX_ALUSrc1 <= 0;
        ID_EX_ALUSrc2 <= 0;
        ID_EX_Sign <= 0;
        ID_EX_MemWr <= 0;
        ID_EX_MemRd <= 0;
        ID_EX_MemToReg <= 2'd0;
        ID_EX_ALUFun <= 6'd0;
    end
    else begin
        ID_EX_DATA1 <= (EX_MEM_RegWr && (EX_MEM_Rc != 5'd0) && (EX_MEM_Rc == Rs)
                        && (ID_EX_Rc != Rs || ~ID_EX_RegWr))? DataBusC:
                        (ID_EX_RegWr && (ID_EX_Rc != 5'd0) && (ID_EX_Rc == Rs)) ? ALUOut:
                        (MEM_WB_RegWr && (MEM_WB_Rc != 5'd0) && (MEM_WB_Rc == Rs)) ? MEM_WB_DataBusC:DataBusA;
        ID_EX_DATA2 <= (EX_MEM_RegWr && (EX_MEM_Rc != 5'd0) && (EX_MEM_Rc == Rt)
                        && (ID_EX_Rc != Rt || ~ID_EX_RegWr))? DataBusC:
                        (ID_EX_RegWr && (ID_EX_Rc != 5'd0) && (ID_EX_Rc == Rt)) ? ALUOut:
                        (MEM_WB_RegWr && (MEM_WB_Rc != 5'd0) && (MEM_WB_Rc == Rt)) ? MEM_WB_DataBusC:DataBusB;
        ID_EX_PC <= (ID_EX_jump == 1) ? ID_EX_jump_addr:((IF_ID_Instruction[31:26] == 6'b000011)?IF_ID_PC4:((branch)?ID_EX_ConBA:(EX_MEM_branch)?EX_MEM_ConBA:IF_ID_PC));
        ID_EX_Imm32 <= LUOp ? {Imm16, 16'd0}:Imm32;
        ID_EX_ConBA <= ConBA;
        ID_EX_PCSrc <= PCSrc;
        ID_EX_Shamt <= Shamt; 
        ID_EX_Rs <= Rs;
        ID_EX_Rt <= Rt;
        if((load_use || branch) && ~xadr && ~illop) begin
            ID_EX_Rc <= 5'd0;
            ID_EX_RegWr <= 0;
            ID_EX_ALUSrc1 <= 0;
            ID_EX_ALUSrc2 <= 0;
            ID_EX_Sign <= 0;
            ID_EX_MemWr <= 0;
            ID_EX_MemRd <= 0;
            ID_EX_MemToReg <= 2'd0;
            ID_EX_ALUFun <= 5'd0;
            ID_EX_jump <= 0;
            ID_EX_jump_addr <= 32'd0;
        end
        else begin
            ID_EX_Rc <= Rc;
            ID_EX_RegWr <= RegWr;
            ID_EX_ALUSrc1 <= ALUSrc1;
            ID_EX_ALUSrc2 <= ALUSrc2;
            ID_EX_Sign <= Sign;
            ID_EX_MemWr <= MemWr;
            ID_EX_MemRd <= MemRd;
            ID_EX_MemToReg <= MemToReg;
            ID_EX_ALUFun <= ALUFun;
            ID_EX_jump <= jump;
            ID_EX_jump_addr <= {IF_ID_Instruction[31:28], JT, 2'b00};
        end
    end
end
// EX
assign ALU_In_A = ID_EX_ALUSrc1 ? {27'd0, ID_EX_Shamt} : ID_EX_DATA1;
assign ALU_In_B = ID_EX_ALUSrc2 ? ID_EX_Imm32 : ID_EX_DATA2;
assign branch = (ID_EX_PCSrc == 3'b001) && ALUOut[0];

ALU alu(.A(ALU_In_A), .B(ALU_In_B), .ALUFun(ID_EX_ALUFun), .Sign(ID_EX_Sign), .OUT(ALUOut));
// EX/MEM
always @(posedge clk or negedge reset) begin
    if(~reset) begin
        EX_MEM_RegWr <= 0;
        EX_MEM_MemWr <= 0;
        EX_MEM_MemRd <= 0;
        EX_MEM_branch <= 0;
        EX_MEM_PC <= 32'd0;
        EX_MEM_DATA2 <= 32'd0;
        EX_MEM_ALUOut <= 32'd0;
        EX_MEM_Rc <= 5'd0;
        EX_MEM_MemToReg <= 2'd0;
        EX_MEM_ConBA <= 31'd0;
    end
    else begin
        EX_MEM_RegWr <= ID_EX_RegWr;
        EX_MEM_MemWr <= ID_EX_MemWr;
        EX_MEM_MemRd <= ID_EX_MemRd;
        EX_MEM_branch <= branch;
        EX_MEM_PC <= ID_EX_PC;
        EX_MEM_DATA2 <= ID_EX_DATA2;
        EX_MEM_ALUOut <= ALUOut;
        EX_MEM_Rc <= ID_EX_Rc;
        EX_MEM_MemToReg <= ID_EX_MemToReg;
        EX_MEM_ConBA <= ID_EX_ConBA;
    end
end
// MEM
DataMem datamem(.reset(reset), .clk(clk), .rd(EX_MEM_MemRd), .wr(EX_MEM_MemWr), .addr(EX_MEM_ALUOut), .wdata(EX_MEM_DATA2), .rdata(DataMemOut));
Peripheral peripheral_pipe(.sysclk(sysclk), .reset(reset), .clk(clk), .rd(EX_MEM_MemRd), .wr(EX_MEM_MemWr), .addr(EX_MEM_ALUOut),
                     .wdata(EX_MEM_DATA2), .rdata(PeripheralOut), .led(led), .switch(switch), .digi(digi), 
                     .irqout(IRQ), .PC_Uart_rxd(UART_RX), .PC_Uart_txd(UART_TX));

assign MemOut = EX_MEM_ALUOut[30] ? PeripheralOut : DataMemOut;
assign DataBusC = (EX_MEM_MemToReg == 2'd0)? EX_MEM_ALUOut :
                (EX_MEM_MemToReg == 2'd1)? MemOut :
                (EX_MEM_MemToReg == 2'd2)? EX_MEM_PC : EX_MEM_PC;

// MEM/WB
always @(posedge clk or negedge reset) begin
    if(~reset) begin
        MEM_WB_RegWr <= 0;
        MEM_WB_DataBusC <= 32'd0;
//        MEM_WB_PC4 <= 32'd0;
        MEM_WB_Rc <= 5'd0;
    end
    else begin
        MEM_WB_RegWr <= EX_MEM_RegWr;
//        MEM_WB_PC4 <= EX_MEM_PC4;
        MEM_WB_DataBusC <= DataBusC;
        MEM_WB_Rc <= EX_MEM_Rc;
    end
end

endmodule