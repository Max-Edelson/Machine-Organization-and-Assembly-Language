;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 4, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

.ORIG x3000

LD R2, DATA_PTR
LD R3, counter
AND R1, R1, #0
;ADD R1, R1, #-1

WHILE_LOOP
	STR R1, R2, #0
	
	ADD R2, R2, #1
	ADD R1, R1, #1
	ADD R3, R3, #-1
	
	BRp WHILE_LOOP
;END_WHILE_LOOP

ADD R4, R4, #0
LD R4, DATA_PTR

;ADD R4, R4, #6
LDR R2, R4, #6

HALT

;local data

DATA_PTR .FILL x4000
counter .FILL #10
DEC_SIX .FILL #6

.orig x4000
array .BLKW 10

.END
