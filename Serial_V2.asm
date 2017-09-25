
; CC5X Version 3.4B, Copyright (c) B Knudsen Data
; C compiler for the PICmicro family
; ************  18. May 2010  13:40  *************

	processor  16F877
	radix  DEC

INDF        EQU   0x00
FSR         EQU   0x04
PORTB       EQU   0x06
TRISB       EQU   0x86
Zero_       EQU   2
RP0         EQU   5
RP1         EQU   6
IRP         EQU   7
RBIF        EQU   0
RBIE        EQU   3
GIE         EQU   7
PORTC       EQU   0x07
PORTD       EQU   0x08
RCREG       EQU   0x1A
TRISC       EQU   0x87
TRISD       EQU   0x88
SPBRG       EQU   0x99
PEIE        EQU   6
RCIF        EQU   5
CREN        EQU   4
SPEN        EQU   7
RCIE        EQU   5
BRGH        EQU   2
SYNC        EQU   4
prijem      EQU   0x21
pom         EQU   0x22
k           EQU   0x20

	GOTO main

  ; FILE Serial_V2.c
			;char prijem;
			;char pom;
			;
			;void init_serial()
			;{
init_serial
			;	TRISC.5=0;
	BSF   0x03,RP0
	BCF   0x03,RP1
	BCF   TRISC,5
			;	PORTC.5=0;
	BCF   0x03,RP0
	BCF   PORTC,5
			;	BRGH=1;  // High Baud Rate
	BSF   0x03,RP0
	BSF   0x98,BRGH
			;	
			;	SPBRG=50; // Za 9600 na Fosc=8MHz
	MOVLW 50
	MOVWF SPBRG
			;	SYNC=0;	// Asinhrona komunikacija
	BCF   0x98,SYNC
			;	SPEN=1;	// Aktiviranje serijskog porta
	BCF   0x03,RP0
	BSF   0x18,SPEN
			;	RCIE=1; // Onemogucavanje interrupta na serijskom portu
	BSF   0x03,RP0
	BSF   0x8C,RCIE
			;	CREN=0; // Ukljucivanje/iskljucivanje prijemnika
	BCF   0x03,RP0
	BCF   0x18,CREN
			;}
	RETURN
			;
			;void main(){
main
			;
			;	char k;
			;	clearRAM();
	BCF   0x03,IRP
	MOVLW 32
m001	MOVWF FSR
m002	CLRF  INDF
	BSF   FSR,7
	CLRF  INDF
	BCF   FSR,7
	INCF  FSR,1
	BTFSS FSR,7
	GOTO  m002
	BTFSC 0x03,IRP
	GOTO  m003
	BSF   0x03,IRP
	MOVLW 16
	GOTO  m001
			;	TRISD=0;	
m003	BSF   0x03,RP0
	BCF   0x03,RP1
	CLRF  TRISD
			;	PORTD=0;
	BCF   0x03,RP0
	CLRF  PORTD
			;	init_serial();
	CALL  init_serial
			;
			;	PEIE=0;
	BCF   0x0B,PEIE
			;	GIE=1;
	BSF   0x0B,GIE
			;
			;	k=0;
	BCF   0x03,RP0
	BCF   0x03,RP1
	CLRF  k
			;
			;	CREN=1;
	BSF   0x18,CREN
			;	
			;	TRISB=255;
	MOVLW 255
	BSF   0x03,RP0
	MOVWF TRISB
			;	RBIE=1;
	BSF   0x0B,RBIE
			;	pom=0;
	BCF   0x03,RP0
	CLRF  pom
			;
			;	while(RCIF) prijem=RCREG;
m004	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSS 0x0C,RCIF
	GOTO  m005
	MOVF  RCREG,W
	MOVWF prijem
	GOTO  m004
			;
			;		while(1){
			;		//	if(OERR){
			;		//		CREN=0;
			;		//		CREN=1;
			;		//			}
			;			
			;			if(RCIF){
m005	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSS 0x0C,RCIF
	GOTO  m018
			;
			;					while(RCIF){
m006	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSS 0x0C,RCIF
	GOTO  m007
			;
			;						prijem=RCREG;
	MOVF  RCREG,W
	MOVWF prijem
			;
			;								}
	GOTO  m006
			;					if(prijem=='#'){
m007	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 35
	BTFSS 0x03,Zero_
	GOTO  m018
			;
			;							while(RCIF!=1);
m008	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSS 0x0C,RCIF
	GOTO  m008
			;								
			;							prijem=RCREG;
	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  RCREG,W
	MOVWF prijem
			;		
			;								if(prijem=='D'){
	MOVF  prijem,W
	XORLW 68
	BTFSS 0x03,Zero_
	GOTO  m018
			;
			;										while(RCIF!=1);
m009	BCF   0x03,RP0
	BCF   0x03,RP1
	BTFSS 0x0C,RCIF
	GOTO  m009
			;
			;										prijem=RCREG;
	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  RCREG,W
	MOVWF prijem
			;
			;										   	if(prijem==0){
	MOVF  prijem,1
	BTFSS 0x03,Zero_
	GOTO  m010
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==1){	 																
	GOTO  m018
m010	BCF   0x03,RP0
	BCF   0x03,RP1
	DECFSZ prijem,W
	GOTO  m011
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==2){	 																
	GOTO  m018
m011	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 2
	BTFSS 0x03,Zero_
	GOTO  m012
			;											PORTD=prijem;						
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==4){	 																
	GOTO  m018
m012	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 4
	BTFSS 0x03,Zero_
	GOTO  m013
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==8){	 																
	GOTO  m018
m013	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 8
	BTFSS 0x03,Zero_
	GOTO  m014
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==16){	 																
	GOTO  m018
m014	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 16
	BTFSS 0x03,Zero_
	GOTO  m015
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==32){	 																
	GOTO  m018
m015	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 32
	BTFSS 0x03,Zero_
	GOTO  m016
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}
			;											else if(prijem==64){	 																
	GOTO  m018
m016	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 64
	BTFSS 0x03,Zero_
	GOTO  m017
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}					
			;											else if(prijem==128){	 																
	GOTO  m018
m017	BCF   0x03,RP0
	BCF   0x03,RP1
	MOVF  prijem,W
	XORLW 128
	BTFSS 0x03,Zero_
	GOTO  m018
			;											PORTD=prijem;
	MOVF  prijem,W
	MOVWF PORTD
			;															}		
			;												}
			;											}
			;									}
			;	
			;		
			;
			;		if(RBIF){
m018	BTFSS 0x0B,RBIF
	GOTO  m019
			;
			;			PORTD=0;
	BCF   0x03,RP0
	BCF   0x03,RP1
	CLRF  PORTD
			;			pom=PORTB;
	MOVF  PORTB,W
	MOVWF pom
			;			RBIF=0;	
	BCF   0x0B,RBIF
			;			
			;		}
			;	CREN=1;
m019	BCF   0x03,RP0
	BCF   0x03,RP1
	BSF   0x18,CREN
			;		
			;		
			;		
			;
			;
			;	}
	GOTO  m005

	END


; *** KEY INFO ***

; 0x0001 P0   17 word(s)  0 % : init_serial
; 0x0012 P0  164 word(s)  8 % : main

; RAM usage: 3 bytes (1 local), 365 bytes free
; Maximum call level: 1
;  Codepage 0 has  182 word(s) :   8 %
;  Codepage 1 has    0 word(s) :   0 %
;  Codepage 2 has    0 word(s) :   0 %
;  Codepage 3 has    0 word(s) :   0 %
; Total of 182 code words (2 %)
