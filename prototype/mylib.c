#include "math.h"
#include "mylib.h"
#include "stdio.h"

double mysqrt(double x)
{
  return sqrt(x);
}

int main(void)
{
  printf("%f\n", mysqrt(2));
  return 0;
}
