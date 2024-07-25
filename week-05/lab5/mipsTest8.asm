
.data
msg: .asciiz "\nTotal is:"

.text
.globl main
		
main:

	li $a0, 5
	li $a1, 11
	
	jal addNumbers
	
	move $t0, $v0
	
	la $a0, msg
	li $v0, 4
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	
ending:	
	li $v0, 10
	syscall
	
	
addNumbers:
	add $v0, $a0, $a1
	jr $ra

	
