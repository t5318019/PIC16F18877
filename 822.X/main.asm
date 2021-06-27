	LIST p=16F18877
	#include<p16F18877.inc>
	
	__CONFIG _CONFIG1, _FEXTOSC_HS & _RSTOSC_EXT1X
	__CONFIG _CONFIG2, _BOREN_ON & _PPS1WAY_OFF
	__CONFIG _CONFIG3, _WDTE_OFF
	__CONFIG _CONFIG5, _CP_OFF & _CPD_OFF
	
D1	EQU	0x20
D2	EQU	0x21
D3	EQU	0x22
DATA_TEMP   EQU	0X23
	
	ORG	00H
	GOTO	START
	
START:	MOVLB	.17
	MOVLW	0x70
	MOVWF	OSCCON1
	MOVLW	0x04
	MOVWF	OSCFRQ
	
	MOVLB	.1
	MOVLW	0x3F
	MOVWF	ADCLK
	MOVLW	0x80
	MOVWF	ADCON0
	
	MOVLB	.0
	CLRF	TRISD
	CLRF	LATD
	
	MOVLB	.14
	BCF	PIR1,ADIF
	BSF	STATUS,C
	
RL:	MOVLB	.0
	RLF	LATD,F
	CALL	ADCONV
	CALL	DELAY
	MOVLB	.0
	BTFSS	LATD,7
	GOTO	RL
	
RR:	MOVLB	.0
	RLF	LATD,F
	CALL	ADCONV
	CALL	DELAY
	MOVLB	.0
	BTFSS	LATD,0
	GOTO	RR
	GOTO	RL
	
ADCONV:	MOVLB	.1
	MOVLW	0X03
	MOVWF	ADPCH
	BSF	ADCON0,ADON
	BCF	ADCON0,ADCONT
	BSF	ADCON0,ADGO
	
ADWAIT:	MOVLB	.14
	BTFSS	PIR1,ADIF
	GOTO	ADWAIT
	BCF	PIR1,ADIF
	
	MOVLB	.1
	MOVF	ADRESH,W	
	BTFSS	STATUS,Z
	GOTO	AA
	
	MOVLB	.1
	MOVLW	0X04
	MOVWF	ADRESL
	MOVLW	0X00
	MOVWF	ADRESH
	
AA:	MOVLB	.1
	MOVF	ADRESH,W
	MOVLB	.0
	MOVWF	DATA_TEMP

DELAY:	MOVLB	.0
	MOVF	DATA_TEMP,W
	MOVWF	D3
DLY1:	MOVLW	.5
	MOVWF	D2
DLY2:	DECFSZ	D1,F
	GOTO	DLY2
	DECFSZ	D2,F
	GOTO	DLY2
	DECFSZ	D3,F
	GOTO	DLY1
	RETURN
	
DELAY1:	MOVLB	.0
	MOVLW	.24
	MOVWF	D1
DLY11:	DECFSZ	D1,F
	GOTO	DLY11
	RETURN
	
	END