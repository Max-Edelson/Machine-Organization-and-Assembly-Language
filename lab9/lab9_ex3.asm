;=================================================
; Name: Max Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 9, ex 3
; TA: Jang-Shing Lin
; 
;=================================================

; test harness
					.orig x3000
LD R4, baseptr
LD R5, maxptr
LD R6, tosptr

TOP

	AND R3, R3, #0
	ADD R3, R3, #2
	
	GET_NUMBERS
		LEA R0, character_prompt
		PUTS
		
		GETC
		OUT
		
		LD R1, ascii_zero
		ADD R1, R1, R0
		BRn PRINT_ERROR_MSG
		
		LD R1, ascii_nine
		ADD R1, R1, R0
		BRp PRINT_ERROR_MSG
		
		LD R2, PUSH_SUB_PTR
		JSRR R2
		
		LEA R0, newline
		PUTS
		
		ADD R3, R3, #-1
	BRp GET_NUMBERS
	
	LEA R0, multiplication_prompt
	PUTS
	
	GETC 
	OUT
	
	LD R1, ascii_star
	ADD R1, R1, R0
	BRnp PRINT_ERROR_MSG
	
	LD R2, MULTIPLICATION_PTR
	JSRR R2
	
BR DONE_MAIN

PRINT_ERROR_MSG
	LEA R0, error_msg
	PUTS

DONE_MAIN
	
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
character_prompt		.stringz "enter a single numeric character\n"
multiplication_prompt	.stringz "enter the multiplication symbol\n"
error_msg				.stringz "\nincorrect input\n"
newline					.stringz "\n"
baseptr			.FILL xA000
maxptr			.fill xA005
tosptr			.fill xA000
ascii_zero		.fill #-48
ascii_nine		.fill #-57
ascii_star		.fill #-42

PUSH_SUB_PTR		.fill x3200
MULTIPLICATION_PTR 	.fill x3600
;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3200
				 
ST R0, R0_backup_3200
ST R1, R1_backup_3200
ST R5, R5_backup_3200
ST R7, R7_backup_3200
		 
AND R1, R1, #0
ADD R1, R1, R6

NOT R1, R1
ADD R1, R1, #1

ADD R1, R1, R5
BRnz	DISPLAY_OVERFLOW	; TOS is at the MAX

ADD R6, R6, #1
STR R0, R6, #0				; Mem[R6] <- R0
		
BR END_SUB_PUSH		 
				 
DISPLAY_OVERFLOW
	LEA R0, overflow_msg
	PUTS

END_SUB_PUSH

LD R0, R0_backup_3200
LD R1, R1_backup_3200
LD R5, R5_backup_3200
LD R7, R7_backup_3200

					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
overflow_msg			.stringz "overflowed\n"
R0_backup_3200			.BLKW #1
R1_backup_3200			.BLKW #1
R5_backup_3200			.BLKW #1
R7_backup_3200			.BLKW #1
;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      ;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
				 
ST R1, R1_backup_3400
ST R5, R5_backup_3400
ST R7, R7_backup_3400
		 
AND R1, R1, #0
ADD R1, R1, R6

NOT R1, R1
ADD R1, R1, #1

ADD R1, R1, R4
BRzp DISPLAY_UNDERFLOW		; TOS is at the BASE

LDR R0, R6, #0

AND R1, R1, #0
STR R1, R6, #0

ADD R6, R6, #-1
		
BR END_SUB_POP	 
				 
DISPLAY_UNDERFLOW
	LEA R0, underflow_msg
	PUTS

END_SUB_POP

LD R1, R1_backup_3400
LD R5, R5_backup_3400
LD R7, R7_backup_3400
				 		 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
underflow_msg			.stringz "underflowed\n"
R1_backup_3400			.BLKW #1
R5_backup_3400			.BLKW #1
R7_backup_3400			.BLKW #1

;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
					.orig x3600

