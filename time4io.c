#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h"

int getsw(void){
  int x = (PORTD >> 8) & 0x0000000f;
  return x;
}

int getbtns(void){
  int x = (PORTD >> 5) & 0x00000007;
  return x;
}
