	j	main
	j	interrupt
   	j	exception

main:
	# $s0 = 0x4000_0000
	lui	$s0,	0x4000
	addi	$s0,	$s0,	0x0000
	# $s1 = 0x4000_0008
	lui	$s1,	0x4000
	addi	$s1,	$s1,	0x0008

#=======TIMER CONFIGURATION=======#
timer:
	# 0x4000_0008 = 0
	sw	$0,	8($s0)
	# 0x4000_0000 = -1000
	addi	$t0,	$0,	-1000
	sw	$t0,	0($s0)
	# 0x4000_0004 = -1
	addi	$t0,	$0,	-1
	sw	$t0,	4($s0)
	# 0x4000_0008 = 3
	addi	$t0,	$0,	3
	sw	$t0,	8($s0)
	# $v0 = 0
	add	$v0,	$0,	$0

#=======GET FIRST NUMBER=======#  
UART_receiver1:
	# $t0 = 0x4000_0020 = UART_CON
	lw	$t0,	32($s0)
	# if(UART_CON[3] != 1) goto UART_receiver1
	and	$t1,	$t0,	$s1
	beq	$t1,	$0,	UART_receiver1
	# $a0 = 0x4000_001c = UART_RXD
	lw	$a0,	28($s0)

#=======GET SECOND NUMBER=======#  
UART_receiver2:
	# $t0 = 0x4000_0020 = UART_CON
	lw 	$t0,	32($s0)
	# if(UART_CON[3] != 1) goto UART_receiver2
	and	$t1,	$t0,	$s1
	beq	$t1,	$0,	UART_receiver2
	# $a1 = 0x4000_001c = UART_RXD
	lw	$a1,	28($s0) 
		
	add	$a2,	$0,	$a0
	add	$a3,	$0,	$a1
	j	judge
	
#=======GET GCD=======#
div:
	sub	$t1,	$a0,	$a1
	blez	$t1,	swap
	add	$a0,	$t1,	$0
	j	judge
swap:
	add	$t1,	$a1,	$0
	add	$a1,	$a0,	$0
	add	$a0,	$t1,	$0
judge:
	bne	$a0,	$a1,	div
	add	$v0,	$a0,	$0

#=======SEND RESULT=======#
UART_sender:
	# write to leds
	sw	$v0,	12($s0)
	# write to UART_TXD
	sw	$v0,	24($s0)
	
#=======ENDLESS LOOP=======#
forever_loop:
	j	forever_loop

#=======EXCEPTION=======#
exception:
	j exception
	jr $k0

interrupt:
#=======CLEAR INTERRUPT STATE=======#
	# $t5 = 0xffff_fff9
	addi	$t5,	$0,	-7
	# $s7 = 0x4000_0000
	lui	$s7,	0x4000
	addi	$s7,	$s7,	0x0000
	# $t6 = 0x4000_0008 = TCON
	lw	$t6,	8($s7)
	# $t5 = TCON & 0xffff_fff9
	and	$t5,	$t5,	$t6
	# TCON[2:1] = 2'b0
	sw	$t5,	8($s7)
	
	# $t5 = 0x4000_0014 = digi
	lw	$t5,	20($s7)
	# $s6 = {20'h0, BCD[11:8], 8'h00}
	andi	$s6,	$t5,	0x0F00
	# $t6 = 0x0000_0100
	addi	$t6,	$0,	0x100
	
#=======SWITCH-CASE BLOCK=======#
	beq	$s6,	$0,	one_high
	beq	$s6,	$t6,	one_low
	sll	$t6,	$t6,	1
	beq	$s6,	$t6,	two_high
	sll	$t6,	$t6,	1
	beq	$s6,	$t6,	two_low
	sll	$t6,	$t6,	1
	beq	$s6,	$t6,	one_high

one_high:
	andi	$t7,	$a3,	0x00f0
	srl	$t7,	$t7,	4
	jal	BCD_decode
	addi	$t7,	$t7,	0x0100
	sw	$t7,	20($s7)
	j	exit

