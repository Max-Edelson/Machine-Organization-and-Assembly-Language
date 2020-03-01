;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

;instructions
.orig x3000

LEA R2, DATA_PTR
LD R3, DEC65

STR R3, R2, #0

ADD R2, R2, #1

LD R3, HEX41
STR R3, R2, #0

HALT

;local data

;DATA_PTR	.FILL #0
DATA_PTR	.BLKW #2
DEC65		.FILL #65
HEX41		.FILL x41

;DEC_65_PTR .FILL x4000
;HEX_41_PTR .FILL x4001

;remote data
;.orig x4000
;NEW_DEC_65 .FILL #65
;NEW_HEX_41 .FILL x41

.END