ST R0, backup_R0_3600
ST R1, backup_R1_3600
ST R2, backup_R2_3600
ST R3, backup_R3_3600
ST R4, backup_R4_3600
ST R5, backup_R5_3600
ST R7, backup_R7_3600

AND R1, R1, #0
AND R2, R2, #0

LD R3, POP_SUB_PTR
JSRR R3				 
	
ADD R1, R1, R0			; R1 <- first number
LD R7, neg_dec_48
ADD R1, R1, R7

LD R3, POP_SUB_PTR
JSRR R3				 
	
ADD R2, R2, R0		 	; R2 <- second number
LD R7, neg_dec_48
ADD R2, R2, R7
	
ADD R1, R1, #0
BRz RESULT_ZERO
	
ADD R2, R2, #0
BRz RESULT_ZERO

AND R0, R0, #0
ADD R0, R0, R1
		
ADD R2, R2, #-1

MULTIPLICATION_LOOP
	ADD R2, R2, #0
	BRnz DONE_MULTIPLYING
	
	ADD R1, R1, R0
	
	ADD R2, R2, #-1
BR MULTIPLICATION_LOOP

DONE_MULTIPLYING
	AND R0, R0, #0
	ADD R0, R0, R1
BR PUSH_R0

RESULT_ZERO
	AND R0, R0, #0
	
PUSH_R0
	LD R2, PUSH_SUB_PTR2
	JSRR R2
	
PRINT_TOS
	LD R2, PRINT_PTR
	JSRR R2
	
LD R0, backup_R0_3600
LD R1, backup_R1_3600
LD R2, backup_R2_3600
LD R3, backup_R3_3600
LD R4, backup_R4_3600
LD R5, backup_R5_3600
LD R7, backup_R7_3600
	 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

POP_SUB_PTR			.fill x3400
PUSH_SUB_PTR2		.fill x3200
PRINT_PTR			.fill x3800
neg_dec_48			.fill #-48
backup_R0_3600		.BLKW #1
backup_R1_3600		.BLKW #1
backup_R2_3600		.BLKW #1
backup_R3_3600		.BLKW #1
backup_R4_3600		.BLKW #1
backup_R5_3600		.BLKW #1
backup_R7_3600		.BLKW #1

;===============================================================================================

;=======================================================================
; Subroutine: PRINT_DECIMAL
; Input (R0):The data
; Postcondition: The subroutine printed the data
; Return Value: N/A
;=======================================================================
.orig x3800

ST R0, backup_R0_3800
ST R1, backup_R1_3800
ST R2, backup_R2_3800
ST R3, backup_R3_3800
ST R4, backup_R4_3800
ST R5, backup_R5_3800
ST R7, backup_R7_3800

; R5 contains the total

AND R1, R1, #0		; counter

TEN_TRACKER
	ADD R0, R0, #-10
	BRn LESS_THAN_TEN
	ADD R1, R1, #1
BR TEN_TRACKER
	
LESS_THAN_TEN
	ADD R0, R0, #10
	
AND R2, R2, #0
ADD R2, R2, R0

LD R0, dec_48
ADD R0, R0, R1

OUT

LD R0, dec_48
ADD R0, R0, R2
OUT

LD R0, backup_R0_3800
LD R1, backup_R1_3800
LD R2, backup_R2_3800
LD R3, backup_R3_3800
LD R4, backup_R4_3800
LD R5, backup_R5_3800
LD R7, backup_R7_3800

ret

; local data
backup_R0_3800		.BLKW #1
backup_R1_3800		.BLKW #1
backup_R2_3800		.BLKW #1
backup_R3_3800		.BLKW #1
backup_R4_3800		.BLKW #1
backup_R5_3800		.BLKW #1
backup_R7_3800		.BLKW #1
dec_48				.FILL #48

; SUB_MULTIPLY		

; SUB_GET_NUM		

; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.


