# RISC-V-ALU-32-bit
RISC-V ALU 32bit base on Ibex and in this project i use 2 main tool is Icarus-Verilog and GTKwave


## Run it
```bash
git clone https://github.com/vthanhsang/VKU-RISC-V-ALU.git

iverilog -o cpu.vvp cpu_tb.v cpu.v alu.v control.v regfile.v imem.v dmem.v 

vvp cpu.vvp 

gtkwave .\dump.vcd 
```
## Requirement

link tool compile: https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases?utm_source=chatgpt.com

## Flow
text.txt
    ↓ 
  c++
    ↓ g++
program.s
    ↓ gcc
program.elf
    ↓ objcopy
program.mem
    ↓ $readmemh
instruction memory

D:\risc-v-toolchain\xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-gcc.exe --version