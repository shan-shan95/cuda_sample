#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

__global__ void culCellResister(int nx, int ny, int nz) {
  int cut_num;

  //実行時間155usほど。つまりシェアドメモリそのままと変わらない
  int cut_res[81] = {
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
      cut_num = cut_res[x];
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

  //レジスタ使用
  culCellResister<<< grid, block >>>(nx, ny, nz);
  cudaDeviceSynchronize();

  //カーネルエラーをチェック
  cudaGetLastError();
  
  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
