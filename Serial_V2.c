char prijem;
char pom;

void init_serial()
{
	TRISC.5=0;
	PORTC.5=0;
	BRGH=1;  // High Baud Rate
	
	SPBRG=50; // Za 9600 na Fosc=8MHz
	SYNC=0;	// Asinhrona komunikacija
	SPEN=1;	// Aktiviranje serijskog porta
	RCIE=1; // Onemogucavanje interrupta na serijskom portu
	CREN=0; // Ukljucivanje/iskljucivanje prijemnika
}

void main(){

	char k;
	clearRAM();
	TRISD=0;	
	PORTD=0;
	init_serial();

	PEIE=0;
	GIE=1;

	k=0;

	CREN=1;
	
	TRISB=255;
	RBIE=1;
	pom=0;

	while(RCIF) prijem=RCREG;

		while(1){
		//	if(OERR){
		//		CREN=0;
		//		CREN=1;
		//			}
			
			if(RCIF){

					while(RCIF){

						prijem=RCREG;

								}
					if(prijem=='#'){

							while(RCIF!=1);
								
							prijem=RCREG;
		
								if(prijem=='D'){

										while(RCIF!=1);

										prijem=RCREG;

										   	if(prijem==0){
											PORTD=prijem;
															}
											else if(prijem==1){	 																
											PORTD=prijem;
															}
											else if(prijem==2){	 																
											PORTD=prijem;						
															}
											else if(prijem==4){	 																
											PORTD=prijem;
															}
											else if(prijem==8){	 																
											PORTD=prijem;
															}
											else if(prijem==16){	 																
											PORTD=prijem;
															}
											else if(prijem==32){	 																
											PORTD=prijem;
															}
											else if(prijem==64){	 																
											PORTD=prijem;
															}					
											else if(prijem==128){	 																
											PORTD=prijem;
															}		
												}
											}
									}
	
		

		if(RBIF){

			PORTD=0;
			pom=PORTB;
			RBIF=0;	
			
		}
	CREN=1;
		
		
		


	}


}
