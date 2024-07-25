##############################################################
#Dynamic array
##############################################################
#   4 Bytes - Capacity
#	4 Bytes - Size
#   4 Bytes - Address of the Elements
##############################################################

##############################################################
#Song
##############################################################
#   4 Bytes - Address of the Name (name itself is 64 bytes)
#   4 Bytes - Duration
##############################################################


.data
space: .asciiz " "
newLine: .asciiz "\n"
tab: .asciiz "\t"
menu: .asciiz "\n● To add a song to the list-> \t\t enter 1\n● To delete a song from the list-> \t enter 2\n● To list all the songs-> \t\t enter 3\n● To exit-> \t\t\t enter 4\n"
menuWarn: .asciiz "Please enter a valid input!\n"
name: .asciiz "Enter the name of the song: "
duration: .asciiz "Enter the duration: "
name2: .asciiz "Song name: "
duration2: .asciiz "Song duration: "
emptyList: .asciiz "List is empty!\n"
noSong: .asciiz "\nSong not found!\n"
songAdded: .asciiz "\nSong added.\n"
songDeleted: .asciiz "\nSong deleted.\n"

copmStr: .space 64

sReg: .word 3, 7, 1, 2, 9, 4, 6, 5
songListAddress: .word 0 #the address of the song list stored here!

.text 
main:

	jal initDynamicArray
	sw $v0, songListAddress
	
	la $t0, sReg
	lw $s0, 0($t0)
	lw $s1, 4($t0)
	lw $s2, 8($t0)
	lw $s3, 12($t0)
	lw $s4, 16($t0)
	lw $s5, 20($t0)
	lw $s6, 24($t0)
	lw $s7, 28($t0)

menuStart:
	la $a0, menu    
    li $v0, 4
    syscall
    
	li $v0,  5
    syscall
	li $t0, 1
	beq $v0, $t0, addSong
	li $t0, 2
	beq $v0, $t0, deleteSong
	li $t0, 3
	beq $v0, $t0, listSongs
	li $t0, 4
	beq $v0, $t0, terminate
	
	la $a0, menuWarn    
    li $v0, 4
    syscall
	b menuStart
	
addSong:
	jal createSong
	lw $a0, songListAddress
	move $a1, $v0
	jal putElement
	b menuStart
	
deleteSong:
	lw $a0,	 songListAddress
	jal findSong
	lw $a0, songListAddress
	move $a1, $v0
	jal removeElement
	b menuStart
	
listSongs:
	lw $a0, songListAddress
	jal listElements
	b menuStart
	
terminate:
	la $a0, newLine		
	li $v0, 4
	syscall
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	move $a0, $s1
	syscall
	move $a0, $s2
	syscall
	move $a0, $s3
	syscall
	move $a0, $s4
	syscall
	move $a0, $s5
	syscall
	move $a0, $s6
	syscall
	move $a0, $s7
	syscall
	
	li $v0, 10
	syscall


initDynamicArray:
	
	# Allocating 12 byte memory space (from heap)
	li $v0, 9
	li $a0, 12
	syscall
	
	# initializing  capacity as 2
	move $t0, $v0
	
	li $t1, 2
	sw $t1, 0($t0)
	
	addi $t0, $t0, 4
	
	# initial size is zero (no elements in array)
	sw $zero, 0($t0)
	addi, $t0, $t0, 4
	
	# creating an array whose address will be stored
	# in the last 4 bytes of dynamic array	
	
	li $v0, 9
	li $a0, 16  # as each song is 8 bytes
	syscall
	
	move $t1, $v0
	sw $t1, 0($t0)
	
	# restore the base address of dynamic array in v0
	addi $t0, $t0, -8
        move $v0, $t0
        
	jr $ra
	
