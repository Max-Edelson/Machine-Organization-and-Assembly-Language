;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Assignment name: Assignment 5
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
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

START

LD R6, menu_subroutine
JSRR R6

MENU_LOOP
	
	AND R2, R2, #0
	ADD R2, R2, #-1
	ADD R2, R2, R1		; Seeing if user choice = 1
	BRz CHECK_TO_SEE_MACHINES_BUSY
	
	AND R2, R2, #0
	ADD R2, R2, #-2
	ADD R2, R2, R1		; Seeing if user choice = 2
	BRz CHECK_TO_SEE_MACHINES_FREE

	AND R2, R2, #0
	ADD R2, R2, #-3
	ADD R2, R2, R1		; Seeing if user choice = 3
	BRz NUM_BUSY
	
	AND R2, R2, #0
	ADD R2, R2, #-4
	ADD R2, R2, R1		; Seeing if user choice = 4
	BRz NUM_FREE
	
	AND R2, R2, #0
	ADD R2, R2, #-5
	ADD R2, R2, R1		; Seeing if user choice = 5
	BRz STATUS_MACHINE
	
	AND R2, R2, #0
	ADD R2, R2, #-6
	ADD R2, R2, R1		; Seeing if user choice = 6
	BRz FIRST_AVAILABLE
	
	AND R2, R2, #0
	ADD R2, R2, #-7
	ADD R2, R2, R1		; Seeing if user choice = 7
	BRz QUIT

	; user choice = 1

	CHECK_TO_SEE_MACHINES_BUSY
		LD R6, MACHINE_BUSY_PTR
		JSRR R6
		
		ADD R2, R2, #0
		BRp ALL_BUSY			; all machines are busy
		BRz	NOT_ALL_BUSY		; not all machines are busy
	BRn	MENU_ERROR				; error

	ALL_BUSY
		LEA R0, allbusy
		PUTS
	BR START

	NOT_ALL_BUSY
		LEA R0, allnotbusy
		PUTS
	BR START
	
	; user choice = 2
	
	CHECK_TO_SEE_MACHINES_FREE
		LD R6, MACHINE_FREE_PTR
		JSRR R6
	
		ADD R2, R2, #0
		BRp ALL_FREE			; all machines are free
		BRz	NOT_ALL_FREE		; not all machines are free
	BRn	MENU_ERROR				; error

	ALL_FREE
		LEA R0, allfree
		PUTS
	BR START

	NOT_ALL_FREE
		LEA R0, allnotfree
		PUTS
	BR START

	; user choice = 3
	
	NUM_BUSY
		LD R6, NUM_BUSY_MACHINES_PTR
		JSRR R6

		LEA R0, busymachine1
		PUTS
		
		AND R1, R1, #0
		ADD R1, R1, R2
		
		LD R6, PRINT_NUM_PTR
		JSRR R6
		
		LEA R0, busymachine2
		PUTS
		
	BR START
		
	; user choice = 4
	
	NUM_FREE
		LD R6, NUM_FREE_MACHINES_PTR
		JSRR R6
	
		LEA R0, freemachine1
		PUTS
		
		AND R1, R1, #0
		ADD R1, R1, R2
		
		LD R6, PRINT_NUM_PTR
		JSRR R6
		
		LEA R0, freemachine2
		PUTS
		
	BR START
	
	; user choice = 5
	
	STATUS_MACHINE
	
		LD R6, MACHINE_STATUS_PTR
		JSRR R6
		
		ADD R2, R2, #0
		BRp MACHINE_FREE
		BRz	MACHINE_BUSY
		BRn MENU_ERROR
	
		MACHINE_FREE
			LEA R0, status1
			PUTS
			
			LD R6, PRINT_NUM_PTR
			JSRR R6
			
			LEA R0, status3
			PUTS
		BR START
	
		MACHINE_BUSY
			LEA R0, status1
			PUTS
			
			LD R6, PRINT_NUM_PTR
			JSRR R6
			
			LEA R0, status2
			PUTS
		BR START

	; user choice = 6
	
	FIRST_AVAILABLE
		LD R6, FIRST_FREE_PTR
		JSRR R6
		
		ADD R2, R2, #0
		BRn NONE_FREE
		
		LEA R0, firstfree1
		PUTS
		
		AND R1, R1, #0
		ADD R1, R1, R2			; PRINT_NUM takes in R1 as the input
		
		LD R6, PRINT_NUM_PTR
		JSRR R6
		
		AND R0, R0, #0
		ADD R0, R0, #10
		OUT
		
		BR START
		
		NONE_FREE
		
		LEA R0, firstfree2
		PUTS
	BR START

	; user choice = 7
	
	QUIT
		LEA R0, goodbye
		PUTS
	BR END

	MENU_ERROR
		LEA R0, menu_error_msg
		PUTS
	BR START

