
#include <stdio.h>
#include <stdint.h>

#define SIZE 5

// Функция сортировки массива
void bubble_sort(uint8_t * array, size_t size) {
	uint8_t temp;
	for (size_t i = 0; i < size; ++i) {
		for (size_t j = 0; j < size - i - 1; ++j) {
			// Если первый элемент > второго элемента, то поменять их местами
			if (array[j] > array[j+1]) {
				temp = array[j+1];					// сохраним второй элемент
				array[j+1] = array[j];			// второй = первый
				array[j] = temp;						// первый = второй
			}
		}
		// Упрощение: если не было обмена, то сортивка окончена
	}
}

// Функция вывода массива на экран
void print_bytes(uint8_t * array, size_t size) {
	printf("[ ");
	for (size_t i = 0; i < size; ++i) {
		printf("%d ", array[i]);
	}
	printf("]\n");
}

// Основная функция
int main(void) {
	uint8_t array[SIZE] = { 5, 4, 3, 2, 1 };
	print_bytes(array, SIZE);
	bubble_sort(array, SIZE);
	print_bytes(array, SIZE);
	return 0;
}