module Control_tb;

reg [31:0] Instruct;
reg IRQ;
reg PC31;

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

initial begin
	// nop
    Instruct <= 32'b0;
    IRQ <= 0;
    PC31 <= 0;
end

initial begin
	// lw	$a0,	0($sp)
    // 32'h8fa40000
	#100	Instruct <= {6'h23, 5'd29, 5'd4, 16'h0000};
	// sw	$ra,	4($sp)
    // 32'hafbf0004
	#100	Instruct <= {6'h2b, 5'd29, 5'd31, 16'h0004};
	// lui	$t1,	100
	// 32'h3c090064
	#100	Instruct <= 32'h3c090064;
	// add	$v0,	$a0,	$v0
    // 32'h00821020
	#100	Instruct <= {6'h00, 5'd4, 5'd2, 5'd2, 5'd0, 6'h20};
	// addu	$t1,	$t2,	$t3
	// 32'h014b4821
	#100	Instruct <= 32'h014b4821;
	// sub	$t1,	$t2,	$t3
	// 32'h014b4822
	#100	Instruct <= 32'h014b4822;
	// subu	$t1,	$t2,	$t3
	// 32'h014b4823
	#100	Instruct <= 32'h014b4823;
	// addi	$a0,	$zero,	3
    // 32'h20040003
    #100	Instruct <= {6'h08, 5'd0, 5'd4, 16'h0003};
	// addiu	$t1,	$t2,	-100
	// 32'h2549ff9c
	#100	Instruct <= 32'h2549ff9c;
	// and	$t1,	$t2,	$t3
	// 32'h014b4824
	#100	Instruct <= 32'h014b4824;
	// or	$t1,	$t2,	$t3
	// 32'h014b4825
	#100	Instruct <= 32'h014b4825;
	// xor	$v0,	$zero,	$zero
    // 32'h00001026
	#100	Instruct <= {6'h00, 5'd0, 5'd0, 5'd2, 5'd0, 6'h26};
	// nor	$t1,	$t2,	$t3
	// 32'h014b4827
	#100	Instruct <= 32'h014b4827;
	// andi	$t1,	$t2,	100
	// 32'h31490064
	#100	Instruct <= 32'h31490064;
	// sll	$t1,	$t2,	10
	// 32'h000a4a80
	#100	Instruct <= 32'h000a4a80;
	// srl	$t1,	$t2,	10
	// 32'h000a4882
	#100	Instruct <= 32'h000a4882;
	// sra	$t1,	$t2,	10
	// 32'h000a4883
	#100	Instruct <= 32'h000a4883;
	// slt	$t1,	$t2,	$t3
	// 32'h014b482a
	#100	Instruct <= 32'h014b482a;
	// slti	$t0,	$a0,	1
    // 32'h28880001
	#100	Instruct <= {6'h0a, 5'd4, 5'd8, 16'h0001};
	// sltiu	$t1,	$t2,	-100
	// 32'h2d49ff9c
	#100	Instruct <= 32'h2d49ff9c;
	// beq	$zero,	$zero,	Loop
    // 32'h1000ffff
	#100	Instruct <= {6'h04, 5'd0, 5'd0, 16'hffff};
	// bne	$t1,	$t2,	Loop
	// 32'h152affff
	#100	Instruct <= 32'h152affff;
	// blez	$t1,	Loop
	// 32'h1920fffe
	#100	Instruct <= 32'h1920fffe;
	// bgtz	$t1,	Loop
	// 32'h1d20fffd
	#100	Instruct <= 32'h1d20fffd;
	// bltz	$t1,	Loop
	// 32'h0520fffc
	#100	Instruct <= 32'h0520fffc;
	// j	Loop
	// 32'h0810000e
	#100	Instruct <= 32'h0810000e;
	// jal	sum
    // 32'h0c000003
	#100	Instruct <= {6'h03, 26'd3};
	// jr	$ra
    // 32'h03e00008
	#100	Instruct <= {6'h00, 5'd31, 15'd0, 6'h08};
	// jalr	$t1
	// 32'h0120f809
	#100	Instruct <= 32'h0120f809;
	// 异常
	#100	Instruct <= 32'hffffffff;
	// 中断
	#200	IRQ <= 1;
	// 内核态异常(应被禁止)
	#100	IRQ <= 0;
			PC31 <= 1;
	// 内核态中断(应被禁止)
	#100	IRQ <=1;
end

Control Control_test(Instruct, IRQ, PC31,
                    PCSrc, RegDst, RegWr, ALUSrc1, ALUSrc2,
	                ALUFun, Sign, MemWr, MemRd, MemToReg, 
	                ExtOp, LUOp);

endmodule