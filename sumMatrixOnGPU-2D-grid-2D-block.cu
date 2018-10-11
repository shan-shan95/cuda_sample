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
  
