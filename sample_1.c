#include <avr/io.h> 
#include <avr/interrupt.h> 
#include <util/delay.h> 
volatile char key_pressed = 0; 

// ������ ���� ���� 4x4 
/*
char keypad[4][4] = { 
    {'1', '2', '3', 'A'}, 
    {'4', '5', '6', 'B'}, 
    {'7', '8', '9', 'C'}, 
    {'*', '0', '#', 'D'} 
}; 
*/

char keypad[4][4] = { 
    {'1', '2',  '3', '12'}, 
    {'4', '5',  '6', '13'}, 
    {'7', '8',  '9', '14'}, 
    {'10','0', '11', '15'} 
}; 

// ���ʝ�� � ����� �� ���� ���� ���� ������� �흘��� 
void keypad_init(void) { 
    // ���ݝ�� (Rows) �� ����� ����� 
    DDRD = 0x0F; PORTD = 0xF0;  // ���� ���� �����ʝ��� ���  ����� ���� ������ (Columns) 
    
    // ���� ���� ���� ����� INT0 ���� ��� ����� 
    MCUCR |= (1 << ISC01);      // ISC01 = 1 � ISC00 = 0 (��� �����) 
                            
    GICR |= (1 << INT0);        // ���� ���� INT0 
    
    // ���� ���� ������� ����� 
    sei(); } 
    
    // ����� ���� ���� 
INT0 ISR(INT0_vect) { 
    // �Ә� ���� ���� ���� ����� ���� ����� ��� 
    for (uint8_t row = 0; row < 4; row++) { // ����� ���ݝ�� �� ����� ����� � ������ �� ����� ����� 
        DDRD = (1 << row); 
        PORTD = ~(1 << row);
         _delay_us(5);
          // ���� ���� ����� 
          for (uint8_t col = 0; col < 4; col++) { 
            if (!(PIND & (1 << (col + 4)))) { // ����� ���� ���� ����� ��� ��� �� �� 
                key_pressed = keypad[row][col]; 
                return; 
            } 
          } 
    } 
} 

// ���� ���� ��Ґ������ ���� ����� ��� 
char get_key(void) { 
    char key = key_pressed; 
    key_pressed = 0; // �������� ����� �� �� ������ 
    return key; 
} 

int main(void) { 
    keypad_init(); 
    while (1) { 
        char key = get_key(); 
        if (key) { 
            // ������ ���� ����� ��� // ����� �������� �� key ���� ����� ������ �� ���� ���� ������� ���� } // ���� ����� ���� ���� // ... 
        
        } return 0; 
    }
}