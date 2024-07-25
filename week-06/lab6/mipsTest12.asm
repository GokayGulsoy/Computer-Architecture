.text

main:

	jal function1
	
	li $v0, 10
	syscall
	
	
	
	function1:
	
		subu $sp, $sp, 4
		sw $ra, 0($sp)
		
		jal function2
		
		lw $ra, 0($sp)
		addu $sp, $sp, 4
		
		jr $ra
	
	function2:
	
		jr $ra
		
