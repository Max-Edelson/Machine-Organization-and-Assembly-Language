;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
.orig x3000

LEA R0, intro
PUTS

LD R0, newline
OUT

GETC
OUT

ST R0, user_input

LD R6, subroutine_ptr
JSRR R6

LD R0, newline
OUT

LEA R0, second_statement
PUTS

LD R0, user_input
OUT

LEA R0, third_statement
PUTS

LD R2, DEC48
AND R0, R0, #0
ADD R0, R0, R2
ADD R0, R0, R5
OUT

LD R0, newline
OUT

HALT

; local data
intro				.STRINGZ "enter a single character"
second_statement	.STRINGZ "The number of 1's in '"
third_statement		.STRINGZ "' is: "
newline				.FILL #10
subroutine_ptr		.FILL x3200
user_input			.FILL #0
DEC48				.FILL #48

;=======================================================================
; Subroutine: RETURN_1's
; Input (R0):The character
; Postcondition: The subroutine counted the 1's
; Return Value: R5, the number of 1's
;=======================================================================
.orig x3200

ST R0, backup_R0_3200
ST R2, backup_R2_3200
ST R4, backup_R4_3200
ST R7, backup_R7_3200

AND R5, R5, #0		; clear R5 to count the 1's
AND R4, R4, #0		; clear R4 to be a counter
AND R2, R2, #0

ADD R2, R2, R0
ADD R4, R4, #15
ADD R4, R4, #1

WHILE_LOOP
	ADD R2, R2, #0
	BRn ADD_ONE
	BR NOT_ONE
	
	ADD_ONE
		ADD R5, R5, #1
	
	NOT_ONE
		ADD R2, R2, R2
	
	ADD R4, R4, #-1
BRp WHILE_LOOP

LD R0, backup_R0_3200
LD R2, backup_R2_3200
LD R4, backup_R4_3200
LD R7, backup_R7_3200

ret

; local data
backup_R0_3200	.BLKW 1
backup_R2_3200	.BLKW 1
backup_R4_3200	.BLKW 1
backup_R7_3200	.BLKW 1

.END
