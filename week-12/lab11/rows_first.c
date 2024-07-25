#include <time.h>
#include <stdlib.h>
#include <stdio.h>

int main() {
	int rows = 1000, columns = 1000;
	int matrix[rows][columns];
	srand(time(NULL));
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < columns; j++) {
			matrix[i][j] = rand() % 10;
		}
	}
	
	long sum = 0;
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < columns; j++) {
			sum += matrix[i][j];
		}
	}
	printf("Done.\n");
	
	return 0;
}

