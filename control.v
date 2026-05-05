module control(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,

    output reg reg_write,
    output reg mem_read,
    output reg mem_write,
    output reg branch,
    output reg alu_src,
    output reg [3:0] alu_op
);

always @(*) begin
    // default
    reg_write = 0;
    mem_read = 0;
    mem_write = 0;
    branch = 0;
    alu_src = 0;
    alu_op = 4'b0000;

    case (opcode)

        7'b0110011: begin // R-type
            reg_write = 1;
            case ({funct7, funct3})
                10'b0000000_000: alu_op = 4'b0000; // ADD
                10'b0100000_000: alu_op = 4'b0001; // SUB
                10'b0000000_111: alu_op = 4'b0010; // AND
                10'b0000000_110: alu_op = 4'b0011; // OR
                10'b0000000_100: alu_op = 4'b0100; // XOR
                10'b0000000_001: alu_op = 4'b0101; // SLL
                10'b0000000_101: alu_op = 4'b0110; // SRL
                10'b0000000_010: alu_op = 4'b0111; // SLT
            endcase
        end

        7'b0010011: begin // ADDI
            reg_write = 1;
            alu_src = 1;
            alu_op = 4'b0000;
        end

        7'b0000011: begin // LW
            reg_write = 1;
            mem_read = 1;
            alu_src = 1;
            alu_op = 4'b0000;
        end

        7'b0100011: begin // SW
            mem_write = 1;
            alu_src = 1;
            alu_op = 4'b0000;
        end

        7'b1100011: begin // BEQ
            branch = 1;
            alu_op = 4'b0001;
        end
    endcase
end

endmodule