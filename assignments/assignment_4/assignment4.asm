;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 025
; TA: Jang-Shing Lin
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R2
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------

TOP_OF_CODE

; clear the used registers
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R5, R5, #0
AND R6, R6, #0

; output intro prompt
LD R0, introPromptPtr
PUTS
						
; Set up flags, counters, accumulators as needed

LD R6, inputCounter		; input counter

CHECK_FIRST_INPUT
; Get first character, test for '\n', '+', '-', digit/non-digit 	
GETC
OUT

; check if the first input is a newline and if it is, end the program
; is very first character = '\n'? if so, just quit (no message)!
LD R1, ASCIInewline		; Load the newline character
ADD R1, R0, R1
BRz END_PROGRAM		

; is it = '+'? if so, ignore it, go get digits
AND R1, R1, #0
LD R1, ASCIIplus
ADD R1, R0, R1
BRz	CHECK_NUMBER
				
; is it = '-'? if so, set neg flag, go get digits
AND R1, R1, #0
LD R1, ASCIIminus
ADD R1, R0, R1
BRz	MAKE_NEGATIVE	; make negative

BR SKIP_GETTING_NUMBER

MAKE_NEGATIVE
	ADD R5, R5, #-1		; R5 tells us that this is a negative number

CHECK_NUMBER			; checks to see that it is a valid integer
	GETC
	OUT

	SKIP_GETTING_NUMBER

	LD R1, ASCIInewline
	ADD R1, R0, R1
	BRz	CHECK_SIGN	

	; is it < '0'? if so, it is not a digit	- o/p error message, start over
	AND R1, R1, #0
	LD R1, DECNEG48
	ADD R1, R0, R1
	BRn	PRINT_ERROR				; incorrect input, restart

	; is it > '9'? if so, it is not a digit	- o/p error message, start over
	AND R1, R1, #0
	LD R1, DECNEG57
	ADD R1, R0, R1
	BRp	PRINT_ERROR				; incorrect input, restart
			
	; convert the user input from ascii to decimal
	AND R1, R1, #0
	LD R1, DECNEG48
	ADD R1, R0, R1		
				
	; if none of the above, first character is first numeric digit - convert it to number & store in target register

	; shift the decimal over by 10
	AND R0, R0, #0
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3
	ADD R0, R0, R3

	; clear register 3
	AND R3, R3, #0
	; Load the user input into R3
	ADD R3, R0, R3
	; ADD the user input to the existing user input
	ADD R3, R3, R1

	; decrement the counter
	ADD R6, R6, #-1
	BRp CHECK_NUMBER	; go back to the top of the loop

BR END_GET_DIGITS

PRINT_ERROR
	LD R0, newlineChar
	OUT
	LD R0, errorMessagePtr
	PUTS
	BR TOP_OF_CODE

END_GET_DIGITS
	LD R0, newlineChar
	OUT

CHECK_SIGN
	ADD R5, R5, #0
	BRz POSITIVE_NUMBER		; check if the inputted value was negative and do two's compliment if it was

	NOT R3, R3
	ADD R3, R3, #1

POSITIVE_NUMBER

END_PROGRAM
	; clear Register 2
	AND R2, R2, #0
	; load the final answer into Register 2 from Register 3
	ADD R2, R3, R2

HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xA100
errorMessagePtr		.FILL xA200
inputCounter		.FILL #5
ASCIIplus			.FILL #-43
ASCIIminus			.FILL #-45
ASCIInewline		.FILL #-10
newlineChar			.FILL #10
DECNEG48			.FILL #-48
DEC48				.FILL #48
DECNEG57			.FILL #-57

;------------
; Remote data
;------------
					.ORIG xA100			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xA200			; error message
					.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
