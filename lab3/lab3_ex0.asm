;=================================================
; Name: Maxim Edelson
; Email: medel003@ucr.edu
; 
; Lab: lab 3, ex 1
; Lab section: 025
; TA: Jang-Shing Lin
; 
;=================================================

.ORIG x3000

GETC
OUT
ST R0, character

HALT

;local data
character .FILL #0

.END
