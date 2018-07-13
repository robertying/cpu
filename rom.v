`timescale 1ns/1ps

module ROM (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr < 4 * ROM_SIZE) ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    //0x0  	j	main
    ROMDATA[0] <= 32'h08000003;
    //0x4  	j	interrupt
    ROMDATA[1] <= 32'h08000021;
    //0x8     	j	exception
    ROMDATA[2] <= 32'h08000020;
    //0xc  main:	lui	$s0,	0x4000
    ROMDATA[3] <= 32'h3c104000;
    //0x10  	addi	$s0,	$s0,	0x0000
    ROMDATA[4] <= 32'h22100000;
    //0x14  	lui	$s1,	0x4000
    ROMDATA[5] <= 32'h3c114000;
    //0x18  	addi	$s1,	$s1,	0x0002
    ROMDATA[6] <= 32'h22310002;
    //0x1c  timer:	sw	$0,	8($s0)
    ROMDATA[7] <= 32'hae000008;
    //0x20  	addi	$t0,	$0,	-1000
    ROMDATA[8] <= 32'h2008fc18;
    //0x24  	sw	$t0,	0($s0)
    ROMDATA[9] <= 32'hae080000;
    //0x28  	addi	$t0,	$0,	-1
    ROMDATA[10] <= 32'h2008ffff;
    //0x2c  	sw	$t0,	4($s0)
    ROMDATA[11] <= 32'hae080004;
    //0x30  	addi	$t0,	$0,	3
    ROMDATA[12] <= 32'h20080003;
    //0x34  	sw	$t0,	8($s0)
    ROMDATA[13] <= 32'hae080008;
    //0x38  	add	$v0,	$0,	$0 
    ROMDATA[14] <= 32'h00001020;
    //0x3c      addi    $a0,    $0, 12
    ROMDATA[15] <= 32'h2004000c;
    //0x40      addi    $a0,    $0, 84    
    ROMDATA[16] <= 32'h20040054;
    //0x44  	add	$a2,	$0,	$a0
    ROMDATA[17] <= 32'h00043020;
    //0x48  	add	$a3,	$0,	$a1
    ROMDATA[18] <= 32'h00053820;
    //0x4c  	j	judge
    ROMDATA[19] <= 32'h0800001b;
    //0x50  div:	sub	$t1,	$a0,	$a1
    ROMDATA[20] <= 32'h00854822;
    //0x54  	blez	$t1,	swap
    ROMDATA[21] <= 32'h19200002;
    //0x58  	add	$a0,	$t1,	$0
    ROMDATA[22] <= 32'h01202020;
    //0x5c  	j	judge
    ROMDATA[23] <= 32'h0800001b;
    //0x60  swap:	add	$t1,	$a1,	$0
    ROMDATA[24] <= 32'h00a04820;
    //0x64  	add	$a1,	$a0,	$0
    ROMDATA[25] <= 32'h00802820;
    //0x68  	add	$a0,	$t1,	$0
    ROMDATA[26] <= 32'h01202020;
    //0x6c  judge:	bne	$a0,	$a1,	div
    ROMDATA[27] <= 32'h1485fff8;
    //0x70  	add	$v0,	$a0,	$0
    ROMDATA[28] <= 32'h00801020;
    //0x74  UART_sender:	sw	$v0,	24($s0)
    ROMDATA[29] <= 32'hae020018;
    //0x78  forever_loop:	add	$v1,	$0,	$0,
    ROMDATA[30] <= 32'h00001820;
    //0x7c  	j	forever_loop
    ROMDATA[31] <= 32'h0800001e;
    //0x80  exception:	jr	$k0
    ROMDATA[32] <= 32'h03400008;
    //0x84  interrupt:	addi	$t5,	$0,	-7
    ROMDATA[33] <= 32'h200dfff9;
    //0x88  	lui	$s7,	0x4000
    ROMDATA[34] <= 32'h3c174000;
    //0x8c  	addi	$s7,	$s7,	0x0000
    ROMDATA[35] <= 32'h22f70000;
    //0x90  	lw	$t6,	8($s7)
    ROMDATA[36] <= 32'h8eee0008;
    //0x94  	and	$t5,	$t5,	$t6
    ROMDATA[37] <= 32'h01ae6824;
    //0x98  	sw	$t5,	8($s7)
    ROMDATA[38] <= 32'haeed0008;
    //0x9c  	lw	$t5,	20($s7)
    ROMDATA[39] <= 32'h8eed0014;
    //0xa0  	andi	$s6,	$t5,	0x0F00
    ROMDATA[40] <= 32'h31b60f00;
    //0xa4  	addi	$t6,	$0,	0x100
    ROMDATA[41] <= 32'h200e0100;
    //0xa8  	beq	$s6,	$0,	one_high
    ROMDATA[42] <= 32'h12c00007;
    //0xac  	beq	$s6,	$t6,	one_low
    ROMDATA[43] <= 32'h12ce000c;
    //0xb0  	sll	$t6,	$t6,	1
    ROMDATA[44] <= 32'h000e7040;
    //0xb4  	beq	$s6,	$t6,	two_high
    ROMDATA[45] <= 32'h12ce000f;
    //0xb8  	sll	$t6,	$t6,	1
    ROMDATA[46] <= 32'h000e7040;
    //0xbc  	beq	$s6,	$t6,	two_low
    ROMDATA[47] <= 32'h12ce0013;
    //0xc0  	sll	$t6,	$t6,	1
    ROMDATA[48] <= 32'h000e7040;
    //0xc4  	beq	$s6,	$t6,	one_high
    ROMDATA[49] <= 32'h12ce0000;
    //0xc8  one_high:	andi	$t7,	$a3,	0x00f0
    ROMDATA[50] <= 32'h30ef00f0;
    //0xcc  	srl	$t7,	$t7,	4
    ROMDATA[51] <= 32'h000f7902;
    //0xd0  	jal	BCD_decode
    ROMDATA[52] <= 32'h0c000048;
    //0xd4  	addi	$t7,	$t7,	0x0100
    ROMDATA[53] <= 32'h21ef0100;
    //0xd8  	sw	$t7,	20($s7)
    ROMDATA[54] <= 32'haeef0014;
    //0xdc  	j	exit
    ROMDATA[55] <= 32'h08000088;
    //0xe0  one_low:	andi	$t7,	$a3,	0x000f
    ROMDATA[56] <= 32'h30ef000f;
    //0xe4  	jal	BCD_decode
    ROMDATA[57] <= 32'h0c000048;
    //0xe8  	addi	$t7,	$t7,	0x0200
    ROMDATA[58] <= 32'h21ef0200;
    //0xec  	sw	$t7,	20($s7)
    ROMDATA[59] <= 32'haeef0014;
    //0xf0  	j	exit
    ROMDATA[60] <= 32'h08000088;
    //0xf4  two_high:	andi	$t7,	$a2,	0x00f0
    ROMDATA[61] <= 32'h30cf00f0;
    //0xf8  	srl	$t7,	$t7,	4
    ROMDATA[62] <= 32'h000f7902;
    //0xfc  	jal	BCD_decode
    ROMDATA[63] <= 32'h0c000048;
    //0x100  	addi	$t7,	$t7,	0x0400
    ROMDATA[64] <= 32'h21ef0400;
    //0x104  	sw	$t7,	20($s7)
    ROMDATA[65] <= 32'haeef0014;
    //0x108  	j	exit
    ROMDATA[66] <= 32'h08000088;
    //0x10c  two_low:	andi	$t7,	$a2,	0x000f
    ROMDATA[67] <= 32'h30cf000f;
    //0x110  	jal	BCD_decode
    ROMDATA[68] <= 32'h0c000048;
    //0x114  	addi	$t7,	$t7,	0x0800
    ROMDATA[69] <= 32'h21ef0800;
    //0x118  	sw	$t7,	20($s7)
    ROMDATA[70] <= 32'haeef0014;
    //0x11c  	j	exit
    ROMDATA[71] <= 32'h08000088;
    //0x120  BCD_decode:	addi	$t5,	$t7,	0
    ROMDATA[72] <= 32'h21ed0000;
    //0x124  	beq	$t5,	$0,	zero
    ROMDATA[73] <= 32'h11a0001e;
    //0x128  	addi	$t5,	$t7,	-1
    ROMDATA[74] <= 32'h21edffff;
    //0x12c  	beq	$t5,	$0,	one
    ROMDATA[75] <= 32'h11a0001e;
    //0x130  	addi	$t5,	$t7,	-2
    ROMDATA[76] <= 32'h21edfffe;
    //0x134  	beq	$t5,	$0,	two
    ROMDATA[77] <= 32'h11a0001e;
    //0x138  	addi	$t5,	$t7, 	-3
    ROMDATA[78] <= 32'h21edfffd;
    //0x13c  	beq 	$t5, 	$0, 	three
    ROMDATA[79] <= 32'h11a0001e;
    //0x140  	addi 	$t5, 	$t7, 	-4
    ROMDATA[80] <= 32'h21edfffc;
    //0x144  	beq 	$t5, 	$0, 	four
    ROMDATA[81] <= 32'h11a0001e;
    //0x148  	addi	$t5,	$t7, 	-5
    ROMDATA[82] <= 32'h21edfffb;
    //0x14c  	beq	$t5,	$0, 	five
    ROMDATA[83] <= 32'h11a0001e;
    //0x150  	addi	$t5, 	$t7, 	-6
    ROMDATA[84] <= 32'h21edfffa;
    //0x154  	beq 	$t5, 	$0, 	six
    ROMDATA[85] <= 32'h11a0001e;
    //0x158  	addi 	$t5, 	$t7, 	-7
    ROMDATA[86] <= 32'h21edfff9;
    //0x15c  	beq 	$t5, 	$0, 	seven
    ROMDATA[87] <= 32'h11a0001e;
    //0x160  	addi 	$t5, 	$t7, 	-8
    ROMDATA[88] <= 32'h21edfff8;
    //0x164  	beq 	$t5, 	$0, 	eight
    ROMDATA[89] <= 32'h11a0001e;
    //0x168  	addi 	$t5, 	$t7, 	-9
    ROMDATA[90] <= 32'h21edfff7;
    //0x16c  	beq 	$t5, 	$0, 	nine
    ROMDATA[91] <= 32'h11a0001e;
    //0x170  	addi 	$t5, 	$t7, 	-10
    ROMDATA[92] <= 32'h21edfff6;
    //0x174  	beq 	$t5, 	$0, 	ten
    ROMDATA[93] <= 32'h11a0001e;
    //0x178  	addi 	$t5, 	$t7, 	-11
    ROMDATA[94] <= 32'h21edfff5;
    //0x17c  	beq 	$t5, 	$0, 	eleven
    ROMDATA[95] <= 32'h11a0001e;
    //0x180  	addi 	$t5, 	$t7, 	-12
    ROMDATA[96] <= 32'h21edfff4;
    //0x184  	beq 	$t5, 	$0, 	twelve
    ROMDATA[97] <= 32'h11a0001e;
    //0x188  	addi 	$t5, 	$t7, 	-13
    ROMDATA[98] <= 32'h21edfff3;
    //0x18c  	beq 	$t5, 	$0, 	thirteen
    ROMDATA[99] <= 32'h11a0001e;
    //0x190  	addi 	$t5, 	$t7, 	-14
    ROMDATA[100] <= 32'h21edfff2;
    //0x194  	beq 	$t5, 	$0, 	fourteen
    ROMDATA[101] <= 32'h11a0001e;
    //0x198  	addi 	$t5, 	$t7, 	-15
    ROMDATA[102] <= 32'h21edfff1;
    //0x19c  	beq 	$t5, 	$0, 	fifteen
    ROMDATA[103] <= 32'h11a0001e;
    //0x1a0  zero:	addi 	$t7, 	$0, 	0x0040
    ROMDATA[104] <= 32'h200f0040;
    //0x1a4  	jr 	$ra
    ROMDATA[105] <= 32'h03e00008;
    //0x1a8  one:	addi 	$t7, 	$0, 	0x0079
    ROMDATA[106] <= 32'h200f0079;
    //0x1ac  	jr 	$ra
    ROMDATA[107] <= 32'h03e00008;
    //0x1b0  two:	addi 	$t7, 	$0, 	0x0024
    ROMDATA[108] <= 32'h200f0024;
    //0x1b4  	jr 	$ra
    ROMDATA[109] <= 32'h03e00008;
    //0x1b8  three:	addi 	$t7, 	$0, 	0x0030
    ROMDATA[110] <= 32'h200f0030;
    //0x1bc  	jr 	$ra
    ROMDATA[111] <= 32'h03e00008;
    //0x1c0  four:	addi 	$t7, 	$0, 	0x0019
    ROMDATA[112] <= 32'h200f0019;
    //0x1c4  	jr 	$ra
    ROMDATA[113] <= 32'h03e00008;
    //0x1c8  five:	addi 	$t7, 	$0, 	0x0012
    ROMDATA[114] <= 32'h200f0012;
    //0x1cc  	jr 	$ra
    ROMDATA[115] <= 32'h03e00008;
    //0x1d0  six:	addi 	$t7, 	$0, 	0x0002
    ROMDATA[116] <= 32'h200f0002;
    //0x1d4  	jr 	$ra
    ROMDATA[117] <= 32'h03e00008;
    //0x1d8  seven:	addi 	$t7, 	$0, 	0x0078
    ROMDATA[118] <= 32'h200f0078;
    //0x1dc  	jr 	$ra
    ROMDATA[119] <= 32'h03e00008;
    //0x1e0  eight:	addi 	$t7, 	$0, 	0x0000
    ROMDATA[120] <= 32'h200f0000;
    //0x1e4  	jr 	$ra
    ROMDATA[121] <= 32'h03e00008;
    //0x1e8  nine:	addi 	$t7, 	$0, 	0x0010
    ROMDATA[122] <= 32'h200f0010;
    //0x1ec  	jr 	$ra
    ROMDATA[123] <= 32'h03e00008;
    //0x1f0  ten:	addi 	$t7, 	$0, 	0x0008
    ROMDATA[124] <= 32'h200f0008;
    //0x1f4  	jr 	$ra
    ROMDATA[125] <= 32'h03e00008;
    //0x1f8  eleven:	addi 	$t7, 	$0, 	0x0003
    ROMDATA[126] <= 32'h200f0003;
    //0x1fc  	jr	$ra
    ROMDATA[127] <= 32'h03e00008;
    //0x200  twelve:	addi 	$t7, 	$0, 	0x0046
    ROMDATA[128] <= 32'h200f0046;
    //0x204  	jr 	$ra
    ROMDATA[129] <= 32'h03e00008;
    //0x208  thirteen:	addi 	$t7, 	$0, 	0x0021
    ROMDATA[130] <= 32'h200f0021;
    //0x20c  	jr 	$ra
    ROMDATA[131] <= 32'h03e00008;
    //0x210  fourteen:	addi 	$t7, 	$0, 	0x0006
    ROMDATA[132] <= 32'h200f0006;
    //0x214  	jr 	$ra
    ROMDATA[133] <= 32'h03e00008;
    //0x218  fifteen:	addi 	$t7, 	$0, 	0x000E
    ROMDATA[134] <= 32'h200f000e;
    //0x21c  	jr 	$ra
    ROMDATA[135] <= 32'h03e00008;
    //0x220  exit:	lui 	$s7, 	0x4000
    ROMDATA[136] <= 32'h3c174000;
    //0x224  	addi	$s7,	$s7,	0x0000
    ROMDATA[137] <= 32'h22f70000;
    //0x228  	lw 	$t6, 	8($s7)
    ROMDATA[138] <= 32'h8eee0008;
    //0x22c  	addi 	$t7, 	$0, 	2
    ROMDATA[139] <= 32'h200f0002;
    //0x230  	or 	$t6, 	$t7, 	$t6
    ROMDATA[140] <= 32'h01ee7025;
    //0x234  	sw 	$t6, 	0($s7)
    ROMDATA[141] <= 32'haeee0000;
    //0x238  	jr 	$k0
    ROMDATA[142] <= 32'h03400008;


	for (i = 143; i < ROM_SIZE; i = i + 1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
