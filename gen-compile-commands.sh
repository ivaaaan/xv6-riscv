#!/bin/sh
# Regenerate compile_commands.json so clangd resolves repo-root-relative
# includes (e.g. #include "kernel/types.h") in user/, kernel/ and mkfs/.
# Re-run after adding new .c files, then restart your LSP.
set -e
cd "$(dirname "$0")"

{
  echo '['
  first=1
  emit() {
    [ $first -eq 0 ] && echo ','
    first=0
    printf '  {\n    "directory": "%s",\n    "file": "%s",\n    "command": "%s"\n  }' "$PWD" "$1" "$2"
  }
  RV='clang --target=riscv64-unknown-elf -march=rv64gc -mcmodel=medany -std=gnu99 -ffreestanding -nostdlib -fno-common -I. -c'
  HOST='clang -I. -c'
  for f in kernel/*.c user/*.c; do emit "$f" "$RV $f"; done
  for f in mkfs/*.c; do emit "$f" "$HOST $f"; done
  echo
  echo ']'
} > compile_commands.json

echo "wrote compile_commands.json ($(grep -c '"file"' compile_commands.json) entries)"
