#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/syscall.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if (argc < 2) {
    fprintf(2, "usage: sstat <syscall number>\n");
    exit(1);
  }

  int stat = sstat(atoi(argv[1]));
  printf("stat = %d\n", stat);
  exit(0);
}
