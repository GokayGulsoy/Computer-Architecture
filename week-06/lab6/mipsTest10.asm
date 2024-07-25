.data
array: .space 12

.text
		
main:

	la $t0, array
	
	li $t1, 15
	sw $t1, 0($t0)
	li $t1, 19
	sw $t1, 4($t0)
	
	li $v0, 9
	li $a0, 12
	syscall
	move $t2, $v0
	
	li $t3, 22
	sw $t3, 0($t2)
	li $t3, 26
	sw $t3, 4($t2)
	li $t3, 26
	sw $t3, 8($t2)
	li $t3, 28
	sw $t3, 12($t2)
	
	li $v0, 9
	li $a0, 10
	syscall
	move $t4, $v0
	
	li $t5, 105
	sb $t5, 0($t4)
	li $t5, 80
	sb $t5, 1($t4)
	li $t5, 60
	sb $t5, 2($t4)
	li $t5, 120
	sb $t5, 3($t4)
	li $t5, 10
	sb $t5, 4($t4)
	li $t5, 0
	sb $t5, 5($t4)
	li $t5, 125
	sb $t5, 6($t4)
	
	li $v0, 4
	move $a0, $t4
	syscall
	
	li $v0, 10
	syscall
	
	
	