END

HALT
;---------------	
;Data
;---------------
;Subroutine pointers
menu_subroutine			.FILL x3300
MACHINE_BUSY_PTR		.fill x3600
MACHINE_FREE_PTR		.fill x3900
NUM_BUSY_MACHINES_PTR 	.fill x4200
NUM_FREE_MACHINES_PTR	.fill x4500
MACHINE_STATUS_PTR		.fill x4800
FIRST_FREE_PTR			.fill x5100
PRINT_NUM_PTR			.fill x5700

;Other data 
newline 		.fill '\n'

; Strings for reports from menu subroutines:
menu_error_msg	.stringz "whoops\n"
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree2      .stringz "No machines are free\n"
firstfree1      .stringz "The first available machine is number "


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------

.orig x3300

ST R0, R0_backup_3300
ST R2, R2_backup_3300
ST R7, R7_backup_3300

START_LISTING

	LD R0, Menu_string_addr
	PUTS

	GETC
	OUT
	
	AND R1, R1, #0
	ADD R1, R1, R0			; save user input
	
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT						; newline
	
	LD R2, NEG_48
	ADD R2, R2, R1
	
	BRnz PRINT_ERROR		; checked if the ascii number is too small
	
	LD R2, NEG_55
	
	ADD R2, R2, R1
	
	BRp	PRINT_ERROR		; checked if the ascii number is too big
	
	LD R2, NEG_48
	ADD R1, R1, R2
	
	BR  DONE
	
PRINT_ERROR
	LEA R0, Error_msg_1
	PUTS
BR START_LISTING
	
DONE

;LD R0, newlineChar
;OUT

LD R0, R0_backup_3300
LD R2, R2_backup_3300
LD R7, R7_backup_3300

ret

;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x6A00
NEG_48			  .FILL #-48
NEG_55			  .FILL #-55
R0_backup_3300	  .BLKW #1
R2_backup_3300	  .BLKW #1
R7_backup_3300	  .BLKW #1
newlineChar		  .BLKW #10

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.orig x3600

ST R1, R1_backup_3600
ST R7, R7_backup_3600

LDI R1, BUSYNESS_ADDR_ALL_MACHINES_BUSY

AND R2, R2, #0
ADD R2, R2, #-1

AND R2, R2, R1
BRz RETURN_ONE1
BRnp RETURN_ZERO1

RETURN_ZERO1
	AND R2, R2, #0
BR DONE1

RETURN_ONE1
	AND R2, R2, #0
	ADD R2, R2, #1

DONE1

LD R1, R1_backup_3600
LD R7, R7_backup_3600

ret

;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xBA00
R1_backup_3600					.BLKW #1
R7_backup_3600					.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.orig x3900

ST R1, R1_backup_3900
ST R3, R3_backup_3900			; counter
ST R7, R7_backup_3900

LDI R1, BUSYNESS_ADDR_ALL_MACHINES_FREE

LD R2, HEXFFFF
NOT R2, R2
ADD R2, R2, #1

ADD R2, R2, R1
BRz RETURN_ONE2
BRnp RETURN_ZERO2

RETURN_ZERO2
	AND R2, R2, #0
BR DONE2

RETURN_ONE2
	AND R2, R2, #0
	ADD R2, R2, #1

DONE2

