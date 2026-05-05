# RISC-V-ALU-32-bit
RISC-V ALU 32bit base on Ibex and in this project i use 2 main tool is Icarus-Verilog and GTKwave


## Run it
```bash
git clone https://github.com/vthanhsang/VKU-RISC-V-ALU.git

iverilog -o cpu.vvp cpu_tb.v cpu.v alu.v control.v regfile.v imem.v dmem.v 

vvp cpu.vvp 

gtkwave .\dump.vcd 
