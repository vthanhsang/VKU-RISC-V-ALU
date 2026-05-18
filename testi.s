.section .text
.globl _start
_start:
    addi x1, x0, -1        # x1 = 0xFFFFFFFF
    andi x2, x1, 0xFF      # x2 = 0x000000FF
    ori  x3, x0, 0x5A      # x3 = 0x5A
    xori x4, x3, 0xFF      # x4 = 0xA5
    slti x5, x1, 0         # x5 = 1 (-1 < 0)
    addi x6, x0, 4
    slli x7, x6, 4         # x7 = 64
    srli x8, x6, 4         # x8 = 0
    nop
