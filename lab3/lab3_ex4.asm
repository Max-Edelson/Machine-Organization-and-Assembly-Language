;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

;instructions
.ORIG x3000

LEA R0, intro
PUTS

LD R0, newline
OUT

LD R2, DATA_PTR

DO_WHILE_LOOP

	;ADD R5, R5, #1

	GETC
	OUT
	
	STR R0, R2, #0	;store user input in R3
	ADD R2, R2, #1	;move data pointer forwards by 1
	
	ADD R0, R0, #-10
	
	BRnp DO_WHILE_LOOP
END_DO_WHILE_LOOP

LD R2, DATA_PTR

DO_WHILE_LOO
	
	LDR R0, R2, #0
	OUT

	LD R0, newline
	OUT
	
	ADD R2, R2, #1	;move the array pointer over one
	
	LDR R3, R2, #0	;check to see if last thing is enter key
	ADD R3, R3, #-10
	BRnp DO_WHILE_LOO
END_DO_WHILE_LOO

HALT

;local data
intro		.STRINGZ "Enter lots of characters"
DATA_PTR	.FILL x4000
newline		.FILL x0A

.END
