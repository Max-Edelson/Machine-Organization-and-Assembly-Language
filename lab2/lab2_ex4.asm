;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 2. ex 3
; Lab section: 025
; TA: Jang-Shing Lin
;=================================================

;instructions

.orig x3000

LD R0, PTR_61
LD R1, PTR_1A

DO_WHILE_LOOP
	OUT
	ADD R0, R0, #1
	ADD R1, R1, #-1
	BRp DO_WHILE_LOOP
END_DO_WHILE


HALT

PTR_61 .FILL x61
PTR_1A .FILL x1A

.END
