;Every time a button place in p3.2 is pressed the led is turned off
;and the position in its left is turned on. 
; 00000001 -> [button 0] -> 00000010 -> [button 0] -> 00000100
;Therefore, if a button placed in p3.3 is pressed the led is also 
;turned off and now the position in its right is turned on.
; 00000100 -> [button 1] -> 00000010 -> [button 1] -> 00000001
org 0000h
ljmp main
org 0003h ;int0
call int0			;call function handler
reti     			;return and reset flags
org 0013h ;int1
call int1			;call function handler
reti        		;return and reset flags
org 0030h
;Function to handle external interruption 0
int0:
	mov A, p1		;Move port 1 to A
	rl A			;Rotate A to left 
    mov p1, A		;Move back A to port 1
	clr ie0			;Clear extern interruption 0 flag
	ret				;return
;Function to handle external interruption 1
int1:
	mov A, p1		;Move port 1 to A
	rr A            ;Rotate A to right 
    mov p1, A       ;Move back A to port 1
	clr ie1         ;Clear extern interruption 1 flag
	ret             ;return
main:
	;Set most significant bit (enable all interruptions), least significant bit (enable extern interrupt 0) 
	;and third least significant bit (enable extern interrupt 1)
	mov ie,#10000101b
	clr p1.0			;Turn on led on p1.0
	setb p3.2           ;Set interrupt button 0
	setb p3.3           ;Set interrupt button 1
	sjmp $				;idle infinitely
