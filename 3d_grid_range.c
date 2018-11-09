#include <stdio.h>
#define SIZE 12

int main(void) {
	FILE *gp;
	int i, j;
	typedef struct {
		double x;
		double y;
	} plot;
	plot p[SIZE][SIZE];

	for(i=0; i<SIZE; i++) {
		for(j=0; j<SIZE; j++) {
			p[i][j].x = i;
			p[i][j].y = j;
		}
	}

	gp = popen("gnuplot -persist", "w");
	fprintf(gp, "set size square\n");
	fprintf(gp, "set xrange [0:12]\n");
	fprintf(gp, "set yrange [0:12]\n");
	fprintf(gp, "set urange [0:2*pi]\n");
	fprintf(gp, "set vrange [0:2*pi]\n");
	fprintf(gp, "set ticslevel 0\n");
	fprintf(gp, "set xtics 1\n");
	fprintf(gp, "set ytics 1\n");
	fprintf(gp, "set grid\n");
	fprintf(gp, "set arrow from 4, 0 to 4, 12 nohead\n");
	fprintf(gp, "set arrow from 8, 0 to 8, 12 nohead\n");
	fprintf(gp, "set arrow from 0, 4 to 12, 4 nohead\n");
	fprintf(gp, "set arrow from 0, 8 to 12, 8 nohead\n");
	fprintf(gp, "set parametric\n");
	// fprintf(gp, "plot [0:2*pi] cos(t),sin(t)\n");
	fprintf(gp, "splot 4*cos(u)*cos(v)+6 ,4*sin(u)*cos(v)+6, sin(v) title \"grid-range\"\n");

	for(i=0; i<SIZE; i++) {
		for(j=0; j<SIZE; j++) {
			fprintf(gp, "%f,\t%f\n", p[i][j].x, p[i][j].y);
		}
	}
	fprintf(gp, "e\n");

	pclose(gp);

	return 0;
}