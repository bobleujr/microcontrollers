;Use the same logic of exercise 1, but now you should increment from 0 to 4000000. Remember the 8051 architecture suports
;only 8-bits operation and this exercise needs a 32-bits number. hint: nested loops
org 0000h
ljmp main

org 0030h
increment:
	mov r3, #0				;Set register 3 to 0
resetR2:					
	mov r2, #0				;Set register 2 to 0
resetR1:	
	mov r1, #0				;Set register 1 to 0
loop1:
	inc r1					;Increment register 1 by 1
	cjne r1, #250, loop1	;If register 1 is not equal to 250 small jupmp to loop1 label
	inc r2					;Increment register 2 by 1
	cjne r2, #250, resetR1	;If register 2 is not equal to 250 small jupmp to reset1 label
	inc r3					;Increment register 3 by 1
	cjne r3, #64, limpaR2	;If register 3 is not equal to 64 small jupmp to reset2 label
decrement:
setR2:
	mov r2, #250			;Set register 2 to 250
setR1:
	mov r1, #250			;Set register 1 to 250
loop2:
	dec r1					;Decrement register 1 by 1
	cjne r1, #0, loop2		;If register 1 is not equal to 0 small jupmp to loop2 label
	dec r2					;Decrement register 2 by 1
	cjne r2, #0, setR1		;If register 2 is not equal to 0 small jupmp to setR1 label
	dec r3					;Decrement register 3 by 1
	cjne r3, #0, setR2		;If register 3 is not equal to 0 small jupmp to setR2 label

	sjmp increment			;Small jump to increment label to redo the cycle
