`timescale 1ns/1ps

module ROM_without_peripheral (addr,data);
input [30:0] addr;
output [31:0] data;

localparam ROM_SIZE = 256;
(* rom_style = "distributed" *) reg [31:0] ROMDATA[ROM_SIZE-1:0];

assign data=(addr < 4 * ROM_SIZE) ? ROMDATA[addr[30:2]] : 32'b0;

integer i;
initial begin
    //0x0  	addi	$a0,	$0,	84
    ROMDATA[0] <= 32'h20040054;
    //0x4  	addi	$a1,	$0,	12
    ROMDATA[1] <= 32'h2005000c;
    //0x8  	add	$a2,	$0,	$a0
    ROMDATA[2] <= 32'h00043020;
    //0xc  	add	$a3,	$0,	$a1
    ROMDATA[3] <= 32'h00053820;
    //0x10  	j	judge
    ROMDATA[4] <= 32'h0800000c;
    //0x14  div:	sub	$t1,	$a0,	$a1
    ROMDATA[5] <= 32'h00854822;
    //0x18  	blez	$t1,	swap
    ROMDATA[6] <= 32'h19200002;
    //0x1c  	add	$a0,	$t1,	$0
    ROMDATA[7] <= 32'h01202020;
    //0x20  	j	judge
    ROMDATA[8] <= 32'h0800000c;
    //0x24  swap:	add	$t1,	$a1,	$0
    ROMDATA[9] <= 32'h00a04820;
    //0x28  	add	$a1,	$a0,	$0
    ROMDATA[10] <= 32'h00802820;
    //0x2c  	add	$a0,	$t1,	$0
    ROMDATA[11] <= 32'h01202020;
    //0x30  judge:	bne	$a0,	$a1,	div
    ROMDATA[12] <= 32'h1485fff8;
    //0x34  	add	$v0,	$a0,	$0
    ROMDATA[13] <= 32'h00801020;

	for (i = 14; i < ROM_SIZE; i = i + 1) begin
        ROMDATA[i] <= 32'b0;
    end
end
endmodule
