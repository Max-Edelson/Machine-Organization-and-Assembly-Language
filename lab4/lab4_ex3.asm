;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 4, ex 3
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

LD R4, DATA_PTR
LDR R2, R4, #6

HALT

;local data
DATA_PTR .FILL x4000
counter .FILL #10

.orig x4000
array .BLKW 10

.END
