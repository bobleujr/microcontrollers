;When a button placed in p3.2 is pressed the port 1 is transmitted via serial.
;Any value send to 8051 by serial is put in port 1
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
	setb ti					;Set serial to transmition mode
	clr ie0					;Clear extern interruption 0 flag
	reti                    ;return
;Function to handle serial trasmition
serial:
jnb ri, transmition			;If ri (reception) is equal to 0, small jump to transmition
reception:
	clr ri					;Clear ri
	mov p1, sbuf			;Move data from buffer to port 1
	ret						;return
transmition:
	clr ti					;Clear ti
	mov sbuf, p1			;Move port 1 to buffer
	ret						;return
main:
	;Set most significant bit (enable all interruptions), least significant bit (enable extern interrupt 0)
	;and fourth most significant bit (enable serial)
	mov ie, #10010001b
	;Set pair 01 in the most significant bits to use type 1 (8-bits UART)
	;Set Fourth most significant bit (enable receive)
	mov scon, #01010000b
	;Set pair 10 in the third most significant bit (timer 1 as counter)
	mov tmod, #00100000b
	mov th1, #11111101b		
	mov tl1, #11111101b		;High and Low values make the number 650021 (which makes baude rate 9600)
	setb tr1				;Start timer 1
	setb p3.2               ;Set interrupt button 0
	sjmp $                  ;idle infinitely