putElement:
	lw $t1, 0($a0) # capacity of the dynamic array
	addi $a0, $a0, 4
	lw $t2, 0($a0) # size of the dynamic array
	addi $a0, $a0, -4
	
	beq $t1, $t2, increaseCapacity
	
	j noResize
	
	increaseCapacity:
	    # capacity is increased according to size
	    move $t7, $a0
	    # doubling the capacity 
	    lw $t1, 0($a0)
	    mul $t1, $t1, 2	
	    sw $t1, 0($a0)
	    
	    # allocating new elements array
	    li $v0, 9
	    mul $t2, $t1, 8
	    add $a0, $t2, $zero
	    syscall
	        
	    # copying all entries to new elements array
	    # t6 contains the base address of the newly allocated array
	    move $t6, $v0  
	    
	    # restoring the value of a0
	    move $a0, $t7
	    addi $a0, $a0, 8
	    lw $t1, 0($a0)
	    # t1 holds the base address of previous array 
	    addi $a0, $a0, -4
	    li $t0 ,0
	    lw $t3, 0($a0)
	    addi $a0, $a0, 4
	    
	    copyOldEntries:
	        beq $t3, $t0, exit
	        sw $t1, 0($v0)
	        # also copy song addresses
	        lw $t8, 0($t1)
	        lw $t9, 0($v0)
	        move $t9, $t8
	        sw $t9, 0($v0)
	        addi $t1, $t1, 8
	        addi $v0 ,$v0, 8
	        addi $t0, $t0, 1
	        
	        b copyOldEntries
	     
	    exit:
	       move $a0 ,$t7
	       # get the capacity
	       lw $t1, 0($a0)
	       addi $a0 ,$a0, 4
	       # get the size
	       lw $t2, 0($a0)
	       # find number of empty entries
	       sub $t3, $t1, $t2
	       
	       li $t1, 0
	       assignZeroToUnfilled:
	           beq $t3,$t1,finishCopy
	           sw $zero, 0($v0)
	           addi $v0, $v0, 8
	           addi $t1, $t1, 1
	           b assignZeroToUnfilled
	
	finishCopy:
	    move $a0, $t7    
	    addi $a0, $a0, 8
	    move $v0, $t6
	    
	    sw $v0, 0($a0)
	    move $a0, $t7 
	
	noResize:
	  addi $a0, $a0, 4
          # getting the size
	  li $t0, 8
	  lw $t1, 0($a0)
		
	  mul $t0, $t1, $t0 
	  addi $a0, $a0, 4
		
	  # putting the element address into elements array
	  lw $t2, 0($a0)
	  add $t2, $t2, $t0
	  sw $a1, 0($t2)
		
          # increment size by 1
	  addi $a0, $a0, -4
	  lw $t3, 0($a0)
       	  addi $t3, $t3, 1
	  sw $t3, 0($a0)
	    
	  # printing that song is added
	  li $v0, 4
	  la $a0, songAdded
	  syscall
		      
	jr $ra