LD R1, R1_backup_3900
LD R3, R3_backup_3900
LD R7, R7_backup_3900

ret

;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xBA00
R1_backup_3900					.BLKW #1
R3_backup_3900					.BLKW #1
R7_backup_3900					.BLKW #1
DEC_16 							.FILL #16
HEXFFFF							.fill xFFFF

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R2): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.orig x4200

ST R1, R1_backup_4200
ST R3, R3_backup_4200			; Count the number of loop cycles		
ST R7, R7_backup_4200		

LDI R1, BUSYNESS_ADDR_NUM_BUSY_MACHINES
AND R3, R3, #0
ADD R3, R3, #8
ADD R3, R3, #8

AND R2, R2, #0		; clear R2

LOOP3
	ADD R3, R3, #0
	BRz DONE3

	ADD R1, R1, #0
	BRzp FOUND_ZERO3
	BR ITERATE3
	
	FOUND_ZERO3
		ADD R2, R2, #1
	
	ITERATE3
	ADD R1, R1, R1
	ADD R3, R3, #-1
BR LOOP3

DONE3

LD R1, R1_backup_4200
LD R3, R3_backup_4200
LD R7, R7_backup_4200

ret

;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xBA00
R1_backup_4200					.BLKW #1
R3_backup_4200					.BLKW #1
R7_backup_4200					.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R2): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.orig x4500

ST R1, R1_backup_4500
ST R3, R3_backup_4500			; Count the number of loop cycles		
ST R7, R7_backup_4500		

LDI R1, BUSYNESS_ADDR_NUM_FREE_MACHINES
AND R3, R3, #0
ADD R3, R3, #8
ADD R3, R3, #8

AND R2, R2, #0

LOOP4
	ADD R3, R3, #0
	BRz DONE4

	ADD R1, R1, #0
	BRn FOUND_ONE4
	BR ITERATE4
	
	FOUND_ONE4
		ADD R2, R2, #1
	
	ITERATE4
	ADD R1, R1, R1
	ADD R3, R3, #-1
BR LOOP4

DONE4

LD R1, R1_backup_4500
LD R3, R3_backup_4500
LD R7, R7_backup_4500

ret

;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xBA00
R1_backup_4500					.BLKW #1
R3_backup_4500					.BLKW #1
R7_backup_4500					.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
;HINT back up 

.orig x4800

ST R3, R3_backup_4800		
ST R4, R4_backup_4800	
ST R7, R7_backup_4800

LD R6, MACHINE_NUM_PTR
JSRR R6

LDI R4, BUSYNESS_ADDR_MACHINE_STATUS

AND R3, R3, #0
ADD R3, R1, #-15		; R3 holds the value of how many times to left-shift

LEFT_SHIFT_LOOP
	ADD R3, R3, #0
	BRz DONE_LEFT_SHIFTING
	
	ADD R4, R4, R4
	ADD R3, R3, #1
BR LEFT_SHIFT_LOOP

DONE_LEFT_SHIFTING

ADD R4, R4, #0
BRn RETURN_ONE5

RETURN_ZERO5
	AND R2, R2, #0
BR DONE5
	
RETURN_ONE5
	AND R2, R2, #0
	ADD R2, R2, #1
BR DONE5

DONE5
	
;HINT Restore

LD R3, R3_backup_4800
LD R4, R4_backup_4800
LD R7, R7_backup_4800

ret

;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS	.Fill xBA00
MACHINE_NUM_PTR					.FILL x5400
R1_backup_4800					.BLKW #1
R3_backup_4800					.BLKW #1
R4_backup_4800					.BLKW #1
R7_backup_4800					.BLKW #1

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R2): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
	; if none are free, make R2 negative
.orig x5100

;HINT back up 

ST R0, R0_backup_5100	
ST R1, R1_backup_5100
ST R3, R3_backup_5100		
ST R4, R4_backup_5100	
ST R5, R5_backup_5100
ST R6, R6_backup_5100	
ST R7, R7_backup_5100

LDI R1, BUSYNESS_ADDR_FIRST_FREE
AND R5, R5, #0
ADD R5, R5, #-1

