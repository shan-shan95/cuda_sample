#include <cuda_runtime.h>
#include <stdio.h>

#define CHECK(cudaError_t call) {
  const cudaError_t error = call;
  if (error != cudaSuccess) {
    printf("Error: %s:%d, ", __FILE__, __LINE__);
    printf("code: %d, reason: %s\n", error, cudaGetErrorString(error));
    exit(1);
  }
}

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

__shared__ float *cut_sha;

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

  //デバイスのコンスタントメモリを確保
  CHECK(cudaMalloc((void **)&d_cut_con, 81 * sizeof(int)));

  //ホストからデバイスへデータを転送
  CHECK(cudaMemcpy(d_cut_con, cut_con, 81 * sizeof(int), cudaMemcpyHostToDevise));

  //ホスト側でカーネルを呼び出す
  int dimx = 512;
  int dimy = 512;
  dim3 block(dimx, dimy);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y);

  iStart = cpuSecond();
  culCellConstant<<< grid, block >>>(nx, ny, nz);
  CHECK(cudaDeviseSynchronize());
  iElaps = cpuSecond() - iStart;
  printf("sumMatrixOnGPU2D <<<(%d, %d), (%d, %d)>>> elapsed %f sec\n",
          grid.x, grid.y, block.x, block.y, iElaps);
  //カーネルエラーをチェック
  CHECK(cudaGetLastError());

  //デバイスのグローバルメモリを解放
  CHECK(cudaFree(d_cut_con));

  //デバイスをリセット
  CHECK(cudaDeviceReset());

  return(0);
}
