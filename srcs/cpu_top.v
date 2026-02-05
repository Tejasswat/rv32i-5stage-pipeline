`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc_out,
    output wire [31:0] if_id_instr
);

    // ==================================================
    // IF STAGE
    // ==================================================
    wire [31:0] pc, pc_next, pc4, instr;

    assign pc4     = pc + 32'd4;
    assign pc_next = pc4;

    pc pc_inst (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc      (pc)
    );

    instr_mem imem_inst (
        .addr  (pc),
        .instr (instr)
    );

    // ==================================================
    // IF / ID
    // ==================================================
    if_id_reg if_id_inst (
        .clk       (clk),
        .reset     (reset),
        .instr_in  (instr),
        .pc4_in    (pc4),
        .instr_out (if_id_instr),
        .pc4_out   ()
    );

    // ==================================================
    // ID STAGE
    // ==================================================
    wire [4:0] rs1    = if_id_instr[19:15];
    wire [4:0] rs2    = if_id_instr[24:20];
    wire [4:0] rd     = if_id_instr[11:7];
    wire [6:0] opcode = if_id_instr[6:0];
    wire [2:0] funct3 = if_id_instr[14:12];
    wire       funct7 = if_id_instr[30];

    wire [31:0] rs1_val, rs2_val;

    regfile rf_inst (
        .clk       (clk),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (5'b0),
        .wd        (32'b0),
        .reg_write (1'b0),
        .rd1       (rs1_val),
        .rd2       (rs2_val)
    );

    wire [31:0] imm;
    imm_gen imm_gen_inst (
        .instr (if_id_instr),
        .imm   (imm)
    );

    wire alu_src, branch;
    wire [1:0] alu_op;

    control control_inst (
        .opcode    (opcode),
        .alu_src   (alu_src),
        .branch    (branch),
        .alu_op    (alu_op),
        .reg_write (),
        .mem_read  (),
        .mem_write (),
        .mem_to_reg(),
        .jump      ()
    );

    // ==================================================
    // ID / EX PIPELINE REGISTER
    // ==================================================
    wire [31:0] id_ex_pc, id_ex_rs1, id_ex_rs2, id_ex_imm;
    wire [4:0]  id_ex_rd;
    wire [2:0]  id_ex_funct3;
    wire        id_ex_funct7;
    wire        id_ex_alu_src, id_ex_branch;
    wire [1:0]  id_ex_alu_op;

    id_ex_reg id_ex_inst (
        .clk        (clk),
        .reset      (reset),

        .pc_in      (pc),
        .rs1_val_in (rs1_val),
        .rs2_val_in (rs2_val),
        .imm_in     (imm),
        .rd_in      (rd),
        .funct3_in  (funct3),
        .funct7_in  (funct7),

        .alu_src_in (alu_src),
        .branch_in  (branch),
        .alu_op_in  (alu_op),

        .pc_out     (id_ex_pc),
        .rs1_val_out(id_ex_rs1),
        .rs2_val_out(id_ex_rs2),
        .imm_out    (id_ex_imm),
        .rd_out     (id_ex_rd),
        .funct3_out (id_ex_funct3),
        .funct7_out (id_ex_funct7),

        .alu_src_out(id_ex_alu_src),
        .branch_out (id_ex_branch),
        .alu_op_out (id_ex_alu_op)
    );

    // ==================================================
    // EX STAGE (FINISHED)
    // ==================================================

    // Operand selection
    wire [31:0] alu_in1 = id_ex_rs1;
    wire [31:0] al
