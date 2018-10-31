#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

__shared__ float cut_sha[81];

__global__ void culCellShared(int nx, int ny, int nz) {
  int cut_num;

  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    unsigned int threadId = (threadIdx.z * blockDim.y * blockDim.x + threadIdx.y * blockDim.x + threadIdx.x) % 32;

    if (threadId < 27) {
      if (threadId == 0 || threadId == 2 || threadId == 24 || threadId == 26) {
        unsigned int t = (threadId << 30) >> 30;
        cut_sha[3 * threadId + t] = 5;
        cut_sha[3 * threadId + 1] = 2;
        cut_sha[3 * threadId + 2 - t] = 1;
      } else if (threadId == 1 || threadId == 25) {
        cut_sha[3 * threadId] = 1;
        cut_sha[3 * threadId + 1] = 1;
        cut_sha[3 * threadId + 2] = 1;
      } else if (threadId == 3 || threadId == 5 || threadId == 21 || threadId == 23) {
        unsigned int t = threadId % 3;
        cut_sha[3 * threadId + t] = 2;
        cut_sha[3 * threadId + 1] = 1;
        cut_sha[3 * threadId + 2 - t] = 0;
      } else if (threadId % 3 == 1 ) {
        cut_sha[3 * threadId] = 0;
        cut_sha[3 * threadId + 1] = 0;
        cut_sha[3 * threadId + 2] = 0;
      } else {
        unsigned int t = threadId % 3;
        cut_sha[3 * threadId + t] = 1;
        cut_sha[3 * threadId + 1] = 0;
        cut_sha[3 * threadId + 2 - t] = 0;
      }
      for (int x = 0; x < 81; x++) {
        cut_num = cut_sha[x];
      }
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

  //タイマー開始
  cudaEventCreate(&start);
  cudaEventCreate(&stop);
  cudaEventRecord(start, 0);

  printf("%s Starting...\n", argv[0]);

  //行列のデータサイズを指定
  int nx = 1 << 10;
  int ny = 1 << 10;
  int nz = 1 << 10;

  printf("Matrix size: nx %d ny %d nz %d\n", nx, ny, nz);

  //ホスト側でカーネルを呼び出す
  int dimx = 32;
  int dimy = 32;
  int dimz = 1;
  dim3 block(dimx, dimy, dimz);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y, (nz + block.z - 1) / block.z);
  printf("grid: %d, %d, %d, block: %d, %d, %d\n", grid.x, grid.y, grid.z, block.x, block.y, block.z);

  //シェアドメモリ使用
  for(int i = 0 ; i < 1000 ; i++) {
    culCellShared<<< grid, block >>>(nx, ny, nz);
    cudaDeviceSynchronize();
  }

  //タイマーをストップ
  cudaEventRecord(stop, 0);
  cudaEventSynchronize(stop);
  cudaEventElapsedTime(&elapsed_time_ms, start, stop);
  printf("time: %8.2f ms \n", elapsed_time_ms);
  cudaEventDestroy(start);
  cudaEventDestroy(stop);

  //カーネルエラーをチェック
  cudaGetLastError();

  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
