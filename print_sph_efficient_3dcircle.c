#include <stdio.h>
#define SIZE 12

int main(void) {
	typedef struct point {
		int x;
		int y;
		int z;
	}
	point p[SIZE][SIZE][SIZE];
	int i, j, k;

	for(i=0; i<SIZE; i++) {
		for(j=0; j<SIZE; j++) {
			for(k=0; k<SIZE; k++) {
				p[k][j][i].x = k;
				p[k][j][i].y = j;
				p[k][j][i].z = i;
			}
		}
	}

	for (i = 0; i < SIZE; i++) {
		for (j = 0; j < SIZE; j++) {
			for (k = 0; k < SIZE; k++) {
				// 注目セルとの距離計算
				printf("%f ", p[k][j][i]);
			}
			printf("\n");
		}
	}
}