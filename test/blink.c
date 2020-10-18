/*  Blink Firmware Test for Arduino Uno (atmega328p)
    by Matheus Souza (github.com/mfbsouza)
    
    builtin led on Uno = Port 13 = PB5 */


#ifndef F_CPU
#define F_CPU 16000000UL
#endif

#define IOREG_OFFSET 0x20

#include <util/delay.h>

int main(void) {

    // registers
    volatile uint8_t *ddrb  = (uint8_t *)(0x04 + IOREG_OFFSET);
    volatile uint8_t *portb = (uint8_t *)(0x05 + IOREG_OFFSET);
    
    // PB5 as output
    *ddrb |= 1 << 5;
    
    while (1) {
        *portb ^= 1 << 5;
        _delay_ms(1000);
    }

    return 0;
}