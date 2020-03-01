;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 6, ex 3
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

.ORIG x3000

AND R1, R1, #0		; clear R1

LD R6, string_subroutine_ptr
JSRR R6

LD R6, palindrome_subroutine_ptr
JSRR R6

LEA R0, INTRO
PUTS

AND R0, R0, #0
ADD R0, R0, R1
PUTS

ADD R4, R4, #0
BRp STRING_IS_PALINDROME

STRING_IS_NOT_A_PALINDROME
	LEA R0, NOT_PALINDROME
	PUTS
BR END_MAIN

STRING_IS_PALINDROME
	LEA R0, IS_PALINDROME
	PUTS
BR END_MAIN

END_MAIN

HALT

; local data
string_subroutine_ptr		.FILL x3200
palindrome_subroutine_ptr	.FILL x3400
INTRO					.STRINGZ " The string "
IS_PALINDROME			.STRINGZ " is a palindrome"
NOT_PALINDROME			.STRINGZ " is not a palindrome"

;=======================================================================
; Subroutine: STORE_STRING
; Input (R1):The starting address of the character array
; Postcondition: The subroutine prompted the user to enter the string terminated by the enter key.
; Return Value: R5, the number of non-sentinal chacters entered by the user
;=======================================================================

.ORIG x3200

ST R0, backup_R0_3200
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
	LD R2, userInput
	ADD R2, R2, #-16
	ADD R2, R2, #-16
	BRz	INPUT_LOOP
STR R0, R3, #0
ADD R3, R3, #1
ADD R5, R5, #1
BR INPUT_LOOP

EXIT_LOOP

LD R0, newlineChar
OUT

LD R0, backup_R0_3200
LD R2, backup_R2_3200
LD R3, backup_R3_3200
LD R7, backup_R7_3200

LD R1, array_ptr

ret

; local data
intro			.STRINGZ "enter a string and end it using the ENTER key"
backup_R0_3200	.BLKW 1
backup_R1_3200	.BLKW 1
backup_R2_3200	.BLKW 1
backup_R3_3200	.BLKW 1
backup_R7_3200	.BLKW 1
array_ptr		.FILL xB800
newlineChar		.FILL #10
userInput		.FILL ' '

; remote data
.ORIG xB800
array			.BLKW 100

;=======================================================================
; Subroutine: CHECK_PALINDROME
; Input (R1):The starting address of the character array
;		(R5):The number of characters in the array
; Postcondition: The subroutine found of the string is a palindrome
; Return Value: R4, 1 if the string is a palindrome, 0 otherwise
;=======================================================================

.ORIG x3400

ST R0, backup_R0_3400
ST R2, backup_R2_3400
ST R3, backup_R3_3400
ST R5, backup_R5_3400
ST R6, backup_R6_3400
ST R7, backup_R7_3400

LD R6, sub_to_upper_subroutine
JSRR R6

AND R7, R7, #0		; clear R7
AND R4, R4, #0		; clear R4
AND R3, R3, #0		; clear R3
AND R2, R2, #0		; clear R2

;LD R3, backup_R3_3400
;LD R2, #0			; counter

ADD R2, R2, R1		; load the left letter into R2
ADD R3, R1, R5		; load the right letter into R3
ADD R3, R3, #-1

PALINDROME_LOOP

	AND R4, R4, #0
	ADD R4, R4, R3
	NOT R4, R4
	ADD R4, R4, #1
	ADD R4, R4, R2 ; Subtracting address R3 from address R2
	
BRzp EXIT			; if you've iterated all the way through, exit

LDR R5, R2, #0		; left letter into R5
LDR R6, R3, #0		; right letter into R6

NOT R6, R6			; invert R6
ADD R6, R6, #1		; two's compliment of right value
ADD R0, R5, R6
BRnp EXIT_BAD

ADD R2, R2, #1
ADD R3, R3, #-1

BR PALINDROME_LOOP

EXIT
AND R4, R4, #0
ADD R4, R4, #1
BR DONE

EXIT_BAD
AND R4, R4, #0

DONE

LD R0, backup_R0_3400
LD R2, backup_R2_3400
LD R3, backup_R3_3400
LD R5, backup_R5_3400
LD R6, backup_R6_3400
LD R7, backup_R7_3400

ret

; local data
backup_R0_3400	.BLKW 1
backup_R2_3400	.BLKW 1
backup_R3_3400	.BLKW 1
backup_R5_3400	.BLKW 1
backup_R6_3400	.BLKW 1
backup_R7_3400	.BLKW 1
sub_to_upper_subroutine		.FILL x3600
;array_ptr		.FILL xB800


;=======================================================================
; Subroutine: SUB_TO_UPPER
; Input (R1):The starting address of the character array
;		(R5):The number of characters in the array
; Postcondition: The subroutine has converted the string to uppercase
; Return Value: No return value
;=======================================================================

.ORIG x3600

ST R0, backup_R0_3600
ST R2, backup_R2_3600
ST R3, backup_R3_3600
ST R5, backup_R5_3600
ST R6, backup_R6_3600
ST R7, backup_R7_3600

AND R2, R2, #0
AND R4, R4, #0
ADD R2, R2, R1

LD R6, HEX_DF
ADD R4, R4, R5
ADD R5, R5, #-1

CASE_LOOP
	LDR R3, R2, #0
	AND R3, R3, R6
	STR R3, R2, #0
	ADD R2, R2, #1
	ADD R4, R4, #-1
	BRp CASE_LOOP
	
LD R0, backup_R0_3600
LD R2, backup_R2_3600
LD R3, backup_R3_3600
LD R5, backup_R5_3600
LD R6, backup_R6_3600
LD R7, backup_R7_3600


ret

; local data
HEX_DF			.FILL xDF
backup_R0_3600	.BLKW 1
backup_R2_3600	.BLKW 1
backup_R3_3600	.BLKW 1
backup_R5_3600	.BLKW 1
backup_R6_3600	.BLKW 1
backup_R7_3600	.BLKW 1

.END
