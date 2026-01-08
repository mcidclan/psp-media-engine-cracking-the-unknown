#include <stdio.h>

#include <pspdebug.h>
#include <psppower.h>
#include <pspctrl.h>
#include <pspdisplay.h>
#include <pspsdk.h>
#include <pspkernel.h>

#define DISABLE_VME_MINIMAL_CONFIG 1
#include <me-core-mapper/me-core.h>
extern u32Me SC_HW_RESET;

PSP_MODULE_INFO("edram-dump", 0, 1, 1);
PSP_HEAP_SIZE_KB(-1024);
PSP_MAIN_THREAD_ATTR(PSP_THREAD_ATTR_VFPU | PSP_THREAD_ATTR_USER);

meLibSetSharedUncached32(4);
#define meDumped            (meLibSharedMemory[0])

#define DUMP_SIZE 0xc0000
static volatile void* dump = nullptr;

__attribute__((noinline, aligned(4)))
void meLibOnProcess(void) {
  meCoreDcacheWritebackInvalidateAll();
  
  {
    meLibDelayPipeline();
  } while(!meDumped);
  
  meCoreMemcpy((void*)dump, (void*)0x40340000, DUMP_SIZE);
  meCoreDcacheWritebackRange((void*)dump, (DUMP_SIZE + 63) & ~63);
  meDumped = 2;
  
  meLibHalt();
}

void writeDump(void *data, u32 size, const char *filename) {
  FILE *f = fopen(filename, "wb");
  fwrite(data, 1, size, f);
  fclose(f);
}

int main() {
  dump = memalign(16, DUMP_SIZE);
  sceKernelDcacheWritebackRange((void*)&dump, (4 + 63) & ~63);
  
  // SC_HW_RESET = 0x4;
  meLibDefaultInit();
  
  pspDebugScreenInit();
  SceCtrlData ctl;
  do {
    sceCtrlPeekBufferPositive(&ctl, 1);
    
    if ((ctl.Buttons & PSP_CTRL_TRIANGLE) && !meDumped) {
      meDumped = 1;
    }
    
    const char* status = meDumped != 0 ? (meDumped >= 2 ? "Done" : "Started") : "...";
    
    pspDebugScreenSetXY(1, 1);
    pspDebugScreenPrintf("Dumped %s          \n", status);
    
    if (meDumped == 2) {
      sceKernelDcacheInvalidateRange((void*)dump, (DUMP_SIZE + 63) & ~63);
      writeDump((void*)dump, DUMP_SIZE, "./edram.bin");
      meDumped = 3;
    }
    
    sceDisplayWaitVblank();
    
  } while (!(ctl.Buttons & PSP_CTRL_HOME));

  sceKernelExitGame();
  return 0;
}
