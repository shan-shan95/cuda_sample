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

__global__ void culCellConstant(int nx, int ny, int nz) {

  int cut_num;

  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      cut_num = cut_con[x];
    }
  }
}

double cpuSecond() {
  struct timeval tp;
  gettimeofday(&tp, NULL);
  return ((double)tp.tv_sec + (double)tp.tv_usec * 1.e-6);
}

int main(int argc, char **argv) {
  cudaEvent_t start, stop;
  float elapsed_time_ms;

  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  printf("%s Starting...\n", argv[0]);

  //行列のデータサイズを指定
  int nx = 1 << 7;
  int ny = 1 << 7;
  int nz = 1 << 7;

  printf("Matrix size: nx %d ny %d nz %d\n", nx, ny, nz);

  //ホスト側でカーネルを呼び出す
  int dimx = 128;
  int dimy = 128;
  int dimz = 1;
  dim3 block(dimx, dimy, dimz);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y, (nz + block.z - 1) / block.z);
  printf("grid: %d, %d, %d, block: %d, %d, %d\n", grid.x, grid.y, grid.z, block.x, block.y, block.z);


  //コンスタントメモリ使用
  cudaEventRecord(start, 0);
  culCellConstant<<< grid, block >>>(nx, ny, nz);
  cudaEventRecord(stop, 0);
  cudaDeviceSynchronize();
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsed_time_ms, start, stop);
  printf("time: %8.2f ms \n", elapsed_time_ms);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  //カーネルエラーをチェック
  cudaGetLastError();

  //デバイスのグローバルメモリを解放
  cudaFree(cut_con);

  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
