;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
.orig x3000

LD R1, ptr_to_data

LD R6, subroutine1_ptr
JSRR R6

ADD R2, R2, #1

LD R6, subroutine2_ptr
JSRR R6

HALT

; local data
ptr_to_data			.FILL xB800
subroutine1_ptr		.FILL x3200
subroutine2_ptr		.FILL x3400

; remote data
.orig xB800
data_ptr	.FILL #21901

;=======================================================================
; Subroutine: LOAD_DATA
; Input (R1):The data location
; Postcondition: The subroutine loaded the data into R2
; Return Value: R2
;=======================================================================
.orig x3200

ST R1, backup_R1_3200
ST R7, backup_R7_3200

AND R2, R2, #0	; clear R2
LDR R2, R1, #0	; load R1 into R2

LD R1, backup_R1_3200
LD R7, backup_R7_3200

ret

; local data
backup_R1_3200	.BLKW 1
backup_R7_3200	.BLKW 1

;=======================================================================
; Subroutine: PRINT_DECIMAL
; Input (R2):The data
; Postcondition: The subroutine printed the data
; Return Value: N/A
;=======================================================================
.orig x3400

ST R0, backup_R0_3400
ST R1, backup_R1_3400
ST R2, backup_R2_3400
ST R3, backup_R3_3400
ST R4, backup_R4_3400
ST R5, backup_R5_3400
ST R7, backup_R7_3400

; R5 contains the total

AND R1, R1, #0
AND R3, R3, #0
AND R4, R4, #0		; counter
AND R5, R5, #0

ADD R1, R1, R2

LD R3, dec_neg_10000
DIGIT_FOUR
	ADD R4, R4, #1
	ADD R1, R1, R3
	BRnz PRINT_DIGIT_FOUR
	BR DIGIT_FOUR
	
PRINT_DIGIT_FOUR
	ADD R4, R4, #-1
	AND R0, R0, #0
	LD R0, dec_48
	ADD R0, R0, R4
	OUT
LD R3, dec_10000
ADD R1, R1, R3

AND R4, R4, #0
LD R3, dec_neg_1000
DIGIT_THREE
ADD R4, R4, #1
ADD R1, R1, R3
BRnz PRINT_DIGIT_THREE
BR DIGIT_THREE
	
PRINT_DIGIT_THREE
	ADD R4, R4, #-1
	AND R0, R0, #0
	LD R0, dec_48
	ADD R0, R0, R4
	OUT
LD R3, dec_1000
ADD R1, R1, R3

AND R4, R4, #0
LD R3, dec_neg_100
DIGIT_TWO
ADD R4, R4, #1
ADD R1, R1, R3
BRnz PRINT_DIGIT_TWO
BR DIGIT_TWO

PRINT_DIGIT_TWO
	ADD R4, R4, #-1
	AND R0, R0, #0
	LD R0, dec_48
	ADD R0, R0, R4
	OUT
LD R3, dec_100
ADD R1, R1, R3

AND R4, R4, #0
LD R3, dec_neg_10
DIGIT_ONE
ADD R4, R4, #1
ADD R1, R1, R3
BRnz PRINT_DIGIT_ONE
BR DIGIT_ONE
	
PRINT_DIGIT_ONE
	ADD R4, R4, #-1
	AND R0, R0, #0
	LD R0, dec_48
	ADD R0, R0, R4
	OUT
LD R3, dec_10
ADD R1, R1, R3

AND R4, R4, #0
LD R3, dec_neg_1
DIGIT_ZERO
ADD R4, R4, #1
ADD R1, R1, R3
BRnz PRINT_DIGIT_ZERO
BR DIGIT_ZERO
BR DIGIT_ZERO
	
PRINT_DIGIT_ZERO
	AND R0, R0, #0
	LD R0, dec_48
	ADD R0, R0, R4
	OUT
LD R3, dec_1
ADD R1, R1, R3

AND R0, R0, #0
ADD R0, R0, #10
OUT

LD R0, backup_R0_3400
LD R1, backup_R1_3400
LD R2, backup_R2_3400
LD R3, backup_R3_3400
LD R4, backup_R4_3400
LD R5, backup_R5_3400
LD R7, backup_R7_3400

ret

; local data
backup_R0_3400		.BLKW #1
backup_R1_3400		.BLKW #1
backup_R2_3400		.BLKW #1
backup_R3_3400		.BLKW #1
backup_R4_3400		.BLKW #1
backup_R5_3400		.BLKW #1
backup_R7_3400		.BLKW #1
dec_neg_10000		.FILL #-10000
dec_neg_1000		.FILL #-1000
dec_neg_100			.FILL #-100
dec_neg_10			.FILL #-10
dec_neg_1			.FILL #-1
dec_10000			.FILL #10000
dec_1000			.FILL #1000
dec_100				.FILL #100
dec_10				.FILL #10
dec_1				.FILL #1
dec_48				.FILL #48

.END
