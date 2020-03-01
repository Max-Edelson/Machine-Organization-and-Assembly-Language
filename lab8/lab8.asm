;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

; test harness
					.orig x3000
				 
LD R6, SUB_PRINT_OPCODES_fo_ptr				 
JSRR R6

LD R6, SUB_FIND_OPCODE_fo_ptr
JSRR R6
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
SUB_PRINT_OPCODES_fo_ptr 		.fill x3200
SUB_FIND_OPCODE_fo_ptr			.fill x3600

;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODES
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;		 		 and corresponding opcode in the following format:
;		 		 ADD = 0001
;		  		 AND = 0101
;		  		 BR = 0000
;		  		 …
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3200

ST R0, R0_backup_3200
ST R1, R1_backup_3200
ST R2, R2_backup_3200
ST R3, R3_backup_3200
ST R4, R4_backup_3200
ST R5, R5_backup_3200
ST R7, R7_backup_3200

LD R1, instructions_po_ptr
LD R4, SUB_PRINT_OPCODE_ptr
LD R3, opcodes_po_ptr

PRINT_TABLE_LOOP
	
	LDR R0, R1, #0
	BRn BREAK_LOOP
	
	PRINT_WORD
		OUT
		ADD R1, R1, #1
		LDR R0, R1, #0
	BRp PRINT_WORD
	ADD R1, R1, #1
	
	LEA R0, equal_sign
	PUTS
	
	LDR R2, R3, #0
	JSRR R4

	ADD R3, R3, #1
	
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT
BR PRINT_TABLE_LOOP
		
BREAK_LOOP
				 
LD R0, R0_backup_3200
LD R1, R1_backup_3200
LD R2, R2_backup_3200
LD R3, R3_backup_3200
LD R4, R4_backup_3200
LD R5, R5_backup_3200
LD R7, R7_backup_3200
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODES local data
opcodes_po_ptr		.fill x4000
instructions_po_ptr	.fill x4100
SUB_PRINT_OPCODE_ptr .fill x3400
equal_sign			.stringz " = "
counter 			.fill #16
newline				.fill #10
R0_backup_3200		.BLKW #1
R1_backup_3200		.BLKW #1
R2_backup_3200		.BLKW #1
R3_backup_3200		.BLKW #1
R4_backup_3200		.BLKW #1
R5_backup_3200		.BLKW #1
R7_backup_3200		.BLKW #1


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3400
ST R2, R2_backup_3400
ST R3, R3_backup_3400
ST R4, R4_backup_3400
ST R7, R7_backup_3400

LD R4, DEC_48

AND R3, R3, #0
ADD R3, R3, #4	; counter
				 
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2
ADD R2, R2, R2

POSITIVITY_LOOP
	ADD R2, R2, #0
	BRn PRINT_ONE
	
	PRINT_ZERO
		AND R0, R0, #0
		ADD R0, R0, R4
		OUT
		BR ITERATE
	
	PRINT_ONE
		AND R0, R0, #0
		ADD R0, R0, #1
		ADD R0, R0, R4
		OUT

ITERATE
	ADD R2, R2, R2
	ADD R3, R3, #-1
	BRp POSITIVITY_LOOP
	
LD R2, R2_backup_3400
LD R3, R3_backup_3400
LD R4, R4_backup_3400	 	 
LD R7, R7_backup_3400	 	 

ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
R2_backup_3400		.BLKW #1
R3_backup_3400		.BLKW #1
R4_backup_3400		.BLKW #1
R7_backup_3400		.BLKW #1
DEC_48				.FILL #48


;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3600

ST R0, R0_backup_3600
ST R1, R1_backup_3600
ST R2, R2_backup_3600
ST R3, R3_backup_3600
ST R4, R4_backup_3600
ST R5, R5_backup_3600
ST R6, R6_backup_3600
ST R7, R7_backup_3600

LD R2, str_ptr
LD R1, SUB_GET_STRING_ptr
JSRR R1			

LD R1, opcodes_fo_ptr
LD R2, instructions_fo_ptr

LDR R4, R2, #0
LD R3, str_ptr

	STRING_LOOP
		BRn PRINT_ERROR_STRING
		
		LDR R5, R3, #0
		
		NOT R5, R5
		ADD R5, R5, #1
		
		ADD R6, R5, R4 ; Compare characters
	BRz NEXT_LETTER_CHECK ; If the difference is 0, move to check next char
	BR NEXT_WORD ; Else, move to the next string in instruction array

	NEXT_LETTER_CHECK
		ADD R4, R4, #0 ; LMR R4
		BRn PRINT_ERROR_STRING
		BRz CHECK_STR_LET ; Check if Instruction is complete
		BR NEXT_LETTER
		CHECK_STR_LET
			ADD R5, R5, #0
		BRz MATCH
	BR NEXT_LETTER
		
	NEXT_LETTER
		ADD R2, R2, #1 ; Increment instruction array pointer
		LDR R4, R2, #0;
		ADD R3, R3, #1 ; Increment user input array pointer
	BR STRING_LOOP
	
	NEXT_WORD
		ITERATE_INSTRUCTIONS
			LDR R4, R2, #0 ; Load character into R4
			BRn PRINT_ERROR_STRING
			BRz INSTRUCTIONS_ONE_MORE ; If character is 0, the string is null-terminated
			ADD R2, R2, #1 ; Else, increment the counter and repeat
		BR ITERATE_INSTRUCTIONS
		
		INSTRUCTIONS_ONE_MORE
			ADD R1, R1, #1 ; Increment opcode pointer
			ADD R2, R2, #1 ; Offset by 1, so that pointer points to the first character of next instruction
			LDR R4, R2, #0 ; Load character into R4
			LD R3, str_ptr
		BR STRING_LOOP
		
	