removeElement: 
	# I need to preserve the base address of a0 after following
	# operations (holding it in stack) 
	addi $sp , $sp, -4
	sw $a0, 0($sp)
	
	# capacity of dynamic array
	lw $t0, 0($a0)
	addi $a0, $a0, 4
	# size of dynamic array  
	lw $t1, 0($a0) 
	li $t2, 2
	# If capacity is 2 no resize operation is done 
	beq $t0, $t2, noResize2  
	
	move $t2, $t0
	# capacity is held in t2
	# divide capacity by 2
	srl $t2, $t2, 1
	addi $a0, $a0, -4
	blt $t1, $t2, decreaseCapacity
	# if size size <= capacity/2-1 halve the capacity
	j noResize2
	 
	decreaseCapacity: 
	       # reducing capacity by factor of 2
	       lw $t1, 0($a0)
	       # division by 2
	       srl $t1, $t1, 1
               sw $t1, 0($a0) 
               
               # allocating new elements array
               li $v0, 9
               mul $t2, $t1, 8
               add $a0, $t2, $zero
               syscall
               
               # copying all the entries to new element array
               # t3 contains  the base address of the 
               # newly allocated array
               move $t3, $v0
               # restoring a0 value 
               lw $a0, 0($sp)
               
               addi $a0, $a0, 8
               lw $t1, 0($a0) # holds the base address
               addi $a0, $a0, -4
               lw $t2, 0($a0)   # array size
               # initialize counter 
               li $t0, 0
               addi $a0, $a0, 4 
               
               copyOldEntries2:
                    beq $t2, $t0, finishDecreaseCapacity
                    sw $t1, 0($v0)
                    lw $t8, 0($t1)
                    lw $t9, 0($v0)
                    move $t9, $t8
                    sw $t9, 0($v0)
                    addi $t1, $t1, 8
                    addi $v0, $v0, 8
                    addi $t0, $t0, 1
                    b copyOldEntries2    
                        
               finishDecreaseCapacity:
                    lw $a0, 0($sp)
                    # get the capacity 
                    lw $t1, 0($a0)
                    addi $a0, $a0, 4
                    # get the size
                    
                    lw $t2, 0($a0)
                    # find the number of empty entries
                    sub $t4, $t1, $t2
                    
                    # initialize counter 
                    li $t0, 0
                    assignZeroToUnfilled2:
                          beq $t4, $t0, finishCopy2
                          sw $zero, 0($v0)
                          addi $v0, $v0, 8
                          addi $t0, $t0, 1
                          b assignZeroToUnfilled2              
               
               
        finishCopy2:       
             lw $a0, 0($sp)
             addi $a0, $a0, 8
             move $v0, $t3
             sw $v0, 0($a0)
                 
        noResize2:
        
        lw $a0, 0($sp)
	# without resize
	li $t0, -1
	# song to be deleted not found
	beq $a1, $t0, printNotFound	
	
	#initializing counter
	li $t1, 0
	addi $a0, $a0, 4
	lw $t2, 0($a0) # size of dynamic array
	addi $a0, $a0, 4
        # getting the elements array
	lw $t3, 0($a0)
	
	# if size is one no need for shifting after deletion
	beq $t2, 1, removeSingleElement
	
	# obtaining index from position
	addi $a1, $a1, -1
	removeAtIndex:
	     beq $t2, $t1, finishRemove
	     beq $a1, $t1, shiftElements
	     
	     addi $t1, $t1, 1
	     addi $t3, $t3, 8  
	     j removeAtIndex 
	     
	     shiftElements:
	        addi $t3, $t3, 8
	        lw $t0, 0($t3)
	        addi $t3, $t3, -8
	        sw $t0, 0($t3)
	        # once we got into shift rows
	        # we loop here for shifting rows to left
	        addi $t1, $t1, 1
	        addi $t3, $t3, 8
	        move $a1, $t1
	        j removeAtIndex
	        
	     finishRemove:
	         # decrease the size by 1
	         addi $t2, $t2, -1
	         
	         lw $a0, 0($sp)
	         addi $a0, $a0, 4
	         sw $t2, 0($a0) 
	           
	                 
	     finishRemoveElement:
	         # printing a message that informs message deleted
	         li $v0, 4
	         la $a0, songDeleted
	         syscall 
                 j endRemoveElement
             
             removeSingleElement: 
                 lw $a0, 0($sp)   
                 lw $t3, 8($a0)
                 lw $t0, 0($t3)
                 li $t0, 0
                 sw $t0, 0($t3)
             
                 # decrease the size by 1
	         addi $t2, $t2, -1
	         
	         lw $a0, 0($sp)
	         addi $a0, $a0, 4
	         sw $t2, 0($a0)	
	         
	         li $v0, 4
	         la $a0, songDeleted
	         syscall 
	         
	         j endRemoveElement         

	     printNotFound:
	         li $v0, 4
	         la $a0, noSong
	         syscall  	    
	
	endRemoveElement:
	      addi $sp, $sp, 4  
	        	  	        
	jr $ra

listElements:         
	       addi $a0, $a0, 4
	       # storing size of dynamic array
	       lw $t4, 0($a0)            
	       	       
	       addi $a0, $a0, 4
	       lw $t5, 0($a0)
	       # storing the ra address to stack 
	       addi $sp, $sp, -8
	       sw $ra, 0($sp)
	       
	       beq $t4, $zero, printEmptyList
	      
	       li $t0 ,0
	       goSongs: 
	           beq $t0, $t4, leavePrint
	           lw $a0, 0($t5)
	       
	           jal printElement
	           addi $t5, $t5, 8
	           addi $t0, $t0, 1    
                   
                   j goSongs
                   
               printEmptyList:
                 li $v0, 4
                 la $a0, emptyList 
                 syscall
                 j leavePrint
                   
               leavePrint:	      
	         lw $ra, 0($sp)
	         addi $sp, $sp, 8	       
	      
	       jr $ra

compareString:
       	sw $s2, 20($sp)
	sw $s3, 24($sp)
			
	li $s3, 0
	compareLoop:
	     beq $a2, $s3, stopComparison
	     lb $s0, 0($a0)
	     lb $s1, 0($a1) 
	     # check if equal, if not stop and return v0 with 0
	     sub $s2, $s0, $s1      
	     
	     bne $s2, $zero, notEqual
	     addi $a0, $a0, 1
	     addi $a1, $a1, 1
	     addi $s3, $s3, 1
	     
	     j compareLoop
	     
	stopComparison: 
	     li $v0, 1
	     j returnComparison
	            
	notEqual:
	     li $v0, 0
	      	      
	returnComparison:   
          lw $s2, 20($sp)      
	  lw $s3, 24($sp)  
        
	jr $ra
	
