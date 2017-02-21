  # labwork.S
  # Written 2015 by F Lundevall
  # Skeleton file for IS1200/IS1500 lab 1 2015-2016.
  # The macros PUSH and POP are in the public domain.

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm

  # You can add your own code here
  # by Markus Brisl�v

.global delay
.global time2string
.global enable_interrupt
.data
.text

hexasc:
	mul 	$v0,$v0,$0			# resets v0
	li	$t0,10
	slt	$t1,$a0,$t0			# (a0 < 10)? t1 = 1 : t1 = 0;
	bne	$t1,1,letter			# (t1 != 1)? letter : ...;
	nop

	addiu	$v0,$a0,48
	jr	$ra
	nop

	letter:
		addiu	$v0,$a0,55		# gives the ascii value for "A - 10"
		jr	$ra
		nop


delay:
	li	$t1,1				# constant = 1
	li	$t2,20000				# constant <-- easy to change value?
	li	$t3,0				# var in for loop
	li	$t4,0				# var1 in while loop

	while:
		beq	$a0,$0,zero		# (ms == 0)? zero : ->
		nop
		sub	$a0,$a0,$t1		# ms = ms - 1
		li	$t0,0			# i = 0

		for:
			sltu	$t3,$t0,$t2	# (i < 4711)? var = 1 : var = 0
			addiu	$t0, $t0,1	# i += 1
			beq	$t3,$t1,for	# (var == 1)? for : ->
			nop

		sltu	$t4,$0,$a0		# (0 < ms)? var1 = 1 : var1 = 0
		beq	$t4,$t1,while		# (var1 == 1)? while : ->
		nop

	zero:
		jr	$ra			# return to main
		nop


time2string:
	PUSH	$s0				# saves earlier value...
	PUSH	$s1
	PUSH	$s2
	PUSH	$s3
	PUSH	$s4
	PUSH	$ra				# saves return address(main)
	PUSH	$a0				# saves argument address


	andi	$t2,$a1,0xFFFF			# hour check
	beq	$t2,$0,hour
	nop


	andi	$a0,$a1,0xf			# LSN
	jal	hexasc				# retrieve ascii code
	nop
	move	$s0,$v0				# stores xx:xX

	andi	$a0,$a1,0xf0			# 2nd LSN
	srl	$a0,$a0,4
	jal	hexasc				# retrieve ascii code
	nop
	move	$s1,$v0				# stores xx:Xx

	andi	$a0,$a1,0xf00			# 3th LSN
	srl	$a0,$a0,8
	jal	hexasc				# retrieve ascii code
	nop
	move	$s2,$v0				# stores xX:xx

	andi	$a0,$a1,0xf000			# 4th LSN
	srl	$a0,$a0,12
	jal	hexasc				# retrieve ascii code
	nop
	move	$s3,$v0				# stores Xx:xx

	POP	$a0				# earlier argument address

	li	$t0,0x0				# ascii code for "null"
	li	$t1,0x3a				# ascii code for ":"

	sb	$s3,0($a0)			# X
	sb	$s2,1($a0)			# xX
	sb	$t1,2($a0)			# xx:
	sb	$s1,3($a0)			# xx:X
	sb	$s0,4($a0)			# xx:xX
	sb	$t0,5($a0) 			# xx:xx(NULL)

back:

	POP	$ra				# returns return address(main)
	POP	$s4				# returns s registers to earlier values...
	POP	$s3
	POP	$s2
	POP	$s1
	POP	$s0

	jr	$ra				# return to main
	nop

hour:
	POP	$a0
	li	$t0,0x48
	li	$t1,0x4f
	li	$t3,0x55
	li	$t4,0x52
	li	$t5,0x00

	sb	$t0,0($a0)			# X
	sb	$t1,1($a0)			# xX
	sb	$t3,2($a0)			# xx:X
	sb	$t4,3($a0)			# xx:xX
	sb	$t5,4($a0) 			# xx:xx(NULL)

 	j	back
 	nop

enable_interrupt:
  ei
  jr $ra
  nop
