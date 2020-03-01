;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 025
; TA: Jang-Shing  Enoch Lin
; 
;=================================================
;Hello World Program
.ORIG x3000

;instructions

	LEA R0, MSG_TO_PRINT	;R0 <- The location of the label: MSG_TO_PRINT
	PUTS	;prints string defined at MSG_TO_PRINT
	
	HALT	;terminate the program
	
;local data

	MSG_TO_PRINT .STRINGZ "Hello World!!!\n"