one_low:
	andi	$t7,	$a3,	0x000f
	jal	BCD_decode
	addi	$t7,	$t7,	0x0200
	sw	$t7,	20($s7)
	j	exit
two_high:
	andi	$t7,	$a2,	0x00f0
	srl	$t7,	$t7,	4
	jal	BCD_decode
	addi	$t7,	$t7,	0x0400
	sw	$t7,	20($s7)
	j	exit
two_low:
	andi	$t7,	$a2,	0x000f
	jal	BCD_decode
	addi	$t7,	$t7,	0x0800
	sw	$t7,	20($s7)
	j	exit

BCD_decode:
	addi	$t5,	$t7,	0
	beq	$t5,	$0,	zero
	addi	$t5,	$t7,	-1
	beq	$t5,	$0,	one
	addi	$t5,	$t7,	-2
	beq	$t5,	$0,	two
	addi	$t5,	$t7, 	-3
	beq 	$t5, 	$0, 	three
	addi 	$t5, 	$t7, 	-4
	beq 	$t5, 	$0, 	four
	addi	$t5,	$t7, 	-5
	beq	$t5,	$0, 	five
	addi	$t5, 	$t7, 	-6
	beq 	$t5, 	$0, 	six
	addi 	$t5, 	$t7, 	-7
	beq 	$t5, 	$0, 	seven
	addi 	$t5, 	$t7, 	-8
	beq 	$t5, 	$0, 	eight
	addi 	$t5, 	$t7, 	-9
	beq 	$t5, 	$0, 	nine
	addi 	$t5, 	$t7, 	-10
	beq 	$t5, 	$0, 	ten
	addi 	$t5, 	$t7, 	-11
	beq 	$t5, 	$0, 	eleven
	addi 	$t5, 	$t7, 	-12
	beq 	$t5, 	$0, 	twelve
	addi 	$t5, 	$t7, 	-13
	beq 	$t5, 	$0, 	thirteen
	addi 	$t5, 	$t7, 	-14
	beq 	$t5, 	$0, 	fourteen
	addi 	$t5, 	$t7, 	-15
	beq 	$t5, 	$0, 	fifteen
zero:
	addi 	$t7, 	$0, 	0x003f
	jr 	$ra
one:
	addi 	$t7, 	$0, 	0x0006
	jr 	$ra
two:
	addi 	$t7, 	$0, 	0x005b
	jr 	$ra
three:
	addi 	$t7, 	$0, 	0x004f
	jr 	$ra
four:
	addi 	$t7, 	$0, 	0x0066
	jr 	$ra
five:
	addi 	$t7, 	$0, 	0x006d
	jr 	$ra
six:
	addi 	$t7, 	$0, 	0x007d
	jr 	$ra
seven:
	addi 	$t7, 	$0, 	0x0007
	jr 	$ra
eight:
	addi 	$t7, 	$0, 	0x007f
	jr 	$ra
nine:
	addi 	$t7, 	$0, 	0x006f
	jr 	$ra
ten:
	addi 	$t7, 	$0, 	0x0077
	jr 	$ra
eleven:
	addi 	$t7, 	$0, 	0x007c
	jr	$ra
twelve:
	addi 	$t7, 	$0, 	0x0039
	jr 	$ra
thirteen:
	addi 	$t7, 	$0, 	0x005e
	jr 	$ra
fourteen:
	addi 	$t7, 	$0, 	0x0079
	jr 	$ra
fifteen:
	addi 	$t7, 	$0, 	0x0071
	jr 	$ra
exit:
	# $s7 = 0x4000_0000
	lui 	$s7, 	0x4000
	addi	$s7,	$s7,	0x0000
	# $t6 = 0x4000_0008 = TCON
	lw 	$t6, 	8($s7)
	# $t7 = 2
	addi 	$t7, 	$0, 	2
	# TCON[1] = 1
	or 	$t6, 	$t7, 	$t6
	sw 	$t6, 	8($s7)
	jr 	$k0
