;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

.ORIG x3000

AND R1, R1, #0		; clear R1

LD R1, subroutine_ptr
JSRR R1

HALT

; local data
subroutine_ptr	.FILL x3200

;=======================================================================
; Subroutine: STORE_STRING
; Input (R1):The starting address of the character array
; Postcondition: The subroutine prompted the user to enter the string terminated by the enter key.
; Return Value: R5, the number of non-sentinal chacters entered by the user
;=======================================================================

.ORIG x3200

ST R0, backup_R0_3200
;ST R1, backup_R1_3200
ST R2, backup_R2_3200
ST R3, backup_R3_3200
ST R7, backup_R7_3200

AND R5, R5, #0		; clear R5 to be a counter
AND R3, R3, #0		; clear R3
LD R3, array_ptr

LEA R0, intro
PUTS

LD R0, newlineChar
OUT

INPUT_LOOP
	AND R2, R2, #0		; clear R2
	GETC
	OUT
	ST R0, userInput
	LD R2, userInput
	ADD R2, R2, #-10
	BRz	EXIT_LOOP
STR R0, R3, #0
ADD R3, R3, #1
ADD R5, R5, #1
BR INPUT_LOOP

EXIT_LOOP

LD R0, newlineChar
OUT

LD R0, backup_R0_3200
;LD R1, backup_R1_3200
LD R2, backup_R2_3200
LD R3, backup_R3_3200
LD R7, backup_R7_3200

ret

; local data
intro			.STRINGZ "enter a string and end it using the ENTER key"
backup_R0_3200	.BLKW 1
;backup_R1_3200	.BLKW 1
backup_R2_3200	.BLKW 1
backup_R3_3200	.BLKW 1
backup_R7_3200	.BLKW 1
array_ptr		.FILL xB800
newlineChar		.FILL #10
userInput		.FILL ' '

; remote data
.ORIG xB800
array			.BLKW 100

.END
