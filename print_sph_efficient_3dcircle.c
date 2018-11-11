#include <stdio.h>
#include <math.h>
#define SIZE 13
#define RANGE 4

int p2[SIZE][SIZE][SIZE];

void range(double a, double b, double c)
{
  typedef struct
  {
    double x;
    double y;
    double z;
    int flag;
  } fun_point;
  int i, j, k;
  fun_point fp[SIZE][SIZE][SIZE];

  for (i = 0; i < SIZE; i++)
  {
    for (j = 0; j < SIZE; j++)
    {
      for (k = 0; k < SIZE; k++)
      {
        fp[k][j][i].x = k;
        fp[k][j][i].y = j;
        fp[k][j][i].z = i;
        fp[k][j][i].flag = 0;
      }
    }
  }

  for (i = 0; i < SIZE; i++)
  {
    for (j = 0; j < SIZE; j++)
    {
      for (k = 0; k < SIZE; k++)
      {
        // 注目セルとの距離計算
        if (pow(a - fp[k][j][i].x, 2.0) + pow(b - fp[k][j][i].y, 2.0) + pow(c - fp[k][j][i].z, 2.0) <= RANGE * RANGE)
        {
          fp[k][j][i].flag = 1;
        }
      }
    }
  }

  for (i = 0; i < SIZE; i++)
  {
    for (j = 0; j < SIZE; j++)
    {
      for (k = 0; k < SIZE; k++)
      {
        p2[k][j][i] *= fp[k][j][i].flag;
      }
    }
  }
}

int main(void)
{
  typedef struct
  {
    double x;
    double y;
    double z;
    int flag;
  } point;

  int i, j, k;

  for (i = 0; i < SIZE; i++)
  {
    for (j = 0; j < SIZE; j++)
    {
      for (k = 0; k < SIZE; k++)
      {
        p2[k][j][i] = 1;
      }
    }
  }

  range(4, 5, 5);
  range(4, 6, 5);
  range(4, 5, 6);
  range(4, 6, 6);
  range(8, 5, 5);
  range(8, 6, 5);
  range(8, 5, 6);
  range(8, 6, 6);

  for (i = 0; i < SIZE; i++)
  {
    printf("z=%d\n", i);
    for (j = 0; j < SIZE; j++)
    {
      for (k = 0; k < SIZE; k++)
      {
        printf("%d ", p2[k][j][i]);
      }
      printf("\n");
    }
    printf("\n\n\n\n");
  }

  return 0;
}