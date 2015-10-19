;
 ;Authors: Andre, Cesar, Daniel, Paulo
 ;The sequence of leds to be turned on will be from 0 to 3 (4 leds from left to right),
 ;the next led of this sequence will be in 0 and restart the cycle. Using timer the delay
 ;for each switch is 100 ms, but if a character 'V' is received by serial, then the delay 
 ;must be increased by 100 ms. When the sum reach 500 ms the next delay to be used must 
 ;be 100 ms and restart the cycle. If a character 'D' is received by serial, then the
 ;direction must change.
;
org 0000h
ljmp main
org 23h ;serial
call serial						;call function handler
reti                        	;return and reset flags
org 000bh ;timer0
call timer0						;call function handler
reti               				;return and reset flags
org 0030h

serial:
	jnb ri, $					;While serial port is reading, keep it in same address
	clr ri						;Clear ri
	mov A, sbuf					;Move sbuf to A
	cjne A, #'D', velocity		;If A is not 'D', small jump to velocity
direction:
	cjne r3, #0, subtract		;If r3 is not zero, small jump to subtract
	mov r3, #1					;Set r3 to 1
	clr ie1						;Clear extern interruption 1 flag
	ret							;return
subtract:
	mov r3, #0					;Set r3 to 0
	clr ie1						;Clear extern interruption 1 flag
	ret							;return
	
;Function to handle character 'V'
velocity:
	mov A, #2					;Set A to 2
	add A, r2					;Add A to r2 and store result in A (A = A+r2)
	cjne A, #12, sum			;If A is not equal to 12 small jump to sum
	mov r2, #2					;Reset register 2
	clr ie0						;Clear extern interruption 0 flag
	ret             	        ;return
sum:		
	mov r2, A					;Move back A to r2 
	clr ie0						;Clear extern interruption 0 flag
	ret 	                    ;return
;Function to handle timer interruption 0
timer0:
	inc r1						;Increment register 1 by 1
	mov A, r2					;Move r2 to A
	subb A, r1					;Subtract r1 to A and store result in A (A = A-r1) which basically is A = r2 - r1
	cjne A, #0, exit			;If result of subtraciton is not equal to 0, in other words r2 == r1, small jump to exit
	mov r1, #0					;Reset register 1
	mov A, p1					;Move port 1 to A
	cjne r3, #1, left
	cjne A, #11111110b, rotate	;If led 4 is not turned on, small jump to rotate
	setb p1.0					;Turn off led in p1.4
	clr p1.3					;Turn on led in p1.3
	sjmp exit					;Small jump to exit
left:
	cjne A, #11110111b, rotate	;If led 0 is not turned on, small jump to rotate
	setb p1.3					;Turn off led in p1.3
	clr p1.0					;Turn on led in p1.0
	sjmp exit                   ;Small jump to exit
rotate:
	cjne r3, #0, right			;If r3 is not 0, rotate port to right, otherwise to left
	mov A, p1					;Move port 1 to A
	rl A						;Rotate A to left
	mov p1, A					;Move back A to p1
	sjmp exit					;Small jump to exit
right:
	mov A, p1					;Move port 1 to A
	rr A						;Rotate A to right
	mov p1, A					;Move back A to p1
exit:
	clr tf0						;Clear interruption timer flag
	clr tr0                     ;Stop timer (needs to be reseted)
	mov th0, #00111100b         
	mov tl0, #10101111b         ;High and Low values make the number 500000 (which is used to count 50 ms)
	setb tr0                    ;Restart timer 0	
	ret                         ;Return
main:
	;Set most significant bit (enable all interruptions), fourth most significant bit (serial interrupt)
	;and second least significant bit (enable timer interrupt 0)
	mov ie, #10010100b
	mov tmod, #21h				;Set timer 1 as counter and set timer 0 in type 1 (16-bit)
	mov scon, #50h				;Set serial type 1 and enable receive
	mov th0, #00111100b			
	mov tl0, #10101111b         ;High and Low values make the number 500000 (which is used to count 50 ms)
	mov th1, #-6				;Set baud rate to 4800
	mov r1, #0                  ;Set 0 to register 1
	mov r2, #2                  ;Set 2 to register 2
	mov r3, #0					;If this register is 0, rotate left, if not, rotate right
	setb tr0                    ;Start timer 0                
	setb tr1                    ;Start timer 0                
	clr p1.0    				;Turn on led in p1.0
	sjmp $                      ;idle infinitely
