;The goal is to increment a register to 100 and then decrement it until 0, redo the cycle infinitely
org 0000h
ljmp main
org 0030h			
main:
	mov r1, #0    				;Set 0 to register 1
increment:
	inc r1						;Increment register 1 by 1
	cjne r1, #100, incremento	;If register 1 is not equal to 100 small jump to increment lable
decrement:	
	dec r1						;Decrement register 1 by 1
	cjne r1, #0, decremento		;If register 1 is not equal to 0 small jump to decrement lable
	sjmp incremento 			;Small jump to increment label to redo the cycle