; PIC16F877A Configuration Bit Settings

; ASM source line config statements

#include "p16F877A.inc"

; CONFIG
; __config 0xFF7A
 __CONFIG _FOSC_HS & _WDTE_OFF & _PWRTE_OFF & _BOREN_ON & _LVP_OFF & _CPD_OFF & _WRT_OFF & _CP_OFF

 ;Variables definition
 cblock
    counter1
    counter2
    counter3
 endc
 
 org 0x00
 goto setup
 
 org 0x04   ;Interruption handler
 
 reti
 
 
setup
  
 
loop
 goto $  ;idle indefinitely until interruption 
 end 
