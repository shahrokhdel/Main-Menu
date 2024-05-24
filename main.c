/*******************************************************
This program was created by the
CodeWizardAVR V3.14 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : V0.2 
Date    : 05/07/2024
Author  : SHAHROKH DELGOSHAD 
Company : DPSys.co
Comments: Read menu items from EEPROM and copy to strauctur  

Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/
#include <io.h>
#include <i2c.h>
#include <alcd.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <ds1307.h>
#include "config.h"

// Declare your global Function here
//void EEPROM_WritePage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len);
//void EEPROM_ReadPage(uint8_t deviceAddress, uint8_t memAddress, uint8_t* data, uint8_t len);
//void makeScreen(int z,int m, int s);
//void showDateTime();
//char GetKey();
//void menu1();
void KeyAction(char KeyPress);

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
    char k;
    delay_ms(200);
    k = GetKey();
    if(k != 0xFF) { 
        PORTC.0=1;
        delay_ms(50);
        PORTC.0=0;
        KeyAction(k);
        //newKeyAction(k,kpass,mmz,smz);
    }
    // clear INTF0
    GICR |= (1 << INTF0);
}

void main(void) {
    micro_init();

    // Initialize Menu items reead from EEPROM 
    MemAddress = mainMenuAdd;
    // Reading Password from EEPROM
    EEPROM_ReadPage(DeviceAddress, MemAddress , tempStr, passLen);
    delay_ms(10);
    MemAddress += buffSize ;
    strcpy(sys_code,tempStr);
    
    for(i=0; i<maxMenuitemsX ; i++){
        EEPROM_ReadPage(DeviceAddress, MemAddress , tempStr, MM[i].len);
        delay_ms(10);
        MemAddress += buffSize ;
        sprintf(MM[i].Name,"%s",tempStr);
    }
    
    for(i=0; i<maxMenuitemsX ; i++){
        for(j=0; j<maxMenuitemsY ; j++){
            EEPROM_ReadPage(DeviceAddress, MemAddress, tempStr, SM[i][j].len);
            delay_ms(10);
            MemAddress += buffSize ;
            sprintf(SM[i][j].Name,"%s",tempStr);
        }
    }
    lcd_clear();
    lcd_gotoxy(4, 0);     
    lcd_puts("DPSys.co");
    lcd_gotoxy(0, 1);
    lcd_puts("Pass Key :");
          
    while (1)
    {
        // Place progrram
    }
}

void KeyAction(char KeyPress)
{
    if(kpass == 0)
    {
        switch(KeyPress)
        {                                  
            case 10 : {
                strcpyf(usr_code, "");
                usr_code_idx = 0;
                lcd_clear();
                lcd_gotoxy(4, 0);     
                lcd_puts("DPSys.co");
                lcd_gotoxy(0, 1);
                lcd_puts("Pass Key :");
            }; break;
            case 11 : {
                usr_code[usr_code_idx] = '\0';
                // user code equals to system code
                if(strcmp(usr_code, sys_code) == 0)
                {
                  lcd_clear();
                  lcd_gotoxy(3, 0);
                  lcd_putsf("Lock : ON");
                  delay_ms(1000);
                  lcd_clear();
                  lcd_gotoxy(0, 0);
                  sprintf(tempStr,"%s",MM[0].Name);
                  lcd_puts(tempStr);
                  kpass = 1;
                  //while(GetKey() != DELETE);
                  }
                // user code is invalid
                else
                {
                  lcd_clear();
                  lcd_putsf("Invalid Password");
                  delay_ms(2000);
                }
                // clear the user code buffer
                strcpyf(usr_code, "");
                usr_code_idx = 0;
            }; break;
            
            default : {
                if(usr_code_idx < sizeof(usr_code) - 1)
                {
                    usr_code[usr_code_idx] = KeyPress + 0x30; // save the ascii code of digit
                    usr_code_idx++;
                    lcd_putchar('*');
                    //lcd_puts(usr_code);
                }
            }  
        }
    }else {    
        if(zone == 0) {
            switch(KeyPress)
            {                                  
               case 10 : ; break;       // DELETE *
               case 11 : zone++; break; // ENTER  #
               case 12 : showDateTime(); break;
               case 13 : ; break;
               case 14 :                // UP F14 
               { 
                    if(mmz ==  maxMenuitemsX-1 | mmz != 0 ) mmz--;
                    else mmz=maxMenuitemsX-1;
               }                
               ;break;
               case 15 :                // DOWN F15 
               {              
                    if(mmz == 0 | mmz != maxMenuitemsX-1) mmz++;
                    else mmz=0;
               } 
               ; break;
            }
            makeScreen(zone, mmz, smz);
        }else {
            switch(KeyPress)
            {                                  
                case 10 : {zone--; smz=0;}; break;
                case 11 : { 
                        switch(mmz*10 + smz)
                        {
                            case 0 : {lcd_puts("HALLO"); delay_ms(500);}; break;
                            case 1 : ; break;
                            case 20 : menu1(); break;
                            case 22 : showDateTime();break;
                        }
                    
                }; break;
                case 14 :              // UP F14 
                { 
                    if(smz ==  maxMenuitemsY-1 | smz != 0 ) smz--;
                    else smz=maxMenuitemsY-1;
                };break;
                case 15 :             // DOWN F15 
                { 
                    if(smz == 0 | smz != maxMenuitemsY-1) smz++;
                    else smz=0;
                }; break;
            }
            makeScreen(zone, mmz, smz);
        }
    }  
}