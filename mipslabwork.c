/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog

   Latest update 2015-08-28 by F Lundevall

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int prime = 1234567;
int mytime = 0x0001;
int timeoutcount = 0;
volatile int* porte = (volatile int*) 0xbf886110;   // PORTE, addr: 0xbf886110

char textstring[] = "text, more text, and even more text!";

/* Interrupt Service Routine */
void user_isr(void) {
  timeoutcount++;
  if(timeoutcount == 10) {
    time2string(textstring, mytime);
    display_string(3, textstring);
    display_update();
    tick(&mytime);
    timeoutcount = 0;
  }
  IFSCLR(0) = 0x100;  // reset flag
}

/* Lab-specific initialization goes here */
void labinit( void )
{
  volatile int* trise = (volatile int*) 0xbf886100;// TRISE, addr: 0xbf886100
  *trise = *trise & 0xffffff00;                    // 8 LSBs (1 = input, 0 = output)
  *porte = 0x00000000;                             // initialize the counter to 0

  TRISDSET = 0xfe0;                                // initialize port D so that bits 11 through 5 are set as inputs (TRISxSET only changes 0 to 1)

  /* Timer 2 */
  TMR2 = 0;                                        // reset timer to 0
  PR2 = 0x7a12;                                    // count to 31,250
  T2CONSET = 0x8070;                               // timer start and prescale 1:256

  /* IPC(0..12) - Interrupt Priority Control */
  IPCSET(2) = 0X1c; // 4:2 priority lvl, highest priority atm
  /* IEC(0..2) - Interrupt Enable Control */
  IECSET(0) = 0x100;  // <8> is for timer 2

  enable_interrupt(); // interrupt from labwork.S
  return;
}

/* This function is called repetitively from the main program */
void labwork(void) {
  prime = nextprime(prime);
  display_string(0, itoaconv(prime));
  display_update();
}
