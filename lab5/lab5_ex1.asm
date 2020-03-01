;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
;instructions

.ORIG x3000

AND R3, R3, #0 	; clear R3
ADD R3, R3, #1 	; set R3 to 1
AND R2, R2, #0 	; clear R2
LD R2, counter	; load the counter into R2
AND R4, R4, #0	; clear R4
LD R4, DATA_PTR	; load the data pointer into R4

WHILE_LOOP1

	STR R3, R4, #0	; store R4 <-- R3
	
	ADD R4, R4, #1	; move the pointer forwards one
	ADD R3, R3, R3	; double R3
	ADD R2, R2, #-1	; decrement the counter
	BRp WHILE_LOOP1	; continue while the counter is a positive number
	
AND R4, R4, #0	; clear R4
LD R4, DATA_PTR	; load the data pointer into R4
LD R2, counter	; load the counter back into R2
	
WHILE_LOOP2
	;LDR R0, R4, #0
	LD R6, subroutine_ptr
	jsrr R6
	
	;LD R0, newline
	;OUT
	
	ADD R4, R4, #1	; move the pointer forwards one
	ADD R2, R2, #-1	; decrement the pointer
	
	BRp WHILE_LOOP2 

HALT

;local data
DATA_PTR 		.FILL x4000
counter		    .FILL #10
newline			.FILL #10
subroutine_ptr	.FILL x3200

.orig x4000
array .BLKW 10

;=======================================================================
; Subroutine: SUB_TO_BINARY_3200
; Input (R2): The value which will be printed out as binary
; Postcondition: The subroutine has printed out a 16-bit binary number
; Return Value: There is no return value
;=======================================================================

.ORIG x3200

; subroutine instruction

; backup registers affected by the subroutine
ST R0, backup_R0_3200
ST R1, backup_R1_3200
ST R2, backup_R2_3200
ST R4, backup_R4_3200
ST R6, backup_R6_3200
ST R7, backup_R7_3200

; subroutine algorithm
LDR R1, R4, #0	; R1 <-- value to be displayed as binary 

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
LD R0, backup_R0_3200
LD R1, backup_R1_3200
LD R2, backup_R2_3200
LD R4, backup_R4_3200
LD R6, backup_R6_3200
LD R7, backup_R7_3200

; return
ret

; local data for subroutine
backup_R0_3200		.BLKW #1
backup_R1_3200		.BLKW #1
backup_R2_3200		.BLKW #1
backup_R4_3200		.BLKW #1
backup_R6_3200		.BLKW #1
backup_R7_3200		.BLKW #1
dec_16				.FILL #16
dec_48				.FILL #48	; ASCII for 0
dec_49				.FILL #49	; ASCII for 1
space_char			.FILL #32	; ASCII for space char
newline_char 		.FILL #10	; ASCII for newline char

.END
