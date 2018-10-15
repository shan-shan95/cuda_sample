#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

__constant__ int cut_con[81] = {
  5,2,1,1,1,1,1,2,5,
  2,1,0,0,0,0,0,1,2,
  1,0,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,0,1,
  1,0,0,0,0,0,0,0,1,
  2,1,0,0,0,0,0,1,2,
  5,2,1,1,1,1,1,2,5
};

double cpuSecond() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  return ((double)tp.tv_sec + (double)tp.tv_usec * 1.e-6);
}

__global__ void culCellConstant(int nx, int ny, int nz) {
  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      int cut_num = cut_con[x];
    }
  }
}

__global__ void culCellShared(int nx, int ny, int nz) {
  __shared__ int cut_sha[81] = {
    5,2,1,1,1,1,1,2,5,
    2,1,0,0,0,0,0,1,2,
    1,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,1,
    1,0,0,0,0,0,0,0,1,
    2,1,0,0,0,0,0,1,2,
    5,2,1,1,1,1,1,2,5
  };

  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      int cut_num = cut_sha[x];
    }
  }
}

int main(int argc, char **argv) {
  printf("%s Starting...\n", argv[0]);

  //行列のデータサイズを指定
  int nx = 1 << 10;
  int ny = 1 << 10;
  int nz = 1 << 10;

  int nxyz = nx * ny * nz;
  printf("Matrix size: nx %d ny %d nz %d\n", nx, ny, nz);

  //ホスト側でカーネルを呼び出す
  int dimx = 32;
  int dimy = 32;
  dim3 block(dimx, dimy);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y);

  //コンスタントメモリ使用
  double iStart = cpuSecond();
  culCellConstant<<< grid, block >>>(nx, ny, nz);
  cudaDeviceSynchronize();
  double iElaps = cpuSecond() - iStart;
  printf("culCellConstant <<<(%d, %d), (%d, %d)>>> elapsed %f sec\n",
  grid.x, grid.y, block.x, block.y, iElaps);

  //シェアドメモリ使用
  double iStart2 = cpuSecond();
  culCellShared<<< grid, block >>>(nx, ny, nz);
  cudaDeviceSynchronize();
  double iElaps2 = cpuSecond() - iStart2;
  printf("culCellShared <<<(%d, %d), (%d, %d)>>> elapsed %f sec\n",
  grid.x, grid.y, block.x, block.y, iElaps2);

  //カーネルエラーをチェック
  cudaGetLastError();

  //デバイスのグローバルメモリを解放
  cudaFree(cut_con);

  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
