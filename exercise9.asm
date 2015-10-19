;
 ;Authors: Andre, Cesar, Daniel, Paulo
 ;When a button placed in p3.2 is pressed the port 1 is transmitted via serial.
 ;Any value send to 8051 by serial is put in port 1
;
org 000h
ljmp main
org 03h ;int0
call int0					;call function handler
reti                        ;return and reset flags
org 23h ;serial
call serial					;call function handler
reti                        ;return and reset flags
org 0030h
;Function to handle timer interruption 0
int0:
	call printPort			;Call function to send "Port 1.'r1' - "
	inc r1					;Increment port address
	call printValue			;Call function to send "On" or "Off"
	mov A, #'\n'			;send new line to be transmitted
	call transmition
	cjne r1, #34h, int0		;If register 1 is not equal to 34, loop int0
	clr ie0					;Clear extern interruption 0 flag
	mov r1, #30h			;reset register 1 to 30h
	ret                     ;return
;Function to handle serial trasmition
serial:
	jnb ri, $				;While serial port is reading, keep it in same address
	clr ri					;Clear ri
	mov A, sbuf				;Move which has been sent to A	
   	cjne A, #30h, p11		;If A is not 30h, small jump to p11
	jnb p1.0, c10			;If p1.0's value is not 0, small jump to c10
	setb p1.0				;Otherwise, turn off led in p1.0
	sjmp exit				;Small jump to exit
c10:
	clr p1.0				;Turn on led in p1.0
	sjmp exit				;Small jump to exit
p11:
   	cjne A, #31h, p12		;If A is not 31h, small jump to p12
	jnb p1.1, c11           ;If p1.1's value is not 0, small jump to c11
	setb p1.1               ;Otherwise, turn off led in p1.0
	sjmp exit               ;Small jump to exit
c11:                        
	clr p1.1                ;Turn on led in p1.1
	sjmp exit               ;Small jump to exit
p12:
   	cjne A, #32h, p13		;If A is not 32h, small jump to p13
	jnb p1.2, c12           ;If p1.2's value is not 0, small jump to c12
	setb p1.2               ;Otherwise, turn off led in p1.0
	sjmp exit               ;Small jump to exit
c12:                        
	clr p1.2                ;Turn on led in p1.2
	sjmp exit               ;Small jump to exit
p13:
	jnb p1.3, c13			;If p1.3's value is not 0, small jump to c13
	clr p1.3                ;Otherwise, turn off led in p1.0
	sjmp exit               ;Small jump to exit
c13:                        
	setb p1.3               ;Turn on led in p1.3
exit:                       
	ret						;return
;Function to transmit a data
transmition:
	mov sbuf, A				;Move A to sbuf
	jnb ti, $				;While sbuf was not entirely transmitted, keep it in same address
	clr ti					;Clear ti
	ret						;return
;Function to send 'Port 1.r1 - ' by serial
printPort:
	mov A, #'P'
	call transmition
	mov A, #'o'
	call transmition
	mov A, #'r'
	call transmition
	mov A, #'t'
	call transmition
	mov A, #' '
	call transmition
	mov A, #'1'
	call transmition
	mov A, #'.'
	call transmition
	mov A, r1
	call transmition
	mov A, #'-'
	call transmition
	mov A, #' '
	call transmition
	ret
;Function to send 'On' or 'Off' depending on port 1.r1's value 
printValue:
	mov A,r1				;Move r1 to A
	add A, 60h				;Add A to address 60h
	cjne A, #0b, off		;if A's value is not 0, small jump to off
	mov A, #'O'				;Send "On" to be sent by serial
	call transmition
	mov A, #'n'
	call transmition
	ret						;return
off:
	mov A, #'O'				;Send "Off" to be sent by serial
	call transmition
	mov A, #'f'
	call transmition
	mov A, #'f'
	call transmition
	ret						;return 
main:
	;Set most significant bit (enable all interruptions), least significant bit (enable extern interrupt 0)
	;and fourth most significant bit (enable serial)
	mov ie, #10010001b		
	mov tmod, #20h			;Set timer 1 as counter
	mov th1, #-6			;Set baud rate to 4800
	mov scon, #50h			;Set serial type 1 and enable receive
	mov r1, #30h			;Set register 1 to 30h 
	setb tr1				;Start timer 1
	setb p3.2               ;Set interrupt button 0
	setb it0				;Turn interruption 0 by falling edge
	sjmp $                  ;idle infinitely
