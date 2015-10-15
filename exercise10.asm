;The sequence of leds to be turned on will be from 0 to 3 (4 leds from left to right),
;the next led of this sequence will be in 0 and restart the cycle. Using timer the delay
;for each switch is 100 ms, but if a character 'V' is received by serial, then the delay 
;must be increased by 100 ms. When the sum reach 500 ms the next delay to be used must 
;be 100 ms and restart the cycle.
org 0000h
ljmp main
org 0023h ;serial
call serial						;call function handler
reti               				;return and reset flags
org 0030h
;Function to handle serial interruption
serial:
	jnb ri, transmition			;If ri (reception) is equal to 0, small jump to transmition
reception:
	clr ri						;Clear ri
	mov A, sbuf					;Move data from buffer to A
	cjne A, #'D', velocity		;If not equal to 'D', call velocity
	call direction				;Otherwise call direction
	ret							;return
transmition:
	clr ti						;Clear ti
	ret							;return
velocity:
	mov A, #2					;Set A to 2
	add A, r2					;Add A to r2 and store result in A (A = A+r2)
	cjne r2, #10, sum			;If register 2 is not equal to 10 small jump to sum
	mov r2, #2					;Reset register 2
	clr ie0						;Clear extern interruption 0 flag
	ret             	        ;return
sum:		
	mov r2, A					;Move back A to r2 
	clr ie0						;Clear extern interruption 0 flag
	ret 	                    ;return
direction:
	inc r1						;Increment register 1 by 1
	mov A, r2					;Move r2 to A
	subb A, r1					;Subtract r1 to A and store result in A (A = A-r1) which basically is A = r2 - r1
	cjne A, #0, exit			;If result of subtraciton is not equal to 0, in other words r2 == r1, small jump to exit
	mov r1, #0					;Reset register 1
	mov A, p1					;Move port 1 to A
	cjne A, #11110111b, rotate	;If led 4 is not turned on, small jump to rotate
	setb p1.3					;Turn off led in p1.4
	clr p1.7					;Turn on led in p1.7 (last position because the next operation is rotation to right so the turned on led will be in p1.0)
rotate:
	mov A, p1					;Move port 1 to A
	rl A						;Rotate A to left
	mov p1, A					;Move back A to p1
exit:
	ret                         ;Return
main:
	;Set most significant bit (enable all interruptions), least significant bit (enable extern interrupt 0)
	;and fourth most significant bit (enable serial)
	mov ie, #10010000b
;Set pair 01 in the most significant bits to use type 1 (8-bits UART)
	;Set Fourth most significant bit (enable receive)
	mov scon, #01010000b
	;Set pair 10 in the third most significant bit (timer 1 as counter)
	mov tmod, #00100000b
	mov th1, #11111101b		
	mov tl1, #11111101b			;High and Low values make the number 650021 (which makes baude rate 9600)
	setb tr1					;Start timer 1
	mov r1, #0                  ;Set 0 to register 1
	mov r2, #2                  ;Set 2 to register 2
	setb tr0                    ;Start timer 0                
	clr p1.0    				;Turn on led in p1.0
	sjmp $                      ;idle infinitely
