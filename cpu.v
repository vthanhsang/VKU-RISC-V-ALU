module cpu(input clk, input reset);

// ================= PC =================
reg [31:0] pc;
wire [31:0] next_pc;

// ================= IF =================
wire [31:0] instr;
imem imem_inst(pc, instr);

// pipeline register IF/ID
reg [31:0] if_id_instr;
reg [31:0] if_id_pc;

// ================= Decode =================
wire [6:0] opcode = if_id_instr[6:0];
wire [4:0] rd     = if_id_instr[11:7];
wire [2:0] funct3 = if_id_instr[14:12];
wire [4:0] rs1    = if_id_instr[19:15];
wire [4:0] rs2    = if_id_instr[24:20];
wire [6:0] funct7 = if_id_instr[31:25];

// ================= Control =================
wire reg_write, mem_read, mem_write, branch, alu_src;
wire [3:0] alu_op;

control ctrl(
    opcode, funct3, funct7,
    reg_write, mem_read, mem_write,
    branch, alu_src, alu_op
);

// ================= Register File =================
wire [31:0] rd1, rd2;
regfile rf(clk, reg_write, rs1, rs2, rd, write_data, rd1, rd2);

// ================= Immediate =================
wire [31:0] imm = {{20{if_id_instr[31]}}, if_id_instr[31:20]};

// ================= ALU =================
wire [31:0] alu_b = (alu_src) ? imm : rd2;
wire [31:0] alu_result;
wire zero;

alu alu_inst(rd1, alu_b, alu_op, alu_result, zero);

// ================= Data Memory =================
wire [31:0] mem_data;

dmem dmem_inst(clk, mem_read, mem_write, alu_result, rd2, mem_data);

// ================= Writeback =================
wire [31:0] write_data = (mem_read) ? mem_data : alu_result;

// ================= Branch =================
assign next_pc = (branch && zero) ? if_id_pc + imm : pc + 4;

// ================= Sequential =================
always @(posedge clk or posedge reset) begin
    if (reset) begin
        pc <= 0;
        if_id_instr <= 0;
        if_id_pc <= 0;
    end else begin
        // update PC
        pc <= next_pc;

        // pipeline IF/ID
        if_id_instr <= instr;
        if_id_pc <= pc;
    end
end

endmodule