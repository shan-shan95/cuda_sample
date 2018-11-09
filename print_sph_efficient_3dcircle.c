#include <stdio.h>
#define SIZE 13

int main(void) {
	typedef struct {
		double x;
		double y;
		double z;
	} point;
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
				printf("(%2d, %2d, %2d) ", (int)p[k][j][i].x, (int)p[k][j][i].y, (int)p[k][j][i].z);
			}
			printf("\n");
		}
	}
}