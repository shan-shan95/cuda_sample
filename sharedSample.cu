#include <cuda_runtime.h>
#include <stdio.h>

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
  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      int cut_num = cut_con[x];
    }
  }
}

int main(int argc, char **argv) {
  printf("%s Starting...\n", argv[0]);

  //行列のデータサイズを指定
  int nx = 1 << 9;
  int ny = 1 << 9;
  int nz = 1 << 9;

  int nxyz = nx * ny * nz;
  int nBytes = nxyz * sizeof(float);
  printf("Matrix size: nx %d ny %d nz %d\n", nx, ny, nz);

  //ホスト側でカーネルを呼び出す
  int dimx = 512;
  int dimy = 512;
  dim3 block(dimx, dimy);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y);

  iStart = cpuSecond();
  culCellConstant<<< grid, block >>>(nx, ny, nz);
  cudaDeviseSynchronize();
  iElaps = cpuSecond() - iStart;
  printf("sumMatrixOnGPU2D <<<(%d, %d), (%d, %d)>>> elapsed %f sec\n",
  grid.x, grid.y, block.x, block.y, iElaps);
  //カーネルエラーをチェック
  cudaGetLastError();

  //デバイスのグローバルメモリを解放
  cudaFree(cut_con);

  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
