@echo off

g++ .\Compile\gen.cpp -o .\Compile\gen.exe

@REM thiếu runtime DLL của MinGW/GCC.
g++ .\Compile\convert.cpp -static -o .\Compile\convert.exe

echo Generating assembly...
.\Compile\gen.exe

echo Compiling RISC-V...

D:\risc-v-toolchain\xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-gcc.exe ^
-march=rv32i ^
-mabi=ilp32 ^
-nostdlib ^
-Ttext=0x0 ^
.\Compile\program.s ^
-o .\Compile\program.elf

echo Generating raw mem...

D:\risc-v-toolchain\xpack-riscv-none-elf-gcc-15.2.0-1\bin\riscv-none-elf-objcopy.exe ^
-O verilog ^
.\Compile\program.elf ^
.\Compile\raw.mem

echo Converting mem...
.\Compile\convert.exe

echo Running simulation...

iverilog -o cpu.vvp cpu_tb.v cpu.v alu.v control.v regfile.v imem.v dmem.v 

vvp cpu.vvp 

gtkwave .\dump.vcd 
echo Done.
pause