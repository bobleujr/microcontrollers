;
 ;Authors: Andre, Cesar, Daniel, Paulo
 ;When an external interrupt 0 is set by a button placed in p3.2
 ;turn on a led placed in p1.0 for 1 second, then turn it off.
 ;After this cycle, the user must be able to fire another interruption
 ;and again turn on the led.
;
org 0000h
ljmp main
org 0003h ;int0
call int0					;call function handler
reti						;return and reset flags
org 0030h
;Function to handle external interruption 0
int0:
	mov r4, #0				;Set register 4 to 0
	clr p1.0 				;Turn on led on p1.0
loopInt:
	inc r4					;Increment register 4 by 1
	call ms250				;Call ms250 function and store next address
	cjne r4, #4, loopInt	;If register 4 is not equal to 4 small jump to loopInt (4 times means 1 second)
	setb p1.0				;Turn off led on p1.0
	clr ie0					;Clear extern interruption flag
	ret						;return
;Function to delay 250 miliseconds
ms250:
	mov r3, #0
resetR2:
	mov r2, #0
resetR1:
	mov r1, #0
loop:
	inc r1
	cjne r1, #250, loop
	inc r2
	cjne r2, #166, resetR1
	inc r3
	cjne r3, #2, resetR2
	ret
main:
	;Set most significant bit (enable all interruptions) and least significant bit (enable extern interrupt 0)
	mov ie,#10000001b		
	setb p1.0				;Turn off led on p1.0
	setb p3.2				;Set interrupt button
	setb it0				;Turn interruption by falling edge
	sjmp $					;idle infinitely
