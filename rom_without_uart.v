`timescale 1ns/1ps

module ROM_without_UART (addr,data);
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
    ROMDATA[1] <= 32'h08000022;
    //0x8     	j	exception
    ROMDATA[2] <= 32'h08000020;
    //0xc  main:	lui		$s0,	0x4000
    ROMDATA[3] <= 32'h3c104000;
    //0x10  	addi	$s0,	$s0,	0x0000
    ROMDATA[4] <= 32'h22100000;
    //0x14  	lui		$s1,	0x4000
    ROMDATA[5] <= 32'h3c114000;
    //0x18  	addi	$s1,	$s1,	0x0008
    ROMDATA[6] <= 32'h22310008;
    //0x1c  timer:	sw	    $0,	    8($s0)
    ROMDATA[7] <= 32'hae000008;
    //0x20  	addi 	$t0, 	$0,     -30000
    ROMDATA[8] <= 32'h20088ad0;
    //0x24  	sw	    $t0,	0($s0)
    ROMDATA[9] <= 32'hae080000;
    //0x28  	addi	$t0,	$0,	    -1
    ROMDATA[10] <= 32'h2008ffff;
    //0x2c  	sw	    $t0,	4($s0)
    ROMDATA[11] <= 32'hae080004;
    //0x30  	addi	$t0,	$0,     3
    ROMDATA[12] <= 32'h20080003;
    //0x34  	sw	    $t0,	8($s0)
    ROMDATA[13] <= 32'hae080008;
    //0x38  	add	    $v0,	$0,	$0
    ROMDATA[14] <= 32'h00001020;
    //0x3c  	addi	$a0,	$0,		65
    ROMDATA[15] <= 32'h20040041;
    //0x40  	addi	$a1,	$0,		35
    ROMDATA[16] <= 32'h20050023;
    //0x44  	add		$a2,	$0, 	$a0
    ROMDATA[17] <= 32'h00043020;
    //0x48  	add		$a3, 	$0, 	$a1
    ROMDATA[18] <= 32'h00053820;
    //0x4c  	j		judge
    ROMDATA[19] <= 32'h0800001b;
    //0x50  div:	sub		$t1,	$a0,	$a1
    ROMDATA[20] <= 32'h00854822;
    //0x54  	blez	$t1,	swap
    ROMDATA[21] <= 32'h19200002;
    //0x58  	add		$a0,	$t1,	$0
    ROMDATA[22] <= 32'h01202020;
    //0x5c  	j		judge
    ROMDATA[23] <= 32'h0800001b;
    //0x60  swap:	add		$t1,	$a1,	$0
    ROMDATA[24] <= 32'h00a04820;
    //0x64  	add		$a1,	$a0,	$0
    ROMDATA[25] <= 32'h00802820;
    //0x68  	add		$a0,	$t1,	$0
    ROMDATA[26] <= 32'h01202020;
    //0x6c  judge:	bne		$a0,	$a1,	div
    ROMDATA[27] <= 32'h1485fff8;
    //0x70  	add		$v0,	$a0,	$0
    ROMDATA[28] <= 32'h00801020;
    //0x74  UART_sender:	sw		$v0,	12($s0)
    ROMDATA[29] <= 32'hae02000c;
    //0x78  	sw		$v0,	24($s0)
    ROMDATA[30] <= 32'hae020018;
    //0x7c  forever_loop:	j		forever_loop
    ROMDATA[31] <= 32'h0800001f;
    //0x80  exception:	j 		exception
    ROMDATA[32] <= 32'h08000020;
    //0x84  	jr 		$k0
    ROMDATA[33] <= 32'h03400008;
    //0x88  interrupt:	addi	$t5,	$0,		-7
    ROMDATA[34] <= 32'h200dfff9;
    //0x8c  	lui		$s7,	0x4000
    ROMDATA[35] <= 32'h3c174000;
    //0x90  	addi	$s7,	$s7,	0x0000
    ROMDATA[36] <= 32'h22f70000;
    //0x94  	lw		$t6,	8($s7)
    ROMDATA[37] <= 32'h8eee0008;
    //0x98  	and		$t5,	$t5,	$t6
    ROMDATA[38] <= 32'h01ae6824;
    //0x9c  	sw		$t5,	8($s7)
    ROMDATA[39] <= 32'haeed0008;
    //0xa0  	lw		$t5,	20($s7)
    ROMDATA[40] <= 32'h8eed0014;
    //0xa4  	andi	$s6,	$t5,	0x0F00
    ROMDATA[41] <= 32'h31b60f00;
    //0xa8  	addi	$t6,	$0,		0x100
    ROMDATA[42] <= 32'h200e0100;
    //0xac  	beq		$s6,	$0,		one_high
    ROMDATA[43] <= 32'h12c00007;
    //0xb0  	beq		$s6,	$t6,	one_low
    ROMDATA[44] <= 32'h12ce000c;
    //0xb4  	sll		$t6,	$t6,	1
    ROMDATA[45] <= 32'h000e7040;
    //0xb8  	beq		$s6,	$t6,	two_high
    ROMDATA[46] <= 32'h12ce000f;
    //0xbc  	sll		$t6,	$t6,	1
    ROMDATA[47] <= 32'h000e7040;
    //0xc0  	beq		$s6,	$t6,	two_low
    ROMDATA[48] <= 32'h12ce0013;
    //0xc4  	sll		$t6,	$t6,	1
    ROMDATA[49] <= 32'h000e7040;
    //0xc8  	beq		$s6,	$t6,	one_high
    ROMDATA[50] <= 32'h12ce0000;
    //0xcc  one_high:	andi	$t7,	$a3,	0x00f0
    ROMDATA[51] <= 32'h30ef00f0;
    //0xd0  	srl		$t7,	$t7,	4
    ROMDATA[52] <= 32'h000f7902;
    //0xd4  	jal		BCD_decode
    ROMDATA[53] <= 32'h0c000049;
    //0xd8  	addi	$t7,	$t7,	0x0100
    ROMDATA[54] <= 32'h21ef0100;
    //0xdc  	sw		$t7,	20($s7)
    ROMDATA[55] <= 32'haeef0014;
    //0xe0  	j		exit
    ROMDATA[56] <= 32'h08000089;
    //0xe4  one_low:	andi	$t7,	$a3,	0x000f
    ROMDATA[57] <= 32'h30ef000f;
    //0xe8  	jal		BCD_decode
    ROMDATA[58] <= 32'h0c000049;
    //0xec  	addi	$t7,	$t7,	0x0200
    ROMDATA[59] <= 32'h21ef0200;
    //0xf0  	sw		$t7,	20($s7)
    ROMDATA[60] <= 32'haeef0014;
    //0xf4  	j		exit
    ROMDATA[61] <= 32'h08000089;
    //0xf8  two_high:	andi	$t7,	$a2,	0x00f0
    ROMDATA[62] <= 32'h30cf00f0;
    //0xfc  	srl		$t7,	$t7,	4
    ROMDATA[63] <= 32'h000f7902;
    //0x100  	jal		BCD_decode
    ROMDATA[64] <= 32'h0c000049;
    //0x104  	addi	$t7,	$t7,	0x0400
    ROMDATA[65] <= 32'h21ef0400;
    //0x108  	sw		$t7,	20($s7)
    ROMDATA[66] <= 32'haeef0014;
    //0x10c  	j		exit
    ROMDATA[67] <= 32'h08000089;
    //0x110  two_low:	andi	$t7,	$a2,	0x000f
    ROMDATA[68] <= 32'h30cf000f;
    //0x114  	jal		BCD_decode
    ROMDATA[69] <= 32'h0c000049;
    //0x118  	addi	$t7,	$t7,	0x0800
    ROMDATA[70] <= 32'h21ef0800;
    //0x11c  	sw		$t7,	20($s7)
    ROMDATA[71] <= 32'haeef0014;
    //0x120  	j		exit
    ROMDATA[72] <= 32'h08000089;
    //0x124  BCD_decode:	addi	$t5,	$t7,	0
    ROMDATA[73] <= 32'h21ed0000;
    //0x128  	beq		$t5,	$0,		zero
    ROMDATA[74] <= 32'h11a0001e;
    //0x12c  	addi	$t5,	$t7,	-1
    ROMDATA[75] <= 32'h21edffff;
    //0x130  	beq		$t5,	$0,		one
    ROMDATA[76] <= 32'h11a0001e;
    //0x134  	addi	$t5,	$t7,	-2
    ROMDATA[77] <= 32'h21edfffe;
    //0x138  	beq		$t5,	$0,		two
    ROMDATA[78] <= 32'h11a0001e;
    //0x13c  	addi	$t5,	$t7, 	-3
    ROMDATA[79] <= 32'h21edfffd;
    //0x140  	beq 	$t5, 	$0, 	three
    ROMDATA[80] <= 32'h11a0001e;
    //0x144  	addi 	$t5, 	$t7, 	-4
    ROMDATA[81] <= 32'h21edfffc;
    //0x148  	beq 	$t5, 	$0, 	four
    ROMDATA[82] <= 32'h11a0001e;
    //0x14c  	addi	$t5,	$t7, 	-5
    ROMDATA[83] <= 32'h21edfffb;
    //0x150  	beq		$t5,	$0, 	five
    ROMDATA[84] <= 32'h11a0001e;
    //0x154  	addi	$t5, 	$t7, 	-6
    ROMDATA[85] <= 32'h21edfffa;
    //0x158  	beq 	$t5, 	$0, 	six
    ROMDATA[86] <= 32'h11a0001e;
    //0x15c  	addi 	$t5, 	$t7, 	-7
    ROMDATA[87] <= 32'h21edfff9;
    //0x160  	beq 	$t5, 	$0, 	seven
    ROMDATA[88] <= 32'h11a0001e;
    //0x164  	addi 	$t5, 	$t7, 	-8
    ROMDATA[89] <= 32'h21edfff8;
    //0x168  	beq 	$t5, 	$0, 	eight
    ROMDATA[90] <= 32'h11a0001e;
    //0x16c  	addi 	$t5, 	$t7, 	-9
    ROMDATA[91] <= 32'h21edfff7;
    //0x170  	beq 	$t5, 	$0, 	nine
    ROMDATA[92] <= 32'h11a0001e;
    //0x174  	addi 	$t5, 	$t7, 	-10
    ROMDATA[93] <= 32'h21edfff6;
    //0x178  	beq 	$t5, 	$0, 	ten
    ROMDATA[94] <= 32'h11a0001e;
    //0x17c  	addi 	$t5, 	$t7, 	-11
    ROMDATA[95] <= 32'h21edfff5;
    //0x180  	beq 	$t5, 	$0, 	eleven
    ROMDATA[96] <= 32'h11a0001e;
    //0x184  	addi 	$t5, 	$t7, 	-12
    ROMDATA[97] <= 32'h21edfff4;
    //0x188  	beq 	$t5, 	$0, 	twelve
    ROMDATA[98] <= 32'h11a0001e;
    //0x18c  	addi 	$t5, 	$t7, 	-13
    ROMDATA[99] <= 32'h21edfff3;
    //0x190  	beq 	$t5, 	$0, 	thirteen
    ROMDATA[100] <= 32'h11a0001e;
    //0x194  	addi 	$t5, 	$t7, 	-14
    ROMDATA[101] <= 32'h21edfff2;
    //0x198  	beq 	$t5, 	$0, 	fourteen
    ROMDATA[102] <= 32'h11a0001e;
    //0x19c  	addi 	$t5, 	$t7, 	-15
    ROMDATA[103] <= 32'h21edfff1;
    //0x1a0  	beq 	$t5, 	$0, 	fifteen
    ROMDATA[104] <= 32'h11a0001e;
    //0x1a4  zero:	addi 	$t7, 	$0, 	0x003f
    ROMDATA[105] <= 32'h200f003f;
    //0x1a8  	jr 		$ra
    ROMDATA[106] <= 32'h03e00008;
    //0x1ac  one:	addi 	$t7, 	$0, 	0x0006
    ROMDATA[107] <= 32'h200f0006;
    //0x1b0  	jr 		$ra
    ROMDATA[108] <= 32'h03e00008;
    //0x1b4  two:	addi 	$t7, 	$0, 	0x005b
    ROMDATA[109] <= 32'h200f005b;
    //0x1b8  	jr 		$ra
    ROMDATA[110] <= 32'h03e00008;
    //0x1bc  three:	addi 	$t7, 	$0, 	0x004f
    ROMDATA[111] <= 32'h200f004f;
    //0x1c0  	jr 		$ra
    ROMDATA[112] <= 32'h03e00008;
    //0x1c4  four:	addi 	$t7, 	$0, 	0x0066
    ROMDATA[113] <= 32'h200f0066;
    //0x1c8  	jr 		$ra
    ROMDATA[114] <= 32'h03e00008;
    //0x1cc  five:	addi 	$t7, 	$0, 	0x006d
    ROMDATA[115] <= 32'h200f006d;
    //0x1d0  	jr 		$ra
    ROMDATA[116] <= 32'h03e00008;
    //0x1d4  six:	addi 	$t7, 	$0, 	0x007d
    ROMDATA[117] <= 32'h200f007d;
    //0x1d8  	jr 		$ra
    ROMDATA[118] <= 32'h03e00008;
    //0x1dc  seven:	addi 	$t7, 	$0, 	0x0007
    ROMDATA[119] <= 32'h200f0007;
    //0x1e0  	jr 		$ra
    ROMDATA[120] <= 32'h03e00008;
    //0x1e4  eight:	addi 	$t7, 	$0, 	0x007f
    ROMDATA[121] <= 32'h200f007f;
    //0x1e8  	jr 		$ra
    ROMDATA[122] <= 32'h03e00008;
    //0x1ec  nine:	addi 	$t7, 	$0, 	0x006f
    ROMDATA[123] <= 32'h200f006f;
    //0x1f0  	jr 		$ra
    ROMDATA[124] <= 32'h03e00008;
    //0x1f4  ten:	addi 	$t7, 	$0, 	0x0077
    ROMDATA[125] <= 32'h200f0077;
    //0x1f8  	jr 		$ra
    ROMDATA[126] <= 32'h03e00008;
    //0x1fc  eleven:	addi 	$t7, 	$0, 	0x007c
    ROMDATA[127] <= 32'h200f007c;
    //0x200  	jr		$ra
    ROMDATA[128] <= 32'h03e00008;
    //0x204  twelve:	addi 	$t7, 	$0, 	0x0039
    ROMDATA[129] <= 32'h200f0039;
    //0x208  	jr 		$ra
    ROMDATA[130] <= 32'h03e00008;
    //0x20c  thirteen:	addi 	$t7, 	$0, 	0x005e
    ROMDATA[131] <= 32'h200f005e;
    //0x210  	jr 		$ra
    ROMDATA[132] <= 32'h03e00008;
    //0x214  fourteen:	addi 	$t7, 	$0, 	0x0079
    ROMDATA[133] <= 32'h200f0079;
    //0x218  	jr 		$ra
    ROMDATA[134] <= 32'h03e00008;
    //0x21c  fifteen:	addi 	$t7, 	$0, 	0x0071
    ROMDATA[135] <= 32'h200f0071;
    //0x220  	jr 		$ra
    ROMDATA[136] <= 32'h03e00008;
    //0x224  exit:	lui 	$s7, 	0x4000
    ROMDATA[137] <= 32'h3c174000;
    //0x228  	addi	$s7,	$s7,	0x0000
    ROMDATA[138] <= 32'h22f70000;
    //0x22c  	lw 		$t6, 	8($s7)
    ROMDATA[139] <= 32'h8eee0008;
    //0x230  	addi 	$t7, 	$0, 	2
    ROMDATA[140] <= 32'h200f0002;
    //0x234  	or 		$t6, 	$t7, 	$t6
    ROMDATA[141] <= 32'h01ee7025;
    //0x238  	sw 		$t6, 	8($s7)
    ROMDATA[142] <= 32'haeee0008;
    //0x23c  	jr 		$k0
    ROMDATA[143] <= 32'h03400008;

	for (i = 144; i < ROM_SIZE; i = i + 1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
