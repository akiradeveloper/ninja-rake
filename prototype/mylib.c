#include <stdio.h>
#include <math.h>

#include "mylib.h"

double mysqrt(double x)
{
  return sqrt(x);
}

int main(void)
{
  printf("%f\n", mysqrt(2));
  return 0;
}
