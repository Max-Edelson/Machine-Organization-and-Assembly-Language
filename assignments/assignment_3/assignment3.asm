;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Assignment naame: Assignment 3
; Lab section: 025
; TA: Jang-Shing Lin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R5, three
LD R3, counter
LD R4, three
LD R6, Value_addr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0	; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

WHILE_LOOP

	;LDR R0, R1, #0
	;LDR R0, R1, #0
	;OUT
	
	ADD R1, R1, #0
	
	IF_STATEMENT
		BRzp	IS_ONE_CONDITION ;The leading number is a zero
	IS_ZERO_CONDITION	;the leading number is 1
		AND R0, R0, #0
		LD R0, one
		OUT
		BR END_IF
	IS_ONE_CONDITION
		AND R0, R0, #0
		LD R0, zero
		OUT
	END_IF
	
	ADD R1, R1, R1
	
	;OUT
	
	;LD R0, space
	;OUT
	
	ADD R5, R5, #0
	
	IF_STATEMENTTT
			BRz	PRINT_SPACE
		ITERATE_LOOP
			ADD R5, R5, #-1
			BR END_IFFF
		PRINT_SPACE
			CHECK_NEED_SPACE
				ADD R4, R4, #0
				BRz	END_IFFF
				LD R0, space
				OUT
				LD R5, three
				ADD R4, R4, #-1
	END_IFFF

	ADD R3, R3, #-1
	
	BRp WHILE_LOOP
END_WHILE_LOOP

;LD R0, space
;OUT

LD R0, newline
OUT

HALT
;---------------	
;Data
;---------------
Value_addr	.FILL xB800	; The address where value to be displayed is stored
three		.FILL #3
counter 	.FILL #16
space 		.FILL ' '
newline		.FILL #10
zero		.FILL #48
one			.FILL #49
;max_neg		.FILL x0b10000000
;two			.FILL #2

.ORIG xB800					; Remote data
Value .FILL x8000			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
