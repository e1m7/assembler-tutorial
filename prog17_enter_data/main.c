#include <stdio.h>
#include <time.h>

unsigned long int next = 1;

int rand(void) {
  next = next * 1103515245 * 12345;
  return (unsigned int) (next / 65536) % 32768;
}

void srand(unsigned int seed) {
  next = seed;
}

int main(void) {
  srand(time(NULL));          // генерация семени (стартовое число)
  printf("%d\n", rand());     // вызвали функцию
  printf("%d\n", rand());     // вызвали функцию
  printf("%d\n", rand());     // вызвали функцию
  return 0;
}