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
buzzinit:
        sbi             BUZZ_DIR, BUZZ_PIN      ; buzzer to pin 9
        cbi             BUZZ_PORT, BUZZ_PIN     ; start with buzzer off
echo:
        clr             r21                     ; clear counter value
echowait:
        call            Delay        		; giving it time to travel 1cm
        inc             r21                     ; increment counter for each cm
        sbic            SENSOR_PIND, ECHO_PIN	; break out of loop if echo received
        rjmp            echowait                ; otherwise keep waiting for the echo
        cpi             r21, 5                  ;
        brlt            buzzer                  ;
        clr		r25			; zero out high bits of return register
        mov		r24, r21                ; set lower bits to the value of counter
        call            Delay
        ret					; return to calling function
Delay:
        ldi             r18, 2                  ; set loop to 2
	ldi		r19, 41                 ; set inner loop to 41
1:      dec		r19			
	brne		1b
	dec		r18
	brne		1b			
	ret					; return after ~1 cm of travel


tenMicroDelay:
        ldi             r18, 50                 ; set loop to 50
1:      dec		r18			
	brne		1b
        ret					; return after 10 microseconds
buzzer:
        call toggle
        call buzzDelay
        call toggle
        ret

toggle:
      in              r24, BUZZ_PORT          ; get current bit
      ldi             r25, (1 << BUZZ_PIN)    ; BUZZ PIN 9
      eor             r24, r25                ; flip the bit
      out             BUZZ_PORT, r24      
      ret

buzzDelay:
        ldi            r16, 150
2:      ldi            r17, 150
1:      dec            r16
        brne           1b
        dec            r17
        brne           2b
        ret


