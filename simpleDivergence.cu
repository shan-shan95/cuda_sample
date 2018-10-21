__global__ void mathKernel1(float *c) {
  int tid =blockIdx.x * blockDim.x + threadIdx.x;
  float ia, ib;
  ia = ib = 0.0f;

  if (tid % 2 == 0) {
    ia = 100.0f;
  } else {
    ib = 200.0f;
  }
  c[tid] = ia + ib;
}

__global__ void mathKernel2(float *c) {
  int tid = blockIdx.x * blockDim.x + threadIdx.x;
  float ia, ib;
  ia = ib = 0.0f;

  if ((tid / wrapSize) % 2 == 0) {
    ia = 100.0f;
  } else {
    ib = 200.0f;
  }
  c[tid] = ia + ib;
}

int main(int argc, char **argv) {
  //デバイスのセットアップ
  int dev = 0;
  cudaDeviceProp deviceProp;
  // 途中
  CHECK(cudaGetDevice)
}
