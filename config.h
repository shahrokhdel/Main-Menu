#define DELETE              10
#define ENTER               11
#define DeviceAddress       0xA0
#define mainMenuAdd         1
#define buffSize            16
#define maxMenuitemsX       3
#define maxMenuitemsY       3
#define passLen             4

// Declare your global variables here
unsigned int i,j;
int zone=0, mmz=0, smz=0; // Witch Menu Zone 
int kpass=0;  
// Pass code is no correct
int MemAddress = mainMenuAdd;
//int subMenuPush = 0;
//int SubAddress = mainMenuAdd + ((maxMenuitemsX+1)*buffSize);
char temp[buffSize];
char tempStr[buffSize];
char mStr[buffSize];

char sys_code[5];

char usr_code[sizeof(sys_code)] = "";
char usr_code_idx = 0;

char setPass[5];

/*************************************
MM
{{"", 4}, {"", 5}, {"", 7}};
SM
{{"",3},{"",4},{"",5}},
{{"",2},{"",6},{"",2}},
{{"",7},{"",7},{"",9}}
};
**************************************/

struct mainMenu {
    char Name[buffSize];
    uint8_t len;
}MM[maxMenuitemsX] = {{"", 4}, {"", 5}, {"", 7}};

struct subMenu {
    char Name[buffSize];
    uint8_t len;    
}SM[maxMenuitemsX][maxMenuitemsY]={
{{"",3},{"",4},{"",5}},
{{"",2},{"",6},{"",2}},
{{"",7},{"",7},{"",9}}
};

struct date {
    uint8_t weekDay;
    uint8_t year;
    uint8_t month;
    uint8_t day;
}d;

struct time {
    uint8_t hour;
    uint8_t min;
    uint8_t sec;
}t;

// ÂÏÑÓ Ïåí Çæáíå RTC
//rtc_set_date(3,  5, 7, 24);
//rtc_set_time(4, 47, 1);

/*
// Writting to EEPROM
for(i=0; i<maxMenuitemsX ; i++){
    EEPROM_WritePage(DeviceAddress, MemAddress, (char*)str[i], strlen(str[i]));
    delay_ms(10);
    MemAddress += buffSize ;
}

for(i=0; i<maxMenuitemsX ; i++){
    for(j=0; j<maxMenuitemsY ; j++){
        EEPROM_WritePage(DeviceAddress, MemAddress, (char*)stritems[i][j], strlen(stritems[i][j]));
        delay_ms(10);
        MemAddress += buffSize ;
    }
}
*/ 

void micro_init(){
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization  for Kay Pad (4 * 4)     A0 A1 A2 A3 A4 A5 A6 A7
//                                                R1 R2 R3 R4 C1 C2 C3 C4
//DDRA  = 0xF0;
//PORTA = 0x0F;
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
// Function: Bit7=Out    Bit6=Out    Bit5=Out    Bit4=Out    Bit3=In     Bit2=In     Bit1=In     Bit0=In 
   DDRA  =   (1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State:    Bit7=T        Bit6=T        Bit5=T        Bit4=T        Bit3=F        Bit2=F        Bit1=F        Bit0=F   
   PORTA =   (0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (1<<PORTA3) | (1<<PORTA2) | (1<<PORTA1) | (1<<PORTA0);

// Port B initialization For  LCD
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization USE FOR ...
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
DDRC =(0<<DDC7) | (0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (1<<DDC0);
// State:Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization For I2C(SCL 0 & SDA 1) AND Interapt0(PIN2)
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State:Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (0<<CS02) | (0<<CS01) | (0<<CS00);
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0<<AS2;
TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
TCNT2=0x00;
OCR2=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);

// External Interrupt(s) initialization
// INT0: on
// INT0 Mode: Any change
// INT1: Off
// INT2: Off
GICR|=(0<<INT1) | (1<<INT0) | (0<<INT2);
MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (1<<ISC00);
MCUCSR=(0<<ISC2);
GIFR=(0<<INTF1) | (1<<INTF0) | (0<<INTF2);

// USART initialization
// USART disabled
UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);

// Analog Comparator initialization
// Analog Comparator: Off
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
SFIOR=(0<<ACME);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// TWI disabled
TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);

// Bit-Banged I2C Bus initialization
// I2C Port: PORTD
// I2C SDA bit: 1
// I2C SCL bit: 0
// Bit Rate: 100 kHz
// Note: I2C settings are specified in the
// Project|Configure|C Compiler|Libraries|I2C menu.
i2c_init();

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 8
lcd_init(16);

// Global enable interrupts
#asm("sei")
}

void EEPROM_WritePage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len){
    uint8_t current_byte;
    i2c_start();
    i2c_write(deviceAddress);
    i2c_write(memAddress);
    while (len--) {
        current_byte = *data++;
        i2c_write(current_byte);
}
current_byte = '\0';
i2c_write(current_byte);
i2c_stop();
}

