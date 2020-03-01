;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Assignment name: Assignment 2
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
;Instructis
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------

GETC
OUT
ST R0, first ; get the first number

LD R0, newline
OUT

GETC
OUT
ST R0, second ; get the second number

LD R0, newline
OUT

LD R0, first
OUT
LEA R0, dash
PUTS
LD R0, second
OUT
LEA R0, equal
PUTS

LD R5, first
;ADD R5, R5, #-15
;ADD R5, R5, #-15
ADD R5, R5, #-16
ADD R5, R5, #-16
ADD R5, R5, #-16

LD R6, second
ADD R6, R6, #-16
ADD R6, R6, #-16
ADD R6, R6, #-16
;ADD R5, R5, #-15
;ADD R5, R5, #-15

NOT R6, R6
ADD R6, R6, #1

ADD R2, R5, R6	;performs subtraction

IF_STATEMENT
	BRzp	FALSE_CONDITION
TRUE_CONDITION
	NOT R2, R2
	ADD R2, R2, #1
	LEA R0, dash2
	PUTS
FALSE_CONDITION
END_IF

;LDR R0, R2, #0
;OUT

;ADD R2, R2, #15
;ADD R2, R2, #15
ADD R2, R2, #15
ADD R2, R2, #15
ADD R2, R2, #15
ADD R2, R2, #3
;ADD R2, R2, x0F
;ADD R2, R2, x03

ST R2, answer
LD R0, answer
OUT

LD R0, newline
OUT

HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
equal 	.STRINGZ " = "
dash	.STRINGZ " - "
dash2	.STRINGZ "-"
first	.FILL #0
second	.FILL #0
answer 	.FILL #0

;---------------	
;END of PROGRAM
;---------------	
.END

