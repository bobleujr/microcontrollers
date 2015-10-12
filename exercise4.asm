;A led is connected to each bit in Port 1 and after 250ms a led is
;turned on from left to right. for example if in state 0 we have this
;configuration 00000000 after 250ms we have 00000001 and after 250ms 
;we have 00000010 and so on. This must work infinitely.
org 0000h
ljmp main

org 0030h
;Function to delay 250 miliseconds
ms250:
	mov r3, #0
resetR2:
	mov r2, #0
resetR1:
	mov r1, #0
loop1:
	inc r1
	cjne r1, #250, loop1
	inc r2
	cjne r2, #166, resetR1
	inc r3
	cjne r3, #2, resetR2
	ret
main:
	setb C				;Set Carry-on flag to 1
	mov	A, #00000000b	;Move 00000000 to A
	mov p1, A			;Move A to port P1
cycle1:
	mov B, psw			;Move psw state to B
	acall ms250			;Call delay function 
	mov psw, B			;Move back B to psw state
	rlc A				;Rotate A to left with carry-on
	mov p1, A			;Move A to port P1
	sjmp cycle1			;Redo cycle infinitely