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


