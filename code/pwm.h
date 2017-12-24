#ifndef PWM_H
#define PWM_H

#define POLL_TIMEOUT (3 * 1000) /* 3 seconds */
#define MAX_BUF 64

int pwm_export(void);
int pwm_unexport(void);
void pwm_polarity(void);
int pwm_start(void);
int pwm_stop(void);
unsigned long int pwm_period(unsigned long int period);
unsigned long int pwm_duty(unsigned long int duty);

#endif /* PWM_H */
