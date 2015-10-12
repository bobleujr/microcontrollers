;A led is connected to port P1.0 and turned on and another led is connected to port P1.1 and turned off for 1 second.
;After 1 second, the led connected to port P1.0 is turned off and the led connected to port P1.1 is turned on for 750 miliseconds.
;Redo the cycle infinitely. hint: nested loops for delay
org 0000h
ljmp main

org 0030h
;This function needs 250 ms to reach its end (250ms delay)
;This function was based on the same logic used in exercise 2
ms250:
increment:
	mov r3, #0				;Set 0 to register 3
resetR2:
	mov r2, #0				;Set 0 to register 2
resetR1:
	mov r1, #0				;Set 0 to register 1
	
;As the frequency of 8051 is 12MHz and 1 machine cycle is 12 clock cycles (1 machine cycle is equivalent to 1 instruction)
;1 machine cycle needs 1 us, thus 1000 instructions needs 1 ms.
;Therefore, as each loop needs 3 instruction (1 from inc and 2 from cjne) we calculate the following expression:
; 	(((((R1 * 3) + 3) * R2) + 3) * R3) = 250000 [1]
;    where R1 stands for number of iterations in register 1 and so on for register 2 and 3
;Using R1 = 250, R2 = 166 and R3 = 2 in [1] we obtain 250002 which is pretty near 250000.
loop1:
	inc r1					;Increment register 1 by 1
	cjne r1, #250, loop1	;If register 1 is not equal to 250 small jump to loop1 label
	inc r2					;Increment register 2 by 1
	cjne r2, #166, resetR1	;If register 2 is not equal to 166 small jump to resetR1 label
	inc r3					;Increment register 3 by 1
	cjne r3, #2, resetR2	;If register 3 is not equal to 2 small jump to resetR2 label
	ret						;Update PC to stored address before ms250 was called
	
main:
	mov r4, #0				;Set 0 to register 4
	mov	p1, #00000010b		;Set p1 to 00000010
cycle1:
	acall ms250				;Call ms250 function and store next address
	inc r4					;Increment register 4 by 1
	cjne r4, #4, cycle1 	;if register 4 is not equal to 4 small jump to cycle1 (4 times means 1 second)
	mov r4, #0				;Reset register 4 to 0
	mov	p1, #00000001b		;Set p1 to 00000001
cycle2:
	acall ms250				;Call ms250 function and store next address
	inc r4					;Increment register 4 by 1
	cjne r4, #3, cycle2		;if register 4 is not equal to 3 small jump to cycle1 (3 times means 750 miliseconds)
	mov r4, #0				;Reset register 4 to 0
	mov	p1, #00000010b		;Set p1 to 00000010
	sjmp cycle1				;Redo cycle
		
	
	