printElement:
	sw $ra, 4($sp)
	   
        jal printSong
	   
	lw $ra, 4($sp) 	    
	jr $ra

createSong:
	
	# creating a song in heap 
	li $v0, 9
	li $a0, 8
	syscall
	
	move $t0, $v0
	
	# Taking song name as an input
	li $v0, 4
	la $a0, name
	syscall
	
	# allocating 64 byte-space for song name
        li $v0, 9
        li $a0, 64
        syscall	
        
        move $t2, $v0
        
	li $v0, 8
	move $a0, $t2
	li $a1, 64
	syscall	
	
	# storing song name address in the first 4 byte
        sw $t2, 0($t0)  
        	
	addi $t0, $t0, 4
	
	# Taking song duration as an input
	li $v0, 4
	la $a0, duration
	syscall
	
	li $v0, 6
	syscall
	
	swc1 $f0, 0($t0)
	
	# restoring the base address of the song
        addi $t0, $t0, -4   
        move $v0, $t0	
	
	jr $ra

findSong: 
	# storing elements to be restored in stack
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# t1 holds the base address of dynamic array
	move $t1, $a0
	
	# prompting user to enter the name of song to be deleted
	li $v0, 4
	la $a0, name
	syscall
	
        # Taking input from user for string name
        li $v0, 8	
	la $a0, copmStr
	li $a1, 64
	syscall
	
	# if size is zero directly jump to song not found
	move $a0, $t1
	lw $t2, 4($a0)
	beq $t2, $zero, assignNotFound
	
	la $a0, copmStr
	addi $t1, $t1, 4
	lw $t3, 0($t1) # t3 holds the size of dynamic array
	
	addi $t1, $t1, 4 
	lw $t4, 0($t1) # base address of the array
	move $t9, $t4
	# restoring to previous base address of dynamic array
	addi $t1, $t1, -8
	#counter value 
	li $t2, 0
	li $t5, 8
	
	loopSongs:
	    move $t4, $t9
	    beq $t3, $t2, finishLoop
	    mul $t6, $t2, $t5
	    add $t4, $t4, $t6
	    lw $t7, 0($t4) 
	    # getting the base address of the song name for second string
	    lw $a1, 0($t7)
	    
            la $a0, copmStr
	    # increment counter
	    addi $t2, $t2, 1
	    sw $a0, 12($sp)
	    sw $a1, 16($sp)
	     
	    # counter initialized 
	    li $t0, 0
	    # finding the length of name of taken input string first
	    length1:
	        lb $s0,($a0) 
	        beq $s0, $zero, endLength1 
	        addi $t0, $t0, 1
	        addi $a0, $a0, 1     
	        
	        j length1 
	    	    
	    endLength1: 
	    
	    #counter initialized
	    li $t8, 0
	    length2:
	        lb $s1, 0($a1)
	        beq $s1, $zero, endLength2
                addi $t8, $t8, 1
                addi $a1, $a1, 1             
                         
                j length2	    
	       
	    endLength2:
	    
	    # restoring the a0 and a1 
	    lw $a0, 12($sp)
	    lw $a1, 16($sp)
	    	    
	    # if length of two strings are not equal go with next song
            bne $t0, $t8, loopSongs
            
            finishLoop:
	      # setting comparison size
	      add $a2, $zero, $t0
	      jal compareString
	      # if the song to be deleted is found
	      bne $v0, $zero,assignIndex
	      j assignNotFound
		    
	assignIndex:
	     move $v0, $t2
	     j finishAssignment
	        
	assignNotFound:
	     bne $t3, $t2, loopSongs
	     # song to be deleted not found 
	     li $v0, -1   
	     	
	finishAssignment:     	    	
	  lw $ra, 0($sp)
	  lw $s0, 4($sp)
	  lw $s1, 8($sp)
	  addi $sp, $sp, 28
	
	jr $ra

printSong: 
        move $t6, $a0
        li $v0, 4
        la $a0, name2
        syscall 
        
        move $a0, $t6
        # get the name of the song
        lw $t3, 0($a0)
        
        li $v0, 4
        move $a0, $t3
        syscall
        
        li $v0, 4
        la $a0, duration2
        syscall
        
        move $a0, $t6
        addi $a0, $a0, 4
        
        li $v0, 2
        lwc1 $f12, 0($a0)
        syscall
        
        # print new line
        li $v0, 4
        la $a0, newLine
        syscall
        
        # print new line
        li $v0, 4
        la $a0, newLine
        syscall
        
        addi $a0, $a0, -4
	jr $ra

additionalSubroutines:
   
