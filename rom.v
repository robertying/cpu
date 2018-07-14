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
    ROMDATA[1] <= 32'h08000028;
    //0x8     	j	exception
    ROMDATA[2] <= 32'h08000026;
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
    //0x38  	add	    $v0,	$0,	    $0
    ROMDATA[14] <= 32'h00001020;
    //0x3c  UART_receiver1:	lw	    $t0,	32($s0)
    ROMDATA[15] <= 32'h8e080020;
    //0x40  	and	    $t1,	$t0,	$s1
    ROMDATA[16] <= 32'h01114824;
    //0x44  	beq	    $t1,	$0,	    UART_receiver1
    ROMDATA[17] <= 32'h1120fffd;
    //0x48  	lw	    $a0,	28($s0)
    ROMDATA[18] <= 32'h8e04001c;
    //0x4c  	add	    $a2,	$0,	$a0
    ROMDATA[19] <= 32'h00043020;
    //0x50  UART_receiver2:	lw 	    $t0,	32($s0)
    ROMDATA[20] <= 32'h8e080020;
    //0x54  	and	    $t1,	$t0,	$s1
    ROMDATA[21] <= 32'h01114824;
    //0x58  	beq	    $t1,	$0,	    UART_receiver2
    ROMDATA[22] <= 32'h1120fffd;
    //0x5c  	lw	    $a1,	28($s0)
    ROMDATA[23] <= 32'h8e05001c;
    //0x60  	add		$a3, 	$0, 	$a1
    ROMDATA[24] <= 32'h00053820;
    //0x64  	j		judge
    ROMDATA[25] <= 32'h08000021;
    //0x68  div:	sub		$t1,	$a0,	$a1
    ROMDATA[26] <= 32'h00854822;
    //0x6c  	blez	$t1,	swap
    ROMDATA[27] <= 32'h19200002;
    //0x70  	add		$a0,	$t1,	$0
    ROMDATA[28] <= 32'h01202020;
    //0x74  	j		judge
    ROMDATA[29] <= 32'h08000021;
    //0x78  swap:	add		$t1,	$a1,	$0
    ROMDATA[30] <= 32'h00a04820;
    //0x7c  	add		$a1,	$a0,	$0
    ROMDATA[31] <= 32'h00802820;
    //0x80  	add		$a0,	$t1,	$0
    ROMDATA[32] <= 32'h01202020;
    //0x84  judge:	bne		$a0,	$a1,	div
    ROMDATA[33] <= 32'h1485fff8;
    //0x88  	add		$v0,	$a0,	$0
    ROMDATA[34] <= 32'h00801020;
    //0x8c  UART_sender:	sw		$v0,	12($s0)
    ROMDATA[35] <= 32'hae02000c;
    //0x90  	sw		$v0,	24($s0)
    ROMDATA[36] <= 32'hae020018;
    //0x94  forever_loop:	j		forever_loop
    ROMDATA[37] <= 32'h08000025;
    //0x98  exception:	j 		exception
    ROMDATA[38] <= 32'h08000026;
    //0x9c  	jr 		$k0
    ROMDATA[39] <= 32'h03400008;
    //0xa0  interrupt:	addi	$t5,	$0,		-7
    ROMDATA[40] <= 32'h200dfff9;
    //0xa4  	lui		$s7,	0x4000
    ROMDATA[41] <= 32'h3c174000;
    //0xa8  	addi	$s7,	$s7,	0x0000
    ROMDATA[42] <= 32'h22f70000;
    //0xac  	lw		$t6,	8($s7)
    ROMDATA[43] <= 32'h8eee0008;
    //0xb0  	and		$t5,	$t5,	$t6
    ROMDATA[44] <= 32'h01ae6824;
    //0xb4  	sw		$t5,	8($s7)
    ROMDATA[45] <= 32'haeed0008;
    //0xb8  	lw		$t5,	20($s7)
    ROMDATA[46] <= 32'h8eed0014;
    //0xbc  	andi	$s6,	$t5,	0x0F00
    ROMDATA[47] <= 32'h31b60f00;
    //0xc0  	addi	$t6,	$0,		0x100
    ROMDATA[48] <= 32'h200e0100;
    //0xc4  	beq		$s6,	$0,		one_high
    ROMDATA[49] <= 32'h12c00007;
    //0xc8  	beq		$s6,	$t6,	one_low
    ROMDATA[50] <= 32'h12ce000c;
    //0xcc  	sll		$t6,	$t6,	1
    ROMDATA[51] <= 32'h000e7040;
    //0xd0  	beq		$s6,	$t6,	two_high
    ROMDATA[52] <= 32'h12ce000f;
    //0xd4  	sll		$t6,	$t6,	1
    ROMDATA[53] <= 32'h000e7040;
    //0xd8  	beq		$s6,	$t6,	two_low
    ROMDATA[54] <= 32'h12ce0013;
    //0xdc  	sll		$t6,	$t6,	1
    ROMDATA[55] <= 32'h000e7040;
    //0xe0  	beq		$s6,	$t6,	one_high
    ROMDATA[56] <= 32'h12ce0000;
    //0xe4  one_high:	andi	$t7,	$a3,	0x00f0
    ROMDATA[57] <= 32'h30ef00f0;
    //0xe8  	srl		$t7,	$t7,	4
    ROMDATA[58] <= 32'h000f7902;
    //0xec  	jal		BCD_decode
    ROMDATA[59] <= 32'h0c00004f;
    //0xf0  	addi	$t7,	$t7,	0x0100
    ROMDATA[60] <= 32'h21ef0100;
    //0xf4  	sw		$t7,	20($s7)
    ROMDATA[61] <= 32'haeef0014;
    //0xf8  	j		exit
    ROMDATA[62] <= 32'h0800008f;
    //0xfc  one_low:	andi	$t7,	$a3,	0x000f
    ROMDATA[63] <= 32'h30ef000f;
    //0x100  	jal		BCD_decode
    ROMDATA[64] <= 32'h0c00004f;
    //0x104  	addi	$t7,	$t7,	0x0200
    ROMDATA[65] <= 32'h21ef0200;
    //0x108  	sw		$t7,	20($s7)
    ROMDATA[66] <= 32'haeef0014;
    //0x10c  	j		exit
    ROMDATA[67] <= 32'h0800008f;
    //0x110  two_high:	andi	$t7,	$a2,	0x00f0
    ROMDATA[68] <= 32'h30cf00f0;
    //0x114  	srl		$t7,	$t7,	4
    ROMDATA[69] <= 32'h000f7902;
    //0x118  	jal		BCD_decode
    ROMDATA[70] <= 32'h0c00004f;
    //0x11c  	addi	$t7,	$t7,	0x0400
    ROMDATA[71] <= 32'h21ef0400;
    //0x120  	sw		$t7,	20($s7)
    ROMDATA[72] <= 32'haeef0014;
    //0x124  	j		exit
    ROMDATA[73] <= 32'h0800008f;
    //0x128  two_low:	andi	$t7,	$a2,	0x000f
    ROMDATA[74] <= 32'h30cf000f;
    //0x12c  	jal		BCD_decode
    ROMDATA[75] <= 32'h0c00004f;
    //0x130  	addi	$t7,	$t7,	0x0800
    ROMDATA[76] <= 32'h21ef0800;
    //0x134  	sw		$t7,	20($s7)
    ROMDATA[77] <= 32'haeef0014;
    //0x138  	j		exit
    ROMDATA[78] <= 32'h0800008f;
    //0x13c  BCD_decode:	addi	$t5,	$t7,	0
    ROMDATA[79] <= 32'h21ed0000;
    //0x140  	beq		$t5,	$0,		zero
    ROMDATA[80] <= 32'h11a0001e;
    //0x144  	addi	$t5,	$t7,	-1
    ROMDATA[81] <= 32'h21edffff;
    //0x148  	beq		$t5,	$0,		one
    ROMDATA[82] <= 32'h11a0001e;
    //0x14c  	addi	$t5,	$t7,	-2
    ROMDATA[83] <= 32'h21edfffe;
    //0x150  	beq		$t5,	$0,		two
    ROMDATA[84] <= 32'h11a0001e;
    //0x154  	addi	$t5,	$t7, 	-3
    ROMDATA[85] <= 32'h21edfffd;
    //0x158  	beq 	$t5, 	$0, 	three
    ROMDATA[86] <= 32'h11a0001e;
    //0x15c  	addi 	$t5, 	$t7, 	-4
    ROMDATA[87] <= 32'h21edfffc;
    //0x160  	beq 	$t5, 	$0, 	four
    ROMDATA[88] <= 32'h11a0001e;
    //0x164  	addi	$t5,	$t7, 	-5
    ROMDATA[89] <= 32'h21edfffb;
    //0x168  	beq		$t5,	$0, 	five
    ROMDATA[90] <= 32'h11a0001e;
    //0x16c  	addi	$t5, 	$t7, 	-6
    ROMDATA[91] <= 32'h21edfffa;
    //0x170  	beq 	$t5, 	$0, 	six
    ROMDATA[92] <= 32'h11a0001e;
    //0x174  	addi 	$t5, 	$t7, 	-7
    ROMDATA[93] <= 32'h21edfff9;
    //0x178  	beq 	$t5, 	$0, 	seven
    ROMDATA[94] <= 32'h11a0001e;
    //0x17c  	addi 	$t5, 	$t7, 	-8
    ROMDATA[95] <= 32'h21edfff8;
    //0x180  	beq 	$t5, 	$0, 	eight
    ROMDATA[96] <= 32'h11a0001e;
    //0x184  	addi 	$t5, 	$t7, 	-9
    ROMDATA[97] <= 32'h21edfff7;
    //0x188  	beq 	$t5, 	$0, 	nine
    ROMDATA[98] <= 32'h11a0001e;
    //0x18c  	addi 	$t5, 	$t7, 	-10
    ROMDATA[99] <= 32'h21edfff6;
    //0x190  	beq 	$t5, 	$0, 	ten
    ROMDATA[100] <= 32'h11a0001e;
    //0x194  	addi 	$t5, 	$t7, 	-11
    ROMDATA[101] <= 32'h21edfff5;
    //0x198  	beq 	$t5, 	$0, 	eleven
    ROMDATA[102] <= 32'h11a0001e;
    //0x19c  	addi 	$t5, 	$t7, 	-12
    ROMDATA[103] <= 32'h21edfff4;
    //0x1a0  	beq 	$t5, 	$0, 	twelve
    ROMDATA[104] <= 32'h11a0001e;
    //0x1a4  	addi 	$t5, 	$t7, 	-13
    ROMDATA[105] <= 32'h21edfff3;
    //0x1a8  	beq 	$t5, 	$0, 	thirteen
    ROMDATA[106] <= 32'h11a0001e;
    //0x1ac  	addi 	$t5, 	$t7, 	-14
    ROMDATA[107] <= 32'h21edfff2;
    //0x1b0  	beq 	$t5, 	$0, 	fourteen
    ROMDATA[108] <= 32'h11a0001e;
    //0x1b4  	addi 	$t5, 	$t7, 	-15
    ROMDATA[109] <= 32'h21edfff1;
    //0x1b8  	beq 	$t5, 	$0, 	fifteen
    ROMDATA[110] <= 32'h11a0001e;
    //0x1bc  zero:	addi 	$t7, 	$0, 	0x003f
    ROMDATA[111] <= 32'h200f003f;
    //0x1c0  	jr 		$ra
    ROMDATA[112] <= 32'h03e00008;
    //0x1c4  one:	addi 	$t7, 	$0, 	0x0006
    ROMDATA[113] <= 32'h200f0006;
    //0x1c8  	jr 		$ra
    ROMDATA[114] <= 32'h03e00008;
    //0x1cc  two:	addi 	$t7, 	$0, 	0x005b
    ROMDATA[115] <= 32'h200f005b;
    //0x1d0  	jr 		$ra
    ROMDATA[116] <= 32'h03e00008;
    //0x1d4  three:	addi 	$t7, 	$0, 	0x004f
    ROMDATA[117] <= 32'h200f004f;
    //0x1d8  	jr 		$ra
    ROMDATA[118] <= 32'h03e00008;
    //0x1dc  four:	addi 	$t7, 	$0, 	0x0066
    ROMDATA[119] <= 32'h200f0066;
    //0x1e0  	jr 		$ra
    ROMDATA[120] <= 32'h03e00008;
    //0x1e4  five:	addi 	$t7, 	$0, 	0x006d
    ROMDATA[121] <= 32'h200f006d;
    //0x1e8  	jr 		$ra
    ROMDATA[122] <= 32'h03e00008;
    //0x1ec  six:	addi 	$t7, 	$0, 	0x007d
    ROMDATA[123] <= 32'h200f007d;
    //0x1f0  	jr 		$ra
    ROMDATA[124] <= 32'h03e00008;
    //0x1f4  seven:	addi 	$t7, 	$0, 	0x0007
    ROMDATA[125] <= 32'h200f0007;
    //0x1f8  	jr 		$ra
    ROMDATA[126] <= 32'h03e00008;
    //0x1fc  eight:	addi 	$t7, 	$0, 	0x007f
    ROMDATA[127] <= 32'h200f007f;
    //0x200  	jr 		$ra
    ROMDATA[128] <= 32'h03e00008;
    //0x204  nine:	addi 	$t7, 	$0, 	0x006f
    ROMDATA[129] <= 32'h200f006f;
    //0x208  	jr 		$ra
    ROMDATA[130] <= 32'h03e00008;
    //0x20c  ten:	addi 	$t7, 	$0, 	0x0077
    ROMDATA[131] <= 32'h200f0077;
    //0x210  	jr 		$ra
    ROMDATA[132] <= 32'h03e00008;
    //0x214  eleven:	addi 	$t7, 	$0, 	0x007c
    ROMDATA[133] <= 32'h200f007c;
    //0x218  	jr		$ra
    ROMDATA[134] <= 32'h03e00008;
    //0x21c  twelve:	addi 	$t7, 	$0, 	0x0039
    ROMDATA[135] <= 32'h200f0039;
    //0x220  	jr 		$ra
    ROMDATA[136] <= 32'h03e00008;
    //0x224  thirteen:	addi 	$t7, 	$0, 	0x005e
    ROMDATA[137] <= 32'h200f005e;
    //0x228  	jr 		$ra
    ROMDATA[138] <= 32'h03e00008;
    //0x22c  fourteen:	addi 	$t7, 	$0, 	0x0079
    ROMDATA[139] <= 32'h200f0079;
    //0x230  	jr 		$ra
    ROMDATA[140] <= 32'h03e00008;
    //0x234  fifteen:	addi 	$t7, 	$0, 	0x0071
    ROMDATA[141] <= 32'h200f0071;
    //0x238  	jr 		$ra
    ROMDATA[142] <= 32'h03e00008;
    //0x23c  exit:	lui 	$s7, 	0x4000
    ROMDATA[143] <= 32'h3c174000;
    //0x240  	addi	$s7,	$s7,	0x0000
    ROMDATA[144] <= 32'h22f70000;
    //0x244  	lw 		$t6, 	8($s7)
    ROMDATA[145] <= 32'h8eee0008;
    //0x248  	addi 	$t7, 	$0, 	2
    ROMDATA[146] <= 32'h200f0002;
    //0x24c  	or 		$t6, 	$t7, 	$t6
    ROMDATA[147] <= 32'h01ee7025;
    //0x250  	sw 		$t6, 	8($s7)
    ROMDATA[148] <= 32'haeee0008;
    //0x254  	jr 		$k0
    ROMDATA[149] <= 32'h03400008;

	for (i = 150; i < ROM_SIZE; i = i + 1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
