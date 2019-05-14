#include <avr/io.h>
#define TRIG_PIN	3
#define ECHO_PIN	2
#define BUZZ_PIN	1
#define SENSOR_DIR      _(DDRD)
#define SENSOR_PORT     _(PORTD)
#define SENSOR_PIND	_(PIND)
#define BUZZ_DIR	_(DDRB)
#define BUZZ_PORT       _(PORTB)

// include this line to avoid SFR_REG issues
#define _(s)    _SFR_IO_ADDR(s)
