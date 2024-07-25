
.data
msg: .asciiz "\nNumber is:"

.text
.globl main
		
main:

	li $t0, 1
	li $t1, 11
	loop1:
		beq $t0, $t1, ending
		la $a0, msg
		li $v0, 4
		syscall
		
		li $v0, 1
		move $a0, $t0
		syscall
		
		addi $t0, $t0, 1
		b loop1
		
	
	ending:
	li $v0, 10
	syscall
		
		