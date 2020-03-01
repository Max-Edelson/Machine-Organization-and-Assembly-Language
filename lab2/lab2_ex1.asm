;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 2. ex 1
; Lab section: 025
; TA: Jang-Shing Lin
;=================================================

.ORIG x3000

LD R3, DEC_65
LD R4, HEX_41

HALT

;local data

DEC_65 .FILL #65
HEX_41 .FILL x41

;x41 = dec 65