void EEPROM_ReadPage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len) {
    i2c_start();
    i2c_write(deviceAddress);
    i2c_write(memAddress);
    i2c_start();
    i2c_write(deviceAddress | 0x01);
    while (--len) {
        *data++ = i2c_read(1);
    }
    *data++ = i2c_read(0);
    *data = '\0'; // ÇÖÇÝå ˜ÑÏä '\0' Èå ÇäÊåÇí ÑÔÊå
    i2c_stop();
}

char GetKey() {
unsigned char key_code = 0xFF;
unsigned char columns;
PORTA = 0xFF;

// first row
PORTA.4 = 0;
columns = PINA & 0x0F; 
if(columns != 0x0F)
  { 
    switch(columns)
    {
        case 0b1110 : key_code = 1;  break;
        case 0b1101 : key_code = 2;  break;
        case 0b1011 : key_code = 3;  break;
        case 0b0111 : key_code = 12; break;
    }
  }    

// second row
PORTA.4 = 1;
PORTA.5 = 0;
columns = PINA & 0x0F;
if(columns != 0x0F)
  {
  switch(columns)
    {
        case 0b1110 : key_code = 4;  break;
        case 0b1101 : key_code = 5;  break;
        case 0b1011 : key_code = 6;  break;
        case 0b0111 : key_code = 13; break;
    }
  }
  
// third row
PORTA.5 = 1;
PORTA.6 = 0;
columns = PINA & 0x0F;
if(columns != 0x0F)
  {
  switch(columns)
    {
        case 0b1110 : key_code = 7;  break;
        case 0b1101 : key_code = 8;  break;
        case 0b1011 : key_code = 9;  break;
        case 0b0111 : key_code = 14; break;
    }
  }  

// fourth row
PORTA.6 = 1;
PORTA.7 = 0;
columns = PINA & 0x0F;
if(columns != 0x0F)
  {
  switch(columns)
    {
        case 0b1110 : key_code = DELETE; break;
        case 0b1101 : key_code = 0     ; break;
        case 0b1011 : key_code = ENTER ; break;
        case 0b0111 : key_code = 15    ; break;
    }
  } 
PORTA.7 = 1;
PORTA = 0x0F;
return key_code;
}

void showDateTime()
{
    int k=0;
    for(k=0;k<6;k++)
    { 
        rtc_get_date(&d.weekDay, &d.day, &d.month, &d.year);
        sprintf(mStr, "%02u/%02u/%02u - Day %u", d.month, d.day, d.year, d.weekDay);
        lcd_clear();
        lcd_gotoxy(0, 1);
        lcd_puts(mStr);
        rtc_get_time(&t.hour, &t.min, &t.sec);
        sprintf(mStr, "%02u:%02u:%02u", t.hour, t.min, t.sec);
        lcd_gotoxy(0, 0);
        lcd_puts(mStr);
        delay_ms(1000);
    }
}

void makeScreen(int z,int m, int s)
{
    switch(z)
    {
        case 0:{
            lcd_clear();
            lcd_gotoxy(0,0);    
            sprintf(tempStr,"%s",MM[m].Name);
            lcd_puts(tempStr);
        };
        break;
        case 1:{
            lcd_clear();
            lcd_gotoxy(0,0);    
            sprintf(tempStr,"%s",MM[m].Name);
            lcd_puts(tempStr);
            lcd_gotoxy(0,1);    
            sprintf(temp,"%s",SM[m][s].Name);
            lcd_puts(temp);
        };
        break;
    }
}

void menu1(){
    int i=0,j=0;
    char kp;
    GICR |= (0 << INTF0);
    lcd_clear();
    lcd_gotoxy(0, 0);
    lcd_puts("Enter New Pass:");
    lcd_gotoxy(0,1);  
    while(i==0) {
        kp = GetKey();
        delay_ms(200);
        if(kp != 0xFF) { 
            switch(kp) {                                  
                case 10 : ; break;
                case 11 : {
                    lcd_clear();
                    lcd_gotoxy(0, 0);
                    lcd_puts("New Pass is:");
                    lcd_gotoxy(0,1);     
                    lcd_puts(setPass);
                    delay_ms(1000);
                    MemAddress = mainMenuAdd; 
                    EEPROM_WritePage(DeviceAddress, MemAddress, setPass, 5);
                    delay_ms(10);
                    lcd_clear();
                    lcd_puts("pass chenged");
                    delay_ms(500);
                    i=1;
                };break;
                case 12 : ; break;
                case 13 : ; break;                                   
                case 14 : ; break;
                case 15 : ; break; 
                default : { 
                    if(j<=3) {
                        PORTC.0=1;
                        delay_ms(50);
                        PORTC.0=0;
                        setPass[j] = kp + 0x30; // save the ascii code of digit
                        sprintf(tempStr,"%d",kp);
                        lcd_puts(tempStr);                       
                        j++;
                    }else if(j==3) {
                        setPass[j+1] = '\0'; // save the ascii code of digit       
                    }
                }; break;
            }
        
        }
    }

    // clear INTF0
    GICR |= (1 << INTF0);
}