LD R3, HEX8000
NOT R3, R3
ADD R3, R3, #1

ADD R3, R3, R1
BRz R2_15
BR OUTER_LOOP

R2_15
	AND R2, R2, #0
	ADD R2, R2, #15
BR SKIP

OUTER_LOOP
	LD R3, machine_counter
	ADD R5, R5, #1
	
	RIGHT_SHIFT_LOOP
		ADD R3, R3, #0
		BRnz DONE_RIGHT_SHIFTING
		
;Store the MSB
		ADD R1, R1, #0
		BRzp MSB_IS_ZERO
		BRn MSB_IS_ONE
		
		MSB_IS_ZERO
			ADD R1, R1, R1
		BR HERE
		
		MSB_IS_ONE
			ADD R1, R1, R1
			
			ADD R1, R1, #1
		BR HERE
		
	HERE
	ADD R3, R3, #-1
	BRp RIGHT_SHIFT_LOOP	

	DONE_RIGHT_SHIFTING

AND R7, R7, #0
ADD R7, R7, #-15
ADD R7, R7, R5
BRz NONE_FOUND

ADD R1, R1, #0
BRn FOUND_FIRST
BR OUTER_LOOP

NONE_FOUND
	AND R2, R2, #0
	ADD R2, R2, #-1
BR SKIP

FOUND_FIRST
	AND R2, R2, #0
	ADD R2, R2, R5

SKIP

;HINT Restore
LD R0, R0_backup_5100
LD R1, R1_backup_5100
LD R3, R3_backup_5100
LD R4, R4_backup_5100
LD R5, R5_backup_5100
LD R6, R6_backup_5100
LD R7, R7_backup_5100

ret
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xBA00
machine_counter			.fill #16
DEC32766				.fill #32766
DEC32767				.fill #32767
R0_backup_5100					.BLKW #1
R1_backup_5100					.BLKW #1
R3_backup_5100					.BLKW #1
R4_backup_5100					.BLKW #1
R5_backup_5100					.BLKW #1
R6_backup_5100					.BLKW #1
R7_backup_5100					.BLKW #1
HEX8000							.fill x8000

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x5400

ST R0, R0_backup_5400	
ST R2, R2_backup_5400
ST R3, R3_backup_5400		
ST R4, R4_backup_5400	
ST R5, R5_backup_5400
ST R6, R6_backup_5400	
ST R7, R7_backup_5400

TOP_OF_CODE

LEA R0, prompt
PUTS

; clear the used registers
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R5, R5, #0
AND R6, R6, #0
						
; Set up flags, counters, accumulators as needed

ADD R6, R6, #3

CHECK_FIRST_INPUT
; Get first character, test for '\n', '+', '-', digit/non-digit 	

GETC
OUT

; check if the first input is a newline and if it is, end the program
; is very first character = '\n'? if so, just quit (no message)!
LD R1, ASCIInewline		; Load the newline character
ADD R1, R0, R1
BRz PRINT_ERROR10	

; is it = 0, if so then get then next number and check if that one is a 0 too
AND R1, R1, #0
LD R1, DECNEG48
ADD R1, R0, R1
BRz FIRST_IS_ZERO

; is it = '+'? if so, ignore it, go get digits
AND R1, R1, #0
LD R1, ASCIIplus
ADD R1, R0, R1
BRz	CHECK_NUMBER
				
; is it = '-'? if so, set neg flag, go get digits
AND R1, R1, #0
LD R1, ASCIIminus
ADD R1, R0, R1
BRz	PRINT_ERROR10

BR SKIP_GETTING_NUMBER

FIRST_IS_ZERO		; check if the next digit is a 0 too
	GETC
	OUT
	LD R1, DECNEG48
	ADD R1, R0, R1
	BRz FIRST_IS_ZERO
	
	LD R1, ASCIInewline		; Load the newline character
	ADD R1, R0, R1
	BRz END_SUBROUTINE
	
BR SKIP_GETTING_NUMBER

