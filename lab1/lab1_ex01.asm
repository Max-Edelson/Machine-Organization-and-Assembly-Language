;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 1, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
.orig x3000
	;------------
	;instructions
	;------------
	AND R1, R1, x0		; R1 <- 0
	LD R2, DEC_12		; R2 <- 12
	LD R3, DEC_6		; R3 <- 6
	
	DO_WHILE_LOOP
		ADD R1, R1, R2	; R1 <- R1 + R2
		ADD R3, R3, #-1 ; R3 <- R3 - 1
		BRp DO_WHILE_LOOP	; if (R3 > 0): goto DO_WHILE_LOOP
	;END_DO_WHILE_LOOP
	
	HALT	; halt the program
	
	;----------
	;local data
	;----------
	DEC_12 .FILL #12	; put 12 in memory here
	DEC_6  .FILL #6		; put 6 in memory here
	
.end
	
	
	
	
	
