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
    ROMDATA[1] <= 32'h08000023;
    //0x8     	j	exception
    ROMDATA[2] <= 32'h08000021;
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
    //0x20  	lui		$t0,    0xfd05
    ROMDATA[8] <= 32'h3c08fd05;
    //0x24  	add 	$t0, 	$t0,	$0
    ROMDATA[9] <= 32'h01004020;
    //0x28  	sw	    $t0,	0($s0)
    ROMDATA[10] <= 32'hae080000;
    //0x2c  	addi	$t0,	$0,	-1
    ROMDATA[11] <= 32'h2008ffff;
    //0x30  	sw	    $t0,	4($s0)
    ROMDATA[12] <= 32'hae080004;
    //0x34  	addi	$t0,	$0,	3
    ROMDATA[13] <= 32'h20080003;
    //0x38  	sw	    $t0,	8($s0)
    ROMDATA[14] <= 32'hae080008;
    //0x3c  	add	    $v0,	$0,	$0
    ROMDATA[15] <= 32'h00001020;
    //0x40  	addi	$a0,	$0,		65
    ROMDATA[16] <= 32'h20040041;
    //0x44  	addi	$a1,	$0,		35
    ROMDATA[17] <= 32'h20050023;
    //0x48  	add		$a2,	$0, 	$a0
    ROMDATA[18] <= 32'h00043020;
    //0x4c  	add		$a3, 	$0, 	$a1
    ROMDATA[19] <= 32'h00053820;
    //0x50  	j		judge
    ROMDATA[20] <= 32'h0800001c;
    //0x54  div:	sub		$t1,	$a0,	$a1
    ROMDATA[21] <= 32'h00854822;
    //0x58  	blez	$t1,	swap
    ROMDATA[22] <= 32'h19200002;
    //0x5c  	add		$a0,	$t1,	$0
    ROMDATA[23] <= 32'h01202020;
    //0x60  	j		judge
    ROMDATA[24] <= 32'h0800001c;
    //0x64  swap:	add		$t1,	$a1,	$0
    ROMDATA[25] <= 32'h00a04820;
    //0x68  	add		$a1,	$a0,	$0
    ROMDATA[26] <= 32'h00802820;
    //0x6c  	add		$a0,	$t1,	$0
    ROMDATA[27] <= 32'h01202020;
    //0x70  judge:	bne		$a0,	$a1,	div
    ROMDATA[28] <= 32'h1485fff8;
    //0x74  	add		$v0,	$a0,	$0
    ROMDATA[29] <= 32'h00801020;
    //0x78  UART_sender:	sw		$v0,	12($s0)
    ROMDATA[30] <= 32'hae02000c;
    //0x7c  	sw		$v0,	24($s0)
    ROMDATA[31] <= 32'hae020018;
    //0x80  forever_loop:	j		forever_loop
    ROMDATA[32] <= 32'h08000020;
    //0x84  exception:	j 		exception
    ROMDATA[33] <= 32'h08000021;
    //0x88  	jr 		$k0
    ROMDATA[34] <= 32'h03400008;
    //0x8c  interrupt:	addi	$t5,	$0,		-7
    ROMDATA[35] <= 32'h200dfff9;
    //0x90  	lui		$s7,	0x4000
    ROMDATA[36] <= 32'h3c174000;
    //0x94  	addi	$s7,	$s7,	0x0000
    ROMDATA[37] <= 32'h22f70000;
    //0x98  	lw		$t6,	8($s7)
    ROMDATA[38] <= 32'h8eee0008;
    //0x9c  	and		$t5,	$t5,	$t6
    ROMDATA[39] <= 32'h01ae6824;
    //0xa0  	sw		$t5,	8($s7)
    ROMDATA[40] <= 32'haeed0008;
    //0xa4  	lw		$t5,	20($s7)
    ROMDATA[41] <= 32'h8eed0014;
    //0xa8  	andi	$s6,	$t5,	0x0F00
    ROMDATA[42] <= 32'h31b60f00;
    //0xac  	addi	$t6,	$0,		0x100
    ROMDATA[43] <= 32'h200e0100;
    //0xb0  	beq		$s6,	$0,		one_high
    ROMDATA[44] <= 32'h12c00007;
    //0xb4  	beq		$s6,	$t6,	one_low
    ROMDATA[45] <= 32'h12ce000c;
    //0xb8  	sll		$t6,	$t6,	1
    ROMDATA[46] <= 32'h000e7040;
    //0xbc  	beq		$s6,	$t6,	two_high
    ROMDATA[47] <= 32'h12ce000f;
    //0xc0  	sll		$t6,	$t6,	1
    ROMDATA[48] <= 32'h000e7040;
    //0xc4  	beq		$s6,	$t6,	two_low
    ROMDATA[49] <= 32'h12ce0013;
    //0xc8  	sll		$t6,	$t6,	1
    ROMDATA[50] <= 32'h000e7040;
    //0xcc  	beq		$s6,	$t6,	one_high
    ROMDATA[51] <= 32'h12ce0000;
    //0xd0  one_high:	andi	$t7,	$a3,	0x00f0
    ROMDATA[52] <= 32'h30ef00f0;
    //0xd4  	srl		$t7,	$t7,	4
    ROMDATA[53] <= 32'h000f7902;
    //0xd8  	jal		BCD_decode
    ROMDATA[54] <= 32'h0c00004a;
    //0xdc  	addi	$t7,	$t7,	0x0100
    ROMDATA[55] <= 32'h21ef0100;
    //0xe0  	sw		$t7,	20($s7)
    ROMDATA[56] <= 32'haeef0014;
    //0xe4  	j		exit
    ROMDATA[57] <= 32'h0800008a;
    //0xe8  one_low:	andi	$t7,	$a3,	0x000f
    ROMDATA[58] <= 32'h30ef000f;
    //0xec  	jal		BCD_decode
    ROMDATA[59] <= 32'h0c00004a;
    //0xf0  	addi	$t7,	$t7,	0x0200
    ROMDATA[60] <= 32'h21ef0200;
    //0xf4  	sw		$t7,	20($s7)
    ROMDATA[61] <= 32'haeef0014;
    //0xf8  	j		exit
    ROMDATA[62] <= 32'h0800008a;
    //0xfc  two_high:	andi	$t7,	$a2,	0x00f0
    ROMDATA[63] <= 32'h30cf00f0;
    //0x100  	srl		$t7,	$t7,	4
    ROMDATA[64] <= 32'h000f7902;
    //0x104  	jal		BCD_decode
    ROMDATA[65] <= 32'h0c00004a;
    //0x108  	addi	$t7,	$t7,	0x0400
    ROMDATA[66] <= 32'h21ef0400;
    //0x10c  	sw		$t7,	20($s7)
    ROMDATA[67] <= 32'haeef0014;
    //0x110  	j		exit
    ROMDATA[68] <= 32'h0800008a;
    //0x114  two_low:	andi	$t7,	$a2,	0x000f
    ROMDATA[69] <= 32'h30cf000f;
    //0x118  	jal		BCD_decode
    ROMDATA[70] <= 32'h0c00004a;
    //0x11c  	addi	$t7,	$t7,	0x0800
    ROMDATA[71] <= 32'h21ef0800;
    //0x120  	sw		$t7,	20($s7)
    ROMDATA[72] <= 32'haeef0014;
    //0x124  	j		exit
    ROMDATA[73] <= 32'h0800008a;
    //0x128  BCD_decode:	addi	$t5,	$t7,	0
    ROMDATA[74] <= 32'h21ed0000;
    //0x12c  	beq		$t5,	$0,		zero
    ROMDATA[75] <= 32'h11a0001e;
    //0x130  	addi	$t5,	$t7,	-1
    ROMDATA[76] <= 32'h21edffff;
    //0x134  	beq		$t5,	$0,		one
    ROMDATA[77] <= 32'h11a0001e;
    //0x138  	addi	$t5,	$t7,	-2
    ROMDATA[78] <= 32'h21edfffe;
    //0x13c  	beq		$t5,	$0,		two
    ROMDATA[79] <= 32'h11a0001e;
    //0x140  	addi	$t5,	$t7, 	-3
    ROMDATA[80] <= 32'h21edfffd;
    //0x144  	beq 	$t5, 	$0, 	three
    ROMDATA[81] <= 32'h11a0001e;
    //0x148  	addi 	$t5, 	$t7, 	-4
    ROMDATA[82] <= 32'h21edfffc;
    //0x14c  	beq 	$t5, 	$0, 	four
    ROMDATA[83] <= 32'h11a0001e;
    //0x150  	addi	$t5,	$t7, 	-5
    ROMDATA[84] <= 32'h21edfffb;
    //0x154  	beq		$t5,	$0, 	five
    ROMDATA[85] <= 32'h11a0001e;
    //0x158  	addi	$t5, 	$t7, 	-6
    ROMDATA[86] <= 32'h21edfffa;
    //0x15c  	beq 	$t5, 	$0, 	six
    ROMDATA[87] <= 32'h11a0001e;
    //0x160  	addi 	$t5, 	$t7, 	-7
    ROMDATA[88] <= 32'h21edfff9;
    //0x164  	beq 	$t5, 	$0, 	seven
    ROMDATA[89] <= 32'h11a0001e;
    //0x168  	addi 	$t5, 	$t7, 	-8
    ROMDATA[90] <= 32'h21edfff8;
    //0x16c  	beq 	$t5, 	$0, 	eight
    ROMDATA[91] <= 32'h11a0001e;
    //0x170  	addi 	$t5, 	$t7, 	-9
    ROMDATA[92] <= 32'h21edfff7;
    //0x174  	beq 	$t5, 	$0, 	nine
    ROMDATA[93] <= 32'h11a0001e;
    //0x178  	addi 	$t5, 	$t7, 	-10
    ROMDATA[94] <= 32'h21edfff6;
    //0x17c  	beq 	$t5, 	$0, 	ten
    ROMDATA[95] <= 32'h11a0001e;
    //0x180  	addi 	$t5, 	$t7, 	-11
    ROMDATA[96] <= 32'h21edfff5;
    //0x184  	beq 	$t5, 	$0, 	eleven
    ROMDATA[97] <= 32'h11a0001e;
    //0x188  	addi 	$t5, 	$t7, 	-12
    ROMDATA[98] <= 32'h21edfff4;
    //0x18c  	beq 	$t5, 	$0, 	twelve
    ROMDATA[99] <= 32'h11a0001e;
    //0x190  	addi 	$t5, 	$t7, 	-13
    ROMDATA[100] <= 32'h21edfff3;
    //0x194  	beq 	$t5, 	$0, 	thirteen
    ROMDATA[101] <= 32'h11a0001e;
    //0x198  	addi 	$t5, 	$t7, 	-14
    ROMDATA[102] <= 32'h21edfff2;
    //0x19c  	beq 	$t5, 	$0, 	fourteen
    ROMDATA[103] <= 32'h11a0001e;
    //0x1a0  	addi 	$t5, 	$t7, 	-15
    ROMDATA[104] <= 32'h21edfff1;
    //0x1a4  	beq 	$t5, 	$0, 	fifteen
    ROMDATA[105] <= 32'h11a0001e;
    //0x1a8  zero:	addi 	$t7, 	$0, 	0x003f
    ROMDATA[106] <= 32'h200f003f;
    //0x1ac  	jr 		$ra
    ROMDATA[107] <= 32'h03e00008;
    //0x1b0  one:	addi 	$t7, 	$0, 	0x0006
    ROMDATA[108] <= 32'h200f0006;
    //0x1b4  	jr 		$ra
    ROMDATA[109] <= 32'h03e00008;
    //0x1b8  two:	addi 	$t7, 	$0, 	0x005b
    ROMDATA[110] <= 32'h200f005b;
    //0x1bc  	jr 		$ra
    ROMDATA[111] <= 32'h03e00008;
    //0x1c0  three:	addi 	$t7, 	$0, 	0x004f
    ROMDATA[112] <= 32'h200f004f;
    //0x1c4  	jr 		$ra
    ROMDATA[113] <= 32'h03e00008;
    //0x1c8  four:	addi 	$t7, 	$0, 	0x0066
    ROMDATA[114] <= 32'h200f0066;
    //0x1cc  	jr 		$ra
    ROMDATA[115] <= 32'h03e00008;
    //0x1d0  five:	addi 	$t7, 	$0, 	0x006d
    ROMDATA[116] <= 32'h200f006d;
    //0x1d4  	jr 		$ra
    ROMDATA[117] <= 32'h03e00008;
    //0x1d8  six:	addi 	$t7, 	$0, 	0x007d
    ROMDATA[118] <= 32'h200f007d;
    //0x1dc  	jr 		$ra
    ROMDATA[119] <= 32'h03e00008;
    //0x1e0  seven:	addi 	$t7, 	$0, 	0x0007
    ROMDATA[120] <= 32'h200f0007;
    //0x1e4  	jr 		$ra
    ROMDATA[121] <= 32'h03e00008;
    //0x1e8  eight:	addi 	$t7, 	$0, 	0x007f
    ROMDATA[122] <= 32'h200f007f;
    //0x1ec  	jr 		$ra
    ROMDATA[123] <= 32'h03e00008;
    //0x1f0  nine:	addi 	$t7, 	$0, 	0x006f
    ROMDATA[124] <= 32'h200f006f;
    //0x1f4  	jr 		$ra
    ROMDATA[125] <= 32'h03e00008;
    //0x1f8  ten:	addi 	$t7, 	$0, 	0x0077
    ROMDATA[126] <= 32'h200f0077;
    //0x1fc  	jr 		$ra
    ROMDATA[127] <= 32'h03e00008;
    //0x200  eleven:	addi 	$t7, 	$0, 	0x007c
    ROMDATA[128] <= 32'h200f007c;
    //0x204  	jr		$ra
    ROMDATA[129] <= 32'h03e00008;
    //0x208  twelve:	addi 	$t7, 	$0, 	0x0039
    ROMDATA[130] <= 32'h200f0039;
    //0x20c  	jr 		$ra
    ROMDATA[131] <= 32'h03e00008;
    //0x210  thirteen:	addi 	$t7, 	$0, 	0x005e
    ROMDATA[132] <= 32'h200f005e;
    //0x214  	jr 		$ra
    ROMDATA[133] <= 32'h03e00008;
    //0x218  fourteen:	addi 	$t7, 	$0, 	0x0079
    ROMDATA[134] <= 32'h200f0079;
    //0x21c  	jr 		$ra
    ROMDATA[135] <= 32'h03e00008;
    //0x220  fifteen:	addi 	$t7, 	$0, 	0x0071
    ROMDATA[136] <= 32'h200f0071;
    //0x224  	jr 		$ra
    ROMDATA[137] <= 32'h03e00008;
    //0x228  exit:	lui 	$s7, 	0x4000
    ROMDATA[138] <= 32'h3c174000;
    //0x22c  	addi	$s7,	$s7,	0x0000
    ROMDATA[139] <= 32'h22f70000;
    //0x230  	lw 		$t6, 	8($s7)
    ROMDATA[140] <= 32'h8eee0008;
    //0x234  	addi 	$t7, 	$0, 	2
    ROMDATA[141] <= 32'h200f0002;
    //0x238  	or 		$t6, 	$t7, 	$t6
    ROMDATA[142] <= 32'h01ee7025;
    //0x23c  	sw 		$t6, 	8($s7)
    ROMDATA[143] <= 32'haeee0008;
    //0x240  	jr 		$k0
    ROMDATA[144] <= 32'h03400008;

	for (i = 145; i < ROM_SIZE; i = i + 1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