CHECK_NUMBER

	GETC
	
	LD R1, ASCIInewline
	ADD R1, R0, R1
	BRz	END_SUBROUTINE
	
	OUT

	SKIP_GETTING_NUMBER
	
	; is it < '0'? if so, it is not a digit	- o/p error message, start over
	AND R1, R1, #0
	LD R1, DECNEG48
	ADD R1, R0, R1
	BRn	PRINT_ERROR10				; incorrect input, restart

	; is it > '9'? if so, it is not a digit	- o/p error message, start over
	AND R1, R1, #0
	LD R1, DECNEG57
	ADD R1, R0, R1
	BRp	PRINT_ERROR10				; incorrect input, restart

BR DO_CONVERSION

SINGLE_DIGIT_ONLY
	ADD R4, R4, #1				; R4 = 1 means that they should only be 1 digit

DO_CONVERSION
			
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

PRINT_ERROR9
	LEA R0, Error_msg_2
	PUTS
	BR TOP_OF_CODE

PRINT_ERROR10
	LEA R0, Error_msg_3
	PUTS
	BR TOP_OF_CODE

END_GET_DIGITS
	AND R6, R6, #0
	ADD R6, R6, #-15
	ADD R6, R6, R3
	BRp PRINT_ERROR9

END_SUBROUTINE

	ADD R5, R3, #-15
	BRp PRINT_ERROR9

	OUT

	; clear Register 2
	AND R1, R1, #0
	; load the final answer into Register 1 from Register 3
	ADD R1, R3, R1

LD R0, R0_backup_5400
LD R2, R2_backup_5400
LD R3, R3_backup_5400
LD R4, R4_backup_5400
LD R5, R5_backup_5400
LD R6, R6_backup_5400
LD R7, R7_backup_5400

ret

;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "\n\nERROR INVALID INPUT\n"
Error_msg_3 .STRINGZ "\nERROR INVALID INPUT\n"
inputCounter					.FILL #1
ASCIIplus						.FILL #-43
ASCIIminus						.FILL #-45
ASCIInewline					.FILL #-10
newlineCharacter				.FILL #10
DECNEG48						.FILL #-48
DECNEG57						.FILL #-57
DEC48							.FILL #48
DECNEG49						.FILL #-49
DECNEG53						.FILL #-53
R0_backup_5400					.BLKW #1
R2_backup_5400					.BLKW #1
R3_backup_5400					.BLKW #1
R4_backup_5400					.BLKW #1
R5_backup_5400					.BLKW #1
R6_backup_5400					.BLKW #1
R7_backup_5400					.BLKW #1
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,15}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
; WITHOUT leading 0's, a leading sign, or a trailing newline.
;      Note: that number is guaranteed to be in the range {#0, #15}, 
;            i.e. either a single digit, or '1' followed by a single digit.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------

.orig x5700

ST R0, R0_backup_5700	
ST R1, R1_backup_5700
ST R2, R2_backup_5700		
ST R3, R3_backup_5700	
ST R7, R7_backup_5700

ADD R2, R1, #-10
BRn SINGLE_DIGIT

; double digit
LD R0, DECIMAL49
OUT

LD R3, DECIMAL48
AND R0, R0, #0
ADD R0, R2, R3
OUT
BR DONE_PRINTING

SINGLE_DIGIT
	LD R3, DECIMAL48
	AND R0, R0, #0
	ADD R0, R1, R3
	OUT
	
DONE_PRINTING

LD R0, R0_backup_5700
LD R1, R1_backup_5700
LD R2, R2_backup_5700
LD R3, R3_backup_5700
LD R7, R7_backup_5700

ret
	
;--------------------------------
;Data for subroutine print number
;--------------------------------
DECIMAL48				.fill #48
DECIMAL49				.fill #49
R0_backup_5700					.BLKW #1
R1_backup_5700					.BLKW #1
R2_backup_5700					.BLKW #1
R3_backup_5700					.BLKW #1
R7_backup_5700					.BLKW #1


.ORIG x6A00
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xBA00			; Remote data
BUSYNESS .FILL x8000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
