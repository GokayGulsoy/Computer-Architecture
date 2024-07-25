.data
msg: .space 12
msg2: .word 569
newLine: .asciiz "\n"

.text
.globl main
		
main:

	la $a0, msg
    	li $a1, 11
	li $v0, 8
	syscall
	
	
	li $v0, 9
	li $a0, 12
	syscall
	
	move $a0, $v0
	move $t0, $a0
	
	sw $a0, msg2
	
    	li $a1, 11
	li $v0, 8
	syscall
	
	la $a0, msg
	li $t3, 12
	li $t4, 0
	loop:
	beq $t3, $t4, loopEnd
	lb $t2, 0($t0)
	lb $t1, 0($a0)
	addi $t0, $t0, 1
	addi $a0, $a0, 1
	addi $t4, $t4, 1
	b loop
	loopEnd:
	
	la $a0, newLine    
    li $v0, 4
    syscall
	syscall
	
	la $a0, msg
    syscall
	
	lw $a0, msg2
    syscall
	
	li $v0, 10
	syscall
		
	
	
