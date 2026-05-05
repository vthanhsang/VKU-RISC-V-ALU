# RISC-V-ALU-32-bit
"RISC-V ALU 32bit base on Ibex"
##Run it
iverilog -o cpu.vvp cpu_tb.v cpu.v alu.v control.v regfile.v imem.v dmem.v 
vvp cpu.vvp 
gtkwave .\dump.vcd 