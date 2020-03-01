;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
;
; Lab: lab 5, ex 3
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
;instructions

.ORIG x3000

AND R6, R6, #0		; clear R3
AND R2, R2, #0		; clear R2

	LD R6, BINARY_TO_DECIMAL_SUBROUTINE_PTR
	JSRR R6
	
	LD R6, DECIMAL_TO_BINARY_SUBROUTINE_PTR
	JSRR R6

HALT

; local data for main
BINARY_TO_DECIMAL_SUBROUTINE_PTR		.FILL x3200
DECIMAL_TO_BINARY_SUBROUTINE_PTR		.FILL x3400


;=======================================================================
; Subroutine: BINARY_TO_DECIMAL
; Input (R2):The value which will be printed out as DECIMAL
; Postcondition: The subroutine has stored the decimal in R2
; Return Value: R2
;=======================================================================

.ORIG x3200

; subroutine instruction

; backup registers before subroutine

ST R0, backup_R0_3200
ST R2, backup_R2_3200
ST R3, backup_R3_3200
ST R4, backup_R4_3200
ST R5, backup_R5_3200
ST R6, backup_R6_3200
ST R7, backup_R7_3200

; subroutine algorithm

AND R3, R3, #0
LD R3, ASCII_b

RETURN_TO_TOP

LEA R0, intro
PUTS
	
GETC
OUT
CHECK_IF_B
	ADD R0, R0, R3
	BRz	VALID
	
	LEA R0, error_message
	PUTS
	LD R0, newline
	OUT
	LD R0, newline
	OUT
	BR RETURN_TO_TOP
	
VALID
	
AND R2, R2, #0	; clear R2
AND R3, R3, #0	; clear R3
AND R4, R4, #0	; clear R4
AND R5, R5, #0	; clear R5

ADD R4, R4, #15
ADD R4, R4, #1

ADD R3, R3, #-12	; putting -48 into R3
ADD R3, R3, #-12
ADD R3, R3, #-12
ADD R3, R3, #-12

WHILE_LOOP
	GETC
	OUT
	
	AND R5, R5, #0
	AND R6, R6, #0
	CHECK_IF_SPACE
		LD R6, ASCII_space
		ADD R5, R6, R0
		BRz WHILE_LOOP
	
	CHECK_IF_ONE
		LD R6, DEC_49
		ADD R5, R6, R0 
		BRz VALID_CHARACTER
		
	CHECK_IF_ZERO
		LD R6, DEC_48
		ADD R5, R6, R0 
		BRz VALID_CHARACTER
		
	DISPLAY_ERROR_MESSAGE
		LEA R0, incorrect_character
		PUTS
		LD R0, newline
		OUT
		BR WHILE_LOOP
	
	VALID_CHARACTER
	
	LDR R5, R0, #0
	
	ADD R2, R2, R2			; double sum
	
	ADD R0, R0, R3			; convert to decimal
	
	CHECK_IS_ONE_OR_ZERO	; check to see if we need to add a zero or a one
		BRp	ADD_ONE
		BRnz ADD_ZERO
			ADD_ZERO
				ADD R2, R2, #0
				BR END_CHECKING_LOOP
			ADD_ONE
				ADD R2, R2, #1
	
	END_CHECKING_LOOP

	ADD R4, R4, #-1
	BRp WHILE_LOOP
	
LD R0, backup_R0_3200
;LD R2, backup_R2_3200
LD R3, backup_R3_3200
LD R5, backup_R3_3200
LD R4, backup_R4_3200
LD R6, backup_R6_3200
LD R7, backup_R7_3200

ret

; local data for subroutine
backup_R0_3200		.BLKW #1
backup_R2_3200		.BLKW #1
backup_R3_3200		.BLKW #1
backup_R4_3200		.BLKW #1
backup_R5_3200		.BLKW #1
backup_R6_3200		.BLKW #1
backup_R7_3200		.BLKW #1
intro				.STRINGZ "Enter a 2's compliment 16-bit binary number starting with a b"
error_message		.STRINGZ "the first character entered was not a b, try again"
incorrect_character	.STRINGZ "Please enter a valid character"
counter_sub			.FILL #15
DEC_NEG_12			.FILL #-12
newline				.FILL #10
ASCII_b				.FILL #-98
ASCII_space			.FILL #-32
DEC_48				.FILL #-48
DEC_49				.FILL #-49

;=======================================================================
; Subroutine: SUB_TO_BINARY_3400
; Input (R2): The value which will be printed out as binary
; Postcondition: The subroutine has printed out a 16-bit binary number
; Return Value: There is no return value
;=======================================================================

; subroutine instruction

.ORIG x3400

; backup registers affected by the subroutine
ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R2, backup_R2_3400
ST R4, backup_R4_3400
ST R7, backup_R7_3400

; subroutine algorithm
AND R1, R1, #0
ADD R1, R2, #0	; R1 <-- value to be displayed as binary 

LD R2, dec_16	;store counter into R2

WHILE_LOOP3
	ADD R1, R1, #0
	BRzp OUTPUT_ZERO	; jump to the if statement if MSG is zero or positive
	BRn	 OUTPUT_ONE		; jump to the if statement if MSB is negative

OUTPUT_ZERO
	AND R0, R0, #0		; clear R0
	LD R0, dec_48		; R0 <- ASCII 0
	OUT
	BRnzp IF_SPACE
	
OUTPUT_ONE
	AND R0, R0, #0		; clear R0
	LD R0, dec_49		; R0 <- ASCII 1
	OUT
	BRnzp IF_SPACE
	
IF_SPACE
	ADD R1, R1, R1		; shift the binary number one to the left
	ADD R2, R2, #-1		; decrement the counter by one
	BRz	PRINT_NEWLINE	; if we are done printing the number, print a newline
	ADD R4, R2, #-12
	BRz PRINT_SPACE
	ADD R4, R2, #-8
	BRz PRINT_SPACE
	ADD R4, R2, #-4
	BRz PRINT_SPACE
	BR WHILE_LOOP3
	
PRINT_SPACE
	LD R0, space_char
	OUT					; print a space
	BR WHILE_LOOP3
	
PRINT_NEWLINE
	LD R0, newline_char
	OUT					; print a newline character

; restore backed up registers
LD R0, backup_R0_3400
LD R1, backup_R1_3400
LD R2, backup_R2_3400
LD R4, backup_R4_3400
LD R7, backup_R7_3400

; return
ret

; local data for subroutine
backup_R0_3400		.BLKW #1
backup_R1_3400		.BLKW #1
backup_R2_3400		.BLKW #1
backup_R4_3400		.BLKW #1
backup_R7_3400		.BLKW #1
dec_16				.FILL #16
dec_48				.FILL #48	; ASCII for 0
dec_49				.FILL #49	; ASCII for 1
space_char			.FILL #32	; ASCII for space char
newline_char 		.FILL #10	; ASCII for newline char

.END
