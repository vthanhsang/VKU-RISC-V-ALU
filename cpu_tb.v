module cpu_tb;

reg clk = 0;
reg reset = 1;

cpu uut(clk, reset);

always #5 clk = ~clk;

initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, cpu_tb);
    // $monitor("PC=%d, instr=%h, x1=%d, x2=%d, x3=%d",
    //       uut.pc,
    //       uut.if_id_instr,
    //       uut.rf.regs[1],
    //       uut.rf.regs[2],
    //       uut.rf.regs[3]);
    $monitor("PC=%d | x1=%d x2=%d x3=%d | mem[100]=%d",
    uut.pc,
    uut.rf.regs[1],
    uut.rf.regs[2],
    uut.rf.regs[3],
    uut.dmem_inst.mem[25]   // 100 / 4 = 25
);

    #10 reset = 0;

    #200 $finish;
end

endmodule