PRINT_ERROR_STRING
	LEA R0, ERROR
	PUTS
BR END_CODE
	
MATCH
	LD R3, str_ptr
MATCH_2
	LDR R0, R3, #0
	OUT ; Print char of user input
	ADD R3, R3, #1
	LDR R0, R3, #0 ; Load char of user input into R4
	BRz PRINT_EQUAL ; If char is 0, done printing user input
BR MATCH_2

PRINT_EQUAL
	LEA R0, equal_sign_fo
	PUTS

PRINT_OPCODE
	LDR R2, R1, #0
	LD R3, SUB_PRINT_OPCODE_fo_ptr
	JSRR R3

END_CODE

LD R0, R0_backup_3600
LD R1, R1_backup_3600	 
LD R2, R2_backup_3600
LD R3, R3_backup_3600
LD R4, R4_backup_3600	 
LD R5, R5_backup_3600
LD R6, R6_backup_3600
LD R7, R7_backup_3600

				 ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100
str_ptr					.fill x4200
SUB_GET_STRING_ptr		.fill x3800
SUB_PRINT_OPCODE_fo_ptr	.fill x3400
ERROR					.stringz "Invalid instruction"
equal_sign_fo			.stringz " = "
R0_backup_3600		.BLKW #1
R1_backup_3600		.BLKW #1
R2_backup_3600		.BLKW #1
R3_backup_3600		.BLKW #1
R4_backup_3600		.BLKW #1
R5_backup_3600		.BLKW #1
R6_backup_3600		.BLKW #1
R7_backup_3600		.BLKW #1



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
					.orig x3800
				
ST R0, R0_backup_3800
ST R1, R1_backup_3800
ST R2, R2_backup_3800
ST R3, R3_backup_3800
ST R7, R7_backup_3800
				
LEA R0, get_input
PUTS

AND R1, R1, #0
ADD R1, R1, #-10

STORE_LOOP
	GETC
	OUT
	
	ADD R3, R0, R1
	BRz DONE
	STR R0, R2, #0
	ADD R2, R2, #1
BR STORE_LOOP

AND R0, R0, #0
ADD R0, R0, #10
OUT

DONE	

LD R0, R0_backup_3800
LD R1, R1_backup_3800	 
LD R2, R2_backup_3800	
LD R3, R3_backup_3800
LD R7, R7_backup_3800	 

					ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
get_input			.stringz "enter a short string terminated by [ENTER] : "
R0_backup_3800		.BLKW #1
R1_backup_3800		.BLKW #1
R2_backup_3800		.BLKW #1
R3_backup_3800		.BLKW #1
R7_backup_3800		.BLKW #1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers, e.g. .fill #12 or .fill xC
ADD_OP				.fill #1
AND_OP				.fill #5
BR_OP				.fill #0
JMP_OP				.fill #12
JSR_OP				.fill #4
JSRR_OP				.fill #4
LD_OP				.fill #2
LDI_OP				.fill #10
LDR_OP				.fill #6
LEA_OP				.fill #14
NOT_OP				.fill #9
RET_OP				.fill #12
RTI_OP				.fill #8
ST_OP				.fill #3
STI_OP				.fill #11
STR_OP				.fill #7
TRAP_OP				.fill #15

					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
instructions				 			; - be sure to follow same order in opcode & instruction arrays!

ADD_NAME			.stringz "ADD"
AND_NAME			.stringz "AND"
BR_NAME				.stringz "BR"
JMP_NAME			.stringz "JMP"
JSR_NAME			.stringz "JSR"
JSRR_NAME			.stringz "JSRR"
LD_NAME				.stringz "LD"
LDI_NAME			.stringz "LDI"
LDR_NAME			.stringz "LDR"
LEA_NAME			.stringz "LEA"
NOT_NAME			.stringz "NOT"
RET_NAME			.stringz "RET"
RTI_NAME			.stringz "RTI"
ST_NAME				.stringz "ST"
STI_NAME			.stringz "STI"
STR_NAME			.stringz "STR"
TRAP_NAME			.stringz "TRAP"
.FILL #-1

;===============================================================================================
