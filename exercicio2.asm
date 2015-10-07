main:
	MOV R1, #0
	CALL sumr1
sumr1:	
	INC R1
	CJNE R1, #255, sumr1
sumr2:	
	MOV R1, #0
	INC R2
	CJNE R2, #255, sumr1
	CALL sumr3
	
sumr3:	
	MOV R1, #0
	MOV R2, #0
	INC R3
	CJNE R3, #255, sumr1
	
