; PIC16F877A Configuration Bit Settings
; ASM source line config statements

#include "p16F877A.inc"

; CONFIG
; __config 0xFF7A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_ON & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

    ;Variables Definition
    cblock 0x20
	counter		    ;0x20 - Master Counter (From 0 to 255)
	counter1	    ;0x21 - Most significant counter (hundreds)
	counter2	    ;0x22 - Middle counter (tens)
	counter3	    ;0x23 - Least significant counter (units)
	w_temp		    ;0x24 - temporary W
	status_temp	    ;0x25 - temporary STATUS
    endc

    ;Reset Vector
    org     0x0000	    
    goto    SETUP
    
    ;Interruption Vector
    org     0x0004  
    
    ;Store context
    movwf   w_temp	    ;Store W in w_temp
    swapf   STATUS,W	  
    movwf   status_temp	    ;Store Status in status_temp

    BTFSC   INTCON, INTF	
    call    INT_INT	    ;External interrupt
    BTFSC   INTCON, RBIF
    call    INT_RB	    ;State change interrupt

    ;Restore context
    swapf   status_temp,W
    movwf   STATUS	    ;Restore States
    swapf   w_temp, F
    swapf   w_temp, W	    ;Restore W
    retfie                    
;Every time a button placed in RB0 is pressed, count   
INT_INT
    BANKSEL INTCON	    ;Select bank where INTCON is
    BCF	    INTCON, INTF    ;Reset external interruption flag
    call    INCREMENT	    ;Call increment function
    return
;Every time a button placed among RB4 and RB7 is pressed, increment, decrement or clear 
INT_RB
    BANKSEL PORTB	    ;Select bank where PORTB is
    BTFSC   PORTB, 4	    ;Test if RB4 was fired
    call    INCREMENT	    ;Call increment function
    BTFSC   PORTB, 5	    ;Test if RB5 was fired
    call    DECREMENT	    ;Call decrement function
    BTFSC   PORTB, 6	    ;Test if RB6 was fired
    call    CLEAR	    ;Call clear function
    BANKSEL INTCON	    ;Select bank where INTCON is
    BCF	    INTCON, RBIF    ;Reset state change interruption flag
    return		    ;Return

DECREMENT
    MOVLW   D'0'	    ;Move 0 to W
    ADDWF   counter, W	    ;Add W to counter and store the result in W
    BTFSC   STATUS, Z	    ;If counter is zero, Z will be set 1
    GOTO    DEMACIA	    ;If Z was set, Charge all counters
    DECF    counter, F	    ;Decrement master counter until 0
    DECF    counter3, F	    ;Decrement least significant counter until 0
    MOVLW   D'255'	    
    SUBWF   counter3, W	    
    BTFSS   STATUS, Z	    ;If counter3 is equal to 255 skip next address
    return		    ;Otherwise, return
    MOVLW   D'9'
    MOVWF   counter3	    ;Set counter3 to 9
    DECF    counter2, F	    ;Decrement middle counter until 10
    MOVLW   D'255'	    
    SUBWF   counter2, W	    
    BTFSS   STATUS, Z	    ;If counter2 is equal to 255 skip next address
    return		    ;Otherwise, return
    MOVLW   D'9'
    MOVWF   counter2	    ;Set counter2 to 9
    DECF    counter1, F	    ;Decrement most significant counter until 0
    return		    ;return
INCREMENT
    INCF    counter, F	    ;Increment master counter until 255
    BTFSC   STATUS, Z	    ;If caused overflow in master counter
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
    CLRF    counter	    ;Reset all counters
    CLRF    counter1	    
    CLRF    counter2
    CLRF    counter3
    return		    ;return
DEMACIA
    MOVLW   D'255'
    MOVWF   counter
    MOVLW   D'2'
    MOVWF   counter1
    MOVLW   D'5'
    MOVWF   counter2
    MOVLW   D'5'
    MOVWF   counter3
    return		    ;return
DISPLAY
    BANKSEL PORTB	    ;Select bank where PORTB is
    BCF	    PORTB, 1	    
    BCF	    PORTB, 2	    
    BSF	    PORTB, 3	    ;Set PORTB.3 to send to display3 
    MOVLW   B'00000000'
    IORWF   counter3, W	    ;Set counter3 to W in binary
    BANKSEL PORTC	    ;Select bank where PORTC is
    MOVWF   PORTC	    ;Set W to PORTC
    BANKSEL PORTB	    ;Select bank where PORTB is
    BCF	    PORTB, 1
    BSF	    PORTB, 2	    ;Set PORTB.2 to send to display2
    BCF	    PORTB, 3
    MOVLW   B'00000000'
    IORWF   counter2, W
    BANKSEL PORTC	    ;Select bank where PORTC is
    MOVWF   PORTC	    ;Set W to PORTC
    BANKSEL PORTB	    ;Select bank where PORTB is
    BSF	    PORTB, 1	    ;Set PORTB.2 to send to display1
    BCF	    PORTB, 2
    BCF	    PORTB, 3
    MOVLW   B'00000000'
    IORWF   counter1, W
    BANKSEL PORTC	    ;Select bank where PORTC is
    MOVWF   PORTC	    ;Set W to PORTC
    return		    ;Return
SETUP    
    BANKSEL INTCON	    ;Select bank where INTCON is
    BSF	    INTCON, GIE	    ;Enable interruptions
    BSF	    INTCON, INTE    ;Enable extern interruption
    BSF	    INTCON, RBIE    ;Enable state change interruption
    CLRF    counter	    ;Clear master counter
    CLRF    counter1	    ;Clear counter1
    CLRF    counter2	    ;Clear counter2
    CLRF    counter3	    ;Clear counter3
    BANKSEL TRISC	    
    MOVLW   B'00000000'	    ;Set PORTC as output
    MOVWF   TRISC
    BANKSEL PORTB	    
    BCF	    PORTB, 1	    ;Clear PORTB.1
    BCF	    PORTB, 2	    ;Clear PORTB.2
    BCF	    PORTB, 3	    ;Clear PORTB.3
MAIN
    call DISPLAY	    ;Call display function
    goto MAIN		    
    end