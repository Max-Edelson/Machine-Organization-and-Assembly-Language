;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

; test harness
					.orig x3000

LD R4, baseptr
LD R5, maxptr
LD R6, tosptr

GET_INPUT

	AND R1, R1, #0
	ADD R1, R1, #12
	ADD R1, R1, #12
	ADD R1, R1, #12
	ADD R1, R1, #12
	ADD R1, R1, #1
	
	NOT R1, R1
	ADD R1, R1, #1

	LEA R0, intro
	PUTS

	GETC
	OUT
	
	ADD R2, R1, R0
	BRz PUSH_SUB
	
	ADD R1, R1, #-1
	ADD R2, R1, R0
	BRz POP_SUB
	
	ADD R1, R1, #-1
	ADD R2, R1, R0
	BRz QUIT
	BR PRINT_ERROR_MSG
	
	PUSH_SUB
		AND R0, R0, #0
		ADD R0, R0, #10
		OUT
	
		LEA R0, push_msg
		PUTS
		
		GETC
		OUT
		
		LD R2, PUSH_SUB_PTR
		JSRR R2
	BR GET_INPUT
	
	POP_SUB
		AND R0, R0, #0
		ADD R0, R0, #10
		OUT
		
		LD R2, POP_SUB_PTR
		JSRR R2
	BR GET_INPUT
	
	PRINT_ERROR_MSG
		AND R0, R0, #0
		ADD R0, R0, #10
		OUT
	
		LEA R0, error_msg
		PUTS
	
	END_OF_MAIN
	
BR GET_INPUT
	
QUIT
	
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
baseptr			.FILL xA000
maxptr			.fill xA005
tosptr			.fill xA000
intro			.stringz "\nWould you like to PUSH onto the stack or POP from the stack? Press 1 for push and 2 for pop and 3 to end the program.\n"
push_msg		.stringz "What character or digit would you like to push onto the stack?\n"
error_msg		.stringz "That was not a correct option, try again.\n"
neg1			.fill x31
neg2			.fill x32
neg3			.fill x33

PUSH_SUB_PTR	.fill x3200
POP_SUB_PTR		.fill x3400

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

