
#include <avr/io.h>
#include <util/delay.h>



/************************************************************************/
/*                           Defining Constants                         */
/************************************************************************/



//--- PIN Assignments ----------------------------------------------------
#define RED_PIN             1
#define GREEN_PIN           2
#define BLUE_PIN            3


//--- PIN Controls -------------------------------------------------------
#define RED_ON              (PORTB |= (1<<RED_PIN))
#define RED_OFF             (PORTB &= ~(1<<RED_PIN))
#define GREEN_ON            (PORTB |= (1<<GREEN_PIN))
#define GREEN_OFF           (PORTB &= ~(1<<GREEN_PIN))
#define YELLOW_ON           (PORTB |= (1<<RED_PIN) | (1<<GREEN_PIN))
#define YELLOW_OFF          (PORTB &= (0x01))


//--- Device Setup -------------------------------------------------------
#define OUTPUT_CONFIG       (DDRB |= (1<<RED_PIN) | (1<<GREEN_PIN))
#define CPU_PRESCALE(n)     (CLKPR = 0x80, CLKPR = (n))


//--- LED ----------------------------------------------------------------
void LEDColor(int distance) {
   YELLOW_OFF;



   if (distance >= 4) {
       RED_ON;
   }
   else if (distance >= 2) {
       YELLOW_ON;
   }
	else {
       GREEN_ON;
   }
}



/************************************************************************/
/*                           MAIN function                              */
/************************************************************************/



int main(void) {
   //--- Setup ----------------------------------------------------------
   int distance;
   OUTPUT_CONFIG;
  
   // Set Timer/Counter to proper speed for buzzer
   TIMSK0 = 0;
   TCCR0B = 2;



   //--- Main Loop ------------------------------------------------------
   while(1){
       distance = sonar();
       LEDColor(distance);
   }
   return 0;
}



