;
 ;Authors: Andre, Cesar, Daniel, Paulo
 ;Same logic as exercise 3, but now using time to delay 1 second and 750 miliseconds instead
 ;of nested increments. Note that the timer overflows happens each 50 ms
 ;so we used a counter to increment 20 times until something really happens,
 ;at least for the human.
;
org 0000h
ljmp main
org 000bh ;timer0
call timer0			;call function handler
reti        		;return and reset flags
org 0030h
;Function to handle timer interruption 0
timer0:
	inc r1					;Increment register 1 by 1
	mov A, r1				;Move r1 to A
	subb A, r2				;Subtract r2 to A and store in A (A = A - r2)
	cjne A, 0, exit			;If A is not equal to 0 small jump to exit lable
	mov r1, #0				;Reset register 1
	mov A, p1				;Move port 1 to A
	cjne r2, #20, right		;If r2 is not equal to 20, small jump to right
	rl A					;Rotate A to the right
	mov r2, #15				;Set r2 to 15 (750 ms)
	sjmp moveback
right:
	rr A					;Rotate A to the right
	mov r2, #20				;Set r2 to 15 (1 s)
moveback:
	mov p1, A				;Move back A to port 1
exit:
	clr tf0					;Clear interruption timer flag
	clr tr0					;Stop timer (needs to be reseted)
	mov th0, #00111100b		
	mov tl0, #10101111b		;High and Low values make the number 500000 (which is used to count 50 ms)
	setb tr0				;Restart timer 0	
	ret						;Return
main:
	;Set most significant bit (enable all interruptions), and second least significant bit (enable timer interrupt 0)
	mov ie, #10000010b		
	mov tmod, #00000001b	;Set timer 0 in type 1 (16-bit)
	mov th0, #00111100b		
	mov tl0, #10101111b		;High and Low values make the number 500000 (which is used to count 50 ms)
	mov r1, #0				;Set 0 to register 1
	mov r2, #20
	setb tr0				;Start timer 0
	clr p1.0				;Turn on led in p1.0
	sjmp $					;idle infinitely
