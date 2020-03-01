;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

;instructions
.ORIG x3000

LEA R0, intro
PUTS

LD R0, space
OUT

LD R1, counter

DO_WHILE_LOOP
	;GETC
	;OUT
	;ST R0,  userInput
	
	LEA R2, array
	STR R0, R2, #0
	
	LD R0, space
	OUT
	
	LEA R3, array
	ADD R3, R3, #1
	
	ST	R3, array
	
	ADD R1, R1, #-1
	BRp DO_WHILE_LOOP
	



HALT

;local data
intro		.STRINGZ "Enter 10 characters"
space		.FILL '\n'
array		.BLKW #10
counter  	.FILL #10
;arrayTracker	.FILL #0

.END
