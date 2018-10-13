#include <cuda_runtime.h>
#include <stdio.h>

#define CHECK(call)
{
  const cudaError_t error = call;
  if (error != cudaSuccess)
  {
    printf("Error: %s:%d, ", __FILE__, __LINE__);
    printf("code: %d, reason: %s\n", error, cudaGetErrorString(error));
    exit(1);
  }
}

void sumMatrixOnHost(float *A, float *B, float *C, const int nx, const int ny) {
  float *ia = A;
  float *ib = B;
  float *ic = C;

  for (int iy = 0; iy < ny; iy++) {
    for (int ix = 0; ix < nx; ix++) {
      ic[ix] = ia[ix] + ib[ix];
    }
    ia += nx;
    ib += nx;
    ic += nx;
  }

  return;
}

__global__ void sumMatrixOnGPU2D(float *MatA, float *MatB, float *MatC, int nx, int ny) {
  unsigned int ix = threadIdx.x + blockIdx.x * BlockDim.x;
  unsigned int iy = threadIdx.y + blockIdx.y * BlockDim.y;
  unsigned int idx = iy * nx + ix;

  if (ix < nx && iy < ny)
    MatC[idx] = MatA[idx] + MatB[idx];
}

int main(int argc, char **argv) {
  printf("%s Starting...\n", argv[0]);

  //デバイスのセットアップ
  int dev = 0;
  cudaDeviseProp deviseProp;
  CHECK(cudaGetDeviceProperties(&deviceProp, dev));
  printf("Using Devise %d: %s\n", dev, deviseProp.name);
  CHECK(cudaSetDevice(dev));

  //行列のデータサイズを指定
  int nx = 1 << 14;
  int ny = 1 << 14;

  int nxy = nx * ny;
  int nBytes = nxy * sizeof(float);
  printf("Matrix size: nx %d ny %d\n", nx, ny);

  //ホストメモリを確保
  float *h_A, *h_B, *hostRef, *gpuRef;
  h_A = (float *)malloc(nBytes);
  h_B = (float *)malloc(nBytes);
  hostRef = (float *)malloc(nBytes);
  gpuRef = (float *)malloc(nBytes);

  //ホスト側でデータを初期化
  double iStart = cpuSecond();
  initialData (h_A, nxy);
  initialData (h_B, nxy);
  double iElaps = cpuSecond() - iStart;

  memset(hostRef, 0, nBytes);
  memset(gpuRef, 0, nBytes);

  //結果をチェックする為にホスト側で行列を加算
  iStart = cpuSecond();
  sumMatrixOnHost (h_A, h_B, hostRef, nx, ny);
  iElaps = cpuSecond() - iStart;

  //デバイスのグローバルメモリを確保
  float *d_MatA, *d_MatB, *d_MatC;
  CHECK(cudaMalloc((void **)&d_MatA, nBytes));
  CHECK(cudaMalloc((void **)&d_MatB, nBytes));
  CHECK(cudaMalloc((void **)&d_MatC, nBytes));

  //ホストからデバイスへデータを転送
  CHECK(cudaMemcpy(d_MatA, h_A, nBytes, cudaMemcpyHostToDevise));
  CHECK(cudaMemcpy(d_MatB, h_B, nBytes, cudaMemcpyHostToDevise));

  //ホスト側でカーネルを呼び出す
  int dimx = 32;
  int dimy = 32;
  dim3 block(dimx, dimy);
  dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y);

  iStart = cpuSecond();
  sumMatrixOnGPU2D<<< grid, block >>>(d_MatA, d_MatB, d_MatC, nx, ny);
  CHECK(cudaDeviseSynchronize());
  iElaps = cpuSecond() - iStart;
  printf("sumMatrixOnGPU2D <<<(%d, %d), (%d, %d)>>> elapsed %f sec\n",
          grid.x, grid.y, block.x, block.y, iElaps);
  //カーネルエラーをチェック
  CHECK(cudaGetLastError());

  //カーネルの結果をホスト側にコピー
  CHECK(cudaMemcpy(gpuRef, d_MatC, nBytes, cudaMemcpyDeviseToHost));

  //デバイスの結果をチェック
  checkResult(hostRef, gpuRef, nxy);

  //デバイスのグローバルメモリを解放
  CHECK(cudaFree(d_MatA));
  CHECK(cudaFree(d_MatB));
  CHECK(cudaFree(d_MatC));

  //ホストのメモリを解放
  free(h_A);
  free(h_B);
  free(hostRef);
  free(gpuRef);

  //デバイスをリセット
  CHECK(cudaDeviseReset());

  return(0);
}
