;
 ;Authors: Andre, Cesar, Daniel, Paulo
 ;A led is connected to each bit in Port 1 and after 250ms a led is
 ;turned on from left to right. for example if in state 0 we have this
 ;configuration 00000001 after 250ms we have 00000010 and after 250ms 
 ;we have 00000100 and so on. This must work infinitely.
;
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
	clr p1.0			;Turn on led connected in port 1.0
cycle1:
	call ms250			;Call delay function 
	mov A, p1			;Move port 1 to A
	rl A				;Rotate A to left
	mov p1, A			;Move back A to port P1
	sjmp cycle1			;Redo cycle infinitely
