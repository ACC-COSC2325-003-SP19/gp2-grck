Device Description
******************
The device we will be demonstrating for our project is the ultrasonic wave sensor, the HC-SR04.

.. image:: ultrasonic.png
	:align: center

.. csv-table:: Device Features
   :header: "Feature", "Description"
   :delim: |

    Power Supply| +5V DC
    Quiescent Current| <2mA
    Working Current| 15mA
    Effectual Angle| <15°
    Ranging Distance| 2cm – 400 cm/1″ – 13ft
    Resolution| 0.3 cm
    Measuring Angle| 30 degree
    Trigger Input Pulse width| 10uS
    Dimension| 45mm x 20mm x 15mm

.. csv-table:: This device has 4 Pins
   :header: "PIN", "Description"
   :delim: |

    VCC| 5V, positive end of the power supply
    TRIG| Trigger Pin
    ECHO| Echo Pin
    GND| 0V, ground, negative end of the power supply

The TRIG and ECHO pins will be used to communicate from our microcontroller to the ultrasonic module. 

The HC-SR04 ultrasonic sensor is able to measure distances of objecs by utilizing sonar.

1. The transmitter (trig pin) sends a signal: a high frequency sound.

2. If the is an object in front of it, the signal will be reflected back.

3. The transmitter (echo pin) will receive the signal

-Ruben Suarez

How To Control the Device
*************************

Device Demonstration
********************
.. image:: Board_setup.png
	:align: center

-Ruben Suarez

Project Code
************
main.c
======
::

    // Copyright 2019 Ruben Suarez

    #include <avr/io.h>
    #include <util/delay.h>

    //--- PIN Assignments ----------------------------------------------------
    #define RED_PIN             0
    #define GREEN_PIN           5
    #define BLUE_PIN            4


    //--- PIN Controls -------------------------------------------------------
    #define RED_ON              (PORTB |= (1<<RED_PIN))
    #define RED_OFF             (PORTB &= ~(1<<RED_PIN))
    #define GREEN_ON            (PORTB |= (1<<GREEN_PIN))
    #define GREEN_OFF           (PORTB &= ~(1<<GREEN_PIN))
    #define BLUE_ON             (PORTB |= (1<<BLUE_PIN))
    #define BLUE_OFF            (PORTB &= (0X01))


    //--- Device Setup -------------------------------------------------------
    #define OUTPUT_CONFIG       (DDRB |= (1<<RED_PIN) | (1<<GREEN_PIN) | (1<<BLUE_PIN))
    #define CPU_PRESCALE(n)     (CLKPR = 0x80, CLKPR = (n))

    //--- LED ----------------------------------------------------------------
    void LEDColor(int distance) {

       if (distance > 400) {
    	    BLUE_ON;
       }
       if (distance < 10) {
      	    RED_ON;
       }
       else {
      	    GREEN_ON;
       }
    }


    //--- Main ----------------------------------------------------------
    int main(void) {
       OUTPUT_CONFIG;
       int distance;

       //--- Main Loop ------------------------------------------------------
       while(1){
	    BLUE_OFF;
   	    GREEN_OFF;
   	    RED_OFF;
      	    distance = sonar();
    	    LEDColor(distance);
       }
       return 0;
    }

Sonar.S
=======
::

    #include "config.inc"

	    .section    .text
            .global     sonar
	    .org        0x0000

    sonar:
	    ; initialize the CPU clock to run at full speed
	    ldi             r24, 0x80
            sts             CLKPR, r24              ; allow access to clock setup
            sts             CLKPR, r1               ; run at full speed

            sbi             SENSOR_DIR, TRIG_PIN         ; sets pin 3's direction to output => Trig Pin
            cbi             SENSOR_DIR, ECHO_PIN         ; sets pin 2's direction to input  <= Echo Pin
            cbi             SENSOR_PORT, TRIG_PIN        ; sets the output to LOW
    trig:						
            sbi             SENSOR_PORT, TRIG_PIN        ; set Trig Pin to HIGH to send a ultrasonic wave burst
            call            tenMicroDelay                ; HIGH signal must continue for 10 microseconds
            cbi             SENSOR_PORT, TRIG_PIN        ; set the output to LOW after waves are sent
    echo:
            clr             r21                          ; clear counter value
    echowait:
            call            Delay        		 ; giving it time to travel 1cm
            inc             r21                          ; increment counter for each cm
            sbic            SENSOR_PIND, ECHO_PIN	 ; break out of loop if echo received
            rjmp            echowait                     ; otherwise keep waiting for the echo
            clr		    r25			         ; zero out high bits of return register
            mov		    r24, r21                     ; set lower bits to the value of counter
            call            Delay
            ret					         ; return to calling function
    Delay:
            ldi             r18, 2                       ; set outter loop to 2
	    ldi		    r19, 41                      ; set inner loop to 41
    1:      dec		    r19			
	    brne	    1b
	    dec		    r18
	    brne	    1b			
	    ret					         ; return after ~1 cm of travel


    tenMicroDelay:
            ldi             r18, 50                      ; set loop to 50
    1:      dec		    r18			
	    brne	    1b
	    ret					         ; return after 10 microseconds
        
config.inc
==========
::

    #include <avr/io.h>
    #define TRIG_PIN	3
    #define ECHO_PIN	2
    #define SENSOR_DIR      _(DDRD)
    #define SENSOR_PORT     _(PORTD)
    #define SENSOR_PIND	_(PIND)

    // include this line to avoid SFR_REG issues
    #define _(s)    _SFR_IO_ADDR(s)
