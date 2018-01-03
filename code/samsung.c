#include "pwm.h"
#include <signal.h>

#define PERIOD 26385

void mark(int us);
void space(int us);

void turn_On_Off() 
{
	int i,j;
	char *stream = "1111000001110000001000000101111110";

	pwm_export();
	pwm_polarity();
	pwm_stop(); //force PWM to be turned off before start

	pwm_period(PERIOD);

	pwm_start(); //Turn PWM on

	for(j=0; j<1; j++) {
		mark(4500);
		space(4500);
		for(i=1; i<34; i++) {
			mark(560);
			if(stream[i]=='1') {
				space(1690);
			} else {
				space(560);
			}
		}
		usleep(200000); //200ms, since signal lasts 108ms
	}

	sleep(0.5);
	pwm_duty(0);
	pwm_stop();
}


void increase_volume(){

	int i,j;
	char *stream = ""1111000001110000011100000000111110";

	pwm_export();
	pwm_polarity();
	pwm_stop(); //force PWM to be turned off before start

	pwm_period(PERIOD);

	pwm_start(); //Turn PWM on

	for(j=0; j<6; j++) {
		mark(4500);
		space(4500);
		for(i=1; i<34; i++) {
			mark(560);
			if(stream[i]=='1') {
				space(1690);
			} else {
				space(560);
			}
		}
		usleep(200000); //200ms, since signal lasts 108ms
	}

	sleep(0.5);
	pwm_duty(0);
	pwm_stop();

}

void decrease_volume(){

	int i,j;
	char *stream = "1111000001110000011010000001011110";

	pwm_export();
	pwm_polarity();
	pwm_stop(); //force PWM to be turned off before start

	pwm_period(PERIOD);

	pwm_start(); //Turn PWM on

	for(j=0; j<6; j++) {
		mark(4500);
		space(4500);
		for(i=1; i<34; i++) {
			mark(560);
			if(stream[i]=='1') {
				space(1690);
			} else {
				space(560);
			}
		}
		usleep(200000); //200ms, since signal lasts 108ms
	}

	sleep(0.5);
	pwm_duty(0);
	pwm_stop();

}

void next_channel(){

	int i,j;
	char *stream = "1111000001110000001001000101101110";

	pwm_export();
	pwm_polarity();
	pwm_stop(); //force PWM to be turned off before start

	pwm_period(PERIOD);

	pwm_start(); //Turn PWM on

	for(j=0; j<6; j++) {
		mark(4500);
		space(4500);
		for(i=1; i<34; i++) {
			mark(560);
			if(stream[i]=='1') {
				space(1690);
			} else {
				space(560);
			}
		}
		usleep(200000); //200ms, since signal lasts 108ms
	}

	sleep(0.5);
	pwm_duty(0);
	pwm_stop();

}

void previous_channel(){

	int i,j;
	char *stream = "1111000001110000000001000111101110";

	pwm_export();
	pwm_polarity();
	pwm_stop(); //force PWM to be turned off before start

	pwm_period(PERIOD);

	pwm_start(); //Turn PWM on

	for(j=0; j<6; j++) {
		mark(4500);
		space(4500);
		for(i=1; i<34; i++) {
			mark(560);
			if(stream[i]=='1') {
				space(1690);
			} else {
				space(560);
			}
		}
		usleep(200000); //200ms, since signal lasts 108ms
	}

	sleep(0.5);
	pwm_duty(0);
	pwm_stop();
}





void mark(int us) {
	pwm_duty(PERIOD/3); //set duty period to 1/3 of the PWM period <-> 33%
	usleep(us-150);
}

void space(int us) {
	pwm_duty(PERIOD); //set duty period to 1/1 of the PWM period <-> 100% 
	usleep(us-150);
}
