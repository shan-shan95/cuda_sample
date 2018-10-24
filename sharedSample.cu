#include <cuda_runtime.h>
#include <stdio.h>
#include <sys/time.h>

__shared__ float cut_sha[81];

__global__ void culCellConstant(int nx, int ny, int nz) {
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

  int cut_num;

  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      cut_num = cut_con[x];
    }
  }
}

__global__ void culCellShared(int nx, int ny, int nz) {
  int cut_num;

  //実行時間155usほど
  cut_sha[0] = 5;
  cut_sha[1] = 2;
  cut_sha[2] = 1;
  cut_sha[3] = 1;
  cut_sha[4] = 1;
  cut_sha[5] = 1;
  cut_sha[6] = 1;
  cut_sha[7] = 2;
  cut_sha[8] = 5;
  cut_sha[9] = 2;
  cut_sha[10] = 1;
  cut_sha[11] = 0;
  cut_sha[12] = 0;
  cut_sha[13] = 0;
  cut_sha[14] = 0;
  cut_sha[15] = 0;
  cut_sha[16] = 1;
  cut_sha[17] = 2;
  cut_sha[18] = 1;
  cut_sha[19] = 0;
  cut_sha[20] = 0;
  cut_sha[21] = 0;
  cut_sha[22] = 0;
  cut_sha[23] = 0;
  cut_sha[24] = 0;
  cut_sha[25] = 0;
  cut_sha[26] = 1;
  cut_sha[27] = 1;
  cut_sha[28] = 0;
  cut_sha[29] = 0;
  cut_sha[30] = 0;
  cut_sha[31] = 0;
  cut_sha[32] = 0;
  cut_sha[33] = 0;
  cut_sha[34] = 0;
  cut_sha[35] = 1;
  cut_sha[36] = 1;
  cut_sha[37] = 0;
  cut_sha[38] = 0;
  cut_sha[39] = 0;
  cut_sha[40] = 0;
  cut_sha[41] = 0;
  cut_sha[42] = 0;
  cut_sha[43] = 0;
  cut_sha[44] = 1;
  cut_sha[45] = 1;
  cut_sha[46] = 0;
  cut_sha[47] = 0;
  cut_sha[48] = 0;
  cut_sha[49] = 0;
  cut_sha[50] = 0;
  cut_sha[51] = 0;
  cut_sha[52] = 0;
  cut_sha[53] = 1;
  cut_sha[54] = 1;
  cut_sha[55] = 0;
  cut_sha[56] = 0;
  cut_sha[57] = 0;
  cut_sha[58] = 0;
  cut_sha[59] = 0;
  cut_sha[60] = 0;
  cut_sha[61] = 0;
  cut_sha[62] = 1;
  cut_sha[63] = 2;
  cut_sha[64] = 1;
  cut_sha[65] = 0;
  cut_sha[66] = 0;
  cut_sha[67] = 0;
  cut_sha[68] = 0;
  cut_sha[69] = 0;
  cut_sha[70] = 1;
  cut_sha[71] = 2;
  cut_sha[72] = 5;
  cut_sha[73] = 2;
  cut_sha[74] = 1;
  cut_sha[75] = 1;
  cut_sha[76] = 1;
  cut_sha[77] = 1;
  cut_sha[78] = 1;
  cut_sha[79] = 2;
  cut_sha[80] = 5;

  // 実行時間200usほど
  // int threadIdxInWarp = (threadIdx.z * blockDim.y * blockDim.x + threadIdx.y * blockDim.x + threadIdx.x) % 32;
  // switch (threadIdxInWarp){
  //   case 0:
  //     cut_sha[0] = 5;
  //     cut_sha[8] = 5;
  //     break;
  //   case 1:
  //     cut_sha[72] = 5;
  //     cut_sha[80] = 5;
  //     break;
  //   case 2:
  //     cut_sha[1] = 2;
  //     cut_sha[9] = 2;
  //     break;
  //   case 3:
  //     cut_sha[7] = 2;
  //     cut_sha[17] = 2;
  //     break;
  //   case 4:
  //     cut_sha[63] = 2;
  //     cut_sha[73] = 2;
  //     break;
  //   case 5:
  //     cut_sha[71] = 2;
  //     cut_sha[79] = 2;
  //     break;
  //   case 6:
  //     cut_sha[2] = 1;
  //     cut_sha[10] = 1;
  //     cut_sha[18] = 1;
  //     break;
  //   case 7:
  //     cut_sha[6] = 1;
  //     cut_sha[16] = 1;
  //     cut_sha[26] = 1;
  //     break;
  //   case 8:
  //     cut_sha[54] = 1;
  //     cut_sha[64] = 1;
  //     cut_sha[74] = 1;
  //     break;
  //   case 9:
  //     cut_sha[62] = 1;
  //     cut_sha[70] = 1;
  //     cut_sha[78] = 1;
  //     break;
  //   case 10:
  //     cut_sha[3] = 1;
  //     cut_sha[4] = 1;
  //     cut_sha[5] = 1;
  //     break;
  //   case 11:
  //     cut_sha[27] = 1;
  //     cut_sha[36] = 1;
  //     cut_sha[45] = 1;
  //     break;
  //   case 12:
  //     cut_sha[35] = 1;
  //     cut_sha[44] = 1;
  //     cut_sha[53] = 1;
  //     break;
  //   case 13:
  //     cut_sha[75] = 1;
  //     cut_sha[76] = 1;
  //     cut_sha[77] = 1;
  //     break;
  //   default:
  //     cut_sha[11] = 0;
  //     cut_sha[12] = 0;
  //     cut_sha[13] = 0;
  //     cut_sha[14] = 0;
  //     cut_sha[15] = 0;
  //     cut_sha[19] = 0;
  //     cut_sha[20] = 0;
  //     cut_sha[21] = 0;
  //     cut_sha[22] = 0;
  //     cut_sha[23] = 0;
  //     cut_sha[24] = 0;
  //     cut_sha[25] = 0;
  //     cut_sha[28] = 0;
  //     cut_sha[29] = 0;
  //     cut_sha[30] = 0;
  //     cut_sha[31] = 0;
  //     cut_sha[32] = 0;
  //     cut_sha[33] = 0;
  //     cut_sha[34] = 0;
  //     cut_sha[37] = 0;
  //     cut_sha[38] = 0;
  //     cut_sha[39] = 0;
  //     cut_sha[40] = 0;
  //     cut_sha[41] = 0;
  //     cut_sha[42] = 0;
  //     cut_sha[43] = 0;
  //     cut_sha[46] = 0;
  //     cut_sha[47] = 0;
  //     cut_sha[48] = 0;
  //     cut_sha[49] = 0;
  //     cut_sha[50] = 0;
  //     cut_sha[51] = 0;
  //     cut_sha[52] = 0;
  //     cut_sha[55] = 0;
  //     cut_sha[56] = 0;
  //     cut_sha[57] = 0;
  //     cut_sha[58] = 0;
  //     cut_sha[59] = 0;
  //     cut_sha[60] = 0;
  //     cut_sha[61] = 0;
  //     cut_sha[65] = 0;
  //     cut_sha[66] = 0;
  //     cut_sha[67] = 0;
  //     cut_sha[68] = 0;
  //     cut_sha[69] = 0;
  //     break;
  // }

  if (threadIdx.x < nx && threadIdx.y < ny && threadIdx.z < nz) {
    for (int x = 0; x < 81; x++) {
      cut_num = cut_sha[x];
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
  culCellConstant<<< grid, block >>>(nx, ny, nz);
  cudaDeviceSynchronize();

  //シェアドメモリ使用
  culCellShared<<< grid, block >>>(nx, ny, nz);
  cudaDeviceSynchronize();

  //カーネルエラーをチェック
  cudaGetLastError();

  //デバイスのグローバルメモリを解放
  cudaFree(cut_con);

  //デバイスをリセット
  cudaDeviceReset();

  return(0);
}
