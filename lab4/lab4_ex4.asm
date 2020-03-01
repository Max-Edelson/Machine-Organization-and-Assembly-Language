;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 4, ex 4
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================
;instructions

.ORIG x3000

AND R3, R3, #0
ADD R3, R3, #1
AND R2, R2, #0
LD R2, counter
AND R4, R4, #0
LD R4, DATA_PTR

WHILE_LOOP

	STR R3, R4, #0
	
	ADD R4, R4, #1
	ADD R3, R3, R3
	ADD R2, R2, #-1
	BRp WHILE_LOOP
	
;AND R4, R4, #0
LD R4, DATA_PTR
LD R2, counter
	
WHILE_LOOO
	LDR R0, R4, #0
	OUT
	
	LD R0, newline
	OUT
	
	ADD R4, R4, #1
	ADD R2, R2, #-1
	
	BRp WHILE_LOOO

HALT

;local data
DATA_PTR .FILL x4000
counter .FILL #10
newline .FILL #10

.orig x4000
array .BLKW 10

.END
