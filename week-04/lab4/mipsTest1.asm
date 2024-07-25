
.data
num1: .word 10
num2: .word 20
result: .word 0

.text
.globl main
		
main:   
	la $t0, num1
	lw $t3, 0($t0)
	
	lw $t1, num2
	
	lw $s0, result
	
	add $s0, $t3, $t1
	
	li $v0, 10
	syscall
	