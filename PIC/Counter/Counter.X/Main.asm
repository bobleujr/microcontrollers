; PIC16F877A Configuration Bit Settings

; ASM source line config statements

#include "p16F877A.inc"

; CONFIG
; __config 0xFF7A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    ;Variables Definition
    cblock 0x20
	counter		;0x20 - Master Counter (From 0 to 255)
	counter1	;0x21 - Most significant counter (hundreds)
	counter2	;0x22 - Middle counter (tens)
	counter3	;0x23 - Least significant counter (units)
	w_temp		;0x24 - temporary W
	status_temp	;0x25 - temporary STATUS
    endc

    ;Reset Vector
    org     0x0000	    
    goto    SETUP
    
    ;Interruption Vector
    org     0x0004  
    
    ;Store context
    movwf w_temp	;Store W in w_temp
    swapf STATUS,W	  
    movwf status_temp	;Store Status in status_temp

    BTFSC INTCON, INTF	
    call INT_INT	;External interrupt
    BTFSC INTCON, RBIF
    call INT_RB		;State change interrupt

    ;Restore context
    swapf status_temp,W
    movwf STATUS	;Restore States
    swapf w_temp, F
    swapf w_temp, W	;Restore W
    retfie                    
;Every time a button placed in RB0 is pressed, count   
INT_INT
    call INCREMENT
    BCF	INTCON, INTF	
    return
INT_RB
    ;Read PORTB
    ;Every time a button placed in RB4 is pressed, increment
    ;BTFSC PORTB.4
    ;call INCREMENT
    ;Every time a button placed in RB5 is pressed, decrement
    ;BTFSC PORTB.5
    ;call DECREMENT
    ;Every time a button placed in RB6 is pressed, reset
    ;BTFSC PORTB.5
    ;call CLEAR
    BCF	INTCON, RBIF
    return

DECREMENT
    DECF    counter, F	    ;Decrement master counter until 0
    BTFSS   STATUS, Z	    ;If master counter not reaches 0, skip next address
    goto    CLEAR	    ;Clear all counters
    DECF    counter3, F	    ;Decrement least significant counter until 0
    MOVLW   D'255'	    
    SUBWF   counter3, W	    
    BTFSS   STATUS, Z	    ;If counter3 is equal to 255 skip next address
    return		    ;Otherwise, return
    MOVLW   D'9'
    SUBWF   counter3, W	    ;Set counter3 to 9
    DECF    counter2, F	    ;Decrement middle counter until 10
    MOVLW   D'255'	    
    SUBWF   counter2, W	    
    BTFSS   STATUS, Z	    ;If counter2 is equal to 255 skip next address
    return		    ;Otherwise, return
    MOVLW   D'9'
    SUBWF   counter2, W	    ;Set counter2 to 9
    DECF    counter1, F	    ;Decrement most significant counter until 0
    return		    ;return
INCREMENT
    INCF    counter, F	    ;Increment master counter until 255
    BTFSS   STATUS, Z	    ;If caused overflow in master counter
    goto    CLEAR	    ;Clear all counters
    INCF    counter3, F	    ;Increment least significant counter until 10
    MOVLW   D'10'	    
    SUBWF   counter3, W	    
    BTFSS   STATUS, Z	    ;If counter3 is equal to 10 skip next address
    return		    ;Otherwise, return
    CLRF    counter3	    ;Reset counter3
    INCF    counter2, F	    ;Increment middle counter until 10
    MOVLW   D'10'	    
    SUBWF   counter2, W	    
    BTFSS   STATUS, Z	    ;If counter2 is equal to 10 skip next address
    return		    ;Otherwise, return
    CLRF    counter2	    ;Reset counter2
    INCF    counter1, F	    ;Increment most significant counter
    return		    ;return
CLEAR
    CLRF counter	    ;Reset all counters
    CLRF counter1	    
    CLRF counter2
    CLRF counter3
    return		    ;return
    
SETUP    
    BANKSEL INTCON
    BSF INTCON, GIE
    BSF INTCON, INTE
    BSF INTCON, RBIE
    CLRF counter
    CLRF counter1
    CLRF counter2
    CLRF counter3
   
MAIN
    goto $
    end