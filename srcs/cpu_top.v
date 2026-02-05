`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk,
    input  wire        reset,

    // Existing outputs
    output wire [31:0] pc_out,
    output wire [31:0] if_id_instr,

    // ===== DEBUG OUTPUTS (for verification) =====
    output wire        dbg_wb_reg_write,
    output wire [4:0]  dbg_wb_rd,
    output wire [31:0] dbg_wb_data,
    output wire [31:0] dbg_alu_result,
    output wire [31:0] dbg_rs1_val,
    output wire [31:0] dbg_rs2_val
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

    // ---- WB signals ----
    wire [31:0] wb_data;
    wire [4:0]  wb_rd;
    wire        wb_reg_write;

    regfile rf_inst (
        .clk       (clk),
        .rs1       (rs1),
        .rs2       (rs2),
        .rd        (wb_rd),
        .wd        (wb_data),
        .reg_write (wb_reg_write),
        .rd1       (rs1_val),
        .rd2       (rs2_val)
    );

    wire [31:0] imm;
    imm_gen imm_gen_inst (
        .instr (if_id_instr),
        .imm   (imm)
    );

    // ---- Control ----
    wire alu_src, branch, reg_write;
    wire [1:0] alu_op;

    control control_inst (
        .opcode    (opcode),
        .alu_src   (alu_src),
        .branch    (branch),
        .alu_op    (alu_op),
        .reg_write (reg_write),
        .mem_read  (),
        .mem_write (),
        .mem_to_reg(),
        .jump      ()
    );

    // ==================================================
    // ID / EX
    // ==================================================
    wire [31:0] id_ex_pc, id_ex_rs1, id_ex_rs2, id_ex_imm;
    wire [4:0]  id_ex_rd;
    wire [2:0]  id_ex_funct3;
    wire        id_ex_funct7;
    wire        id_ex_alu_src, id_ex_branch;
    wire [1:0]  id_ex_alu_op;
    wire        id_ex_reg_write;

    id_ex_reg id_ex_inst (
        .clk           (clk),
        .reset         (reset),
        .pc_in         (pc),
        .rs1_val_in    (rs1_val),
        .rs2_val_in    (rs2_val),
        .imm_in        (imm),
        .rd_in         (rd),
        .funct3_in     (funct3),
        .funct7_in     (funct7),
        .alu_src_in    (alu_src),
        .branch_in     (branch),
        .alu_op_in     (alu_op),
        .reg_write_in  (reg_write),

        .pc_out        (id_ex_pc),
        .rs1_val_out   (id_ex_rs1),
        .rs2_val_out   (id_ex_rs2),
        .imm_out       (id_ex_imm),
        .rd_out        (id_ex_rd),
        .funct3_out    (id_ex_funct3),
        .funct7_out    (id_ex_funct7),
        .alu_src_out   (id_ex_alu_src),
        .branch_out    (id_ex_branch),
        .alu_op_out    (id_ex_alu_op),
        .reg_write_out (id_ex_reg_write)
    );

    // ==================================================
    // EX
    // ==================================================
    wire [31:0] alu_in1 = id_ex_rs1;
    wire [31:0] alu_in2 = (id_ex_alu_src) ? id_ex_imm : id_ex_rs2;

    wire [3:0] alu_ctrl;
    alu_control alu_ctrl_inst (
        .alu_op   (id_ex_alu_op),
        .funct3   (id_ex_funct3),
        .funct7   (id_ex_funct7),
        .alu_ctrl (alu_ctrl)
    );

    wire [31:0] alu_result;
    wire        alu_zero;

    alu alu_inst (
        .a        (alu_in1),
        .b        (alu_in2),
        .alu_ctrl (alu_ctrl),
        .result   (alu_result),
        .zero     (alu_zero)
    );

    // ==================================================
    // EX / MEM
    // ==================================================
    wire [31:0] ex_mem_alu_result;
    wire [4:0]  ex_mem_rd;
    wire        ex_mem_reg_write;

    ex_mem_reg ex_mem_inst (
        .clk             (clk),
        .reset           (reset),
        .alu_result_in   (alu_result),
        .rs2_val_in      (id_ex_rs2),
        .rd_in           (id_ex_rd),
        .branch_target_in(32'b0),

        .reg_write_in    (id_ex_reg_write),
        .mem_read_in     (1'b0),
        .mem_write_in    (1'b0),
        .mem_to_reg_in   (1'b0),
        .branch_taken_in (1'b0),

        .alu_result_out  (ex_mem_alu_result),
        .rs2_val_out     (),
        .rd_out          (ex_mem_rd),
        .branch_target_out(),

        .reg_write_out   (ex_mem_reg_write),
        .mem_read_out    (),
        .mem_write_out   (),
        .mem_to_reg_out  (),
        .branch_taken_out()
    );

    // ==================================================
    // MEM / WB
    // ==================================================
    mem_wb_reg mem_wb_inst (
        .clk              (clk),
        .reset            (reset),
        .mem_read_data_in (32'b0),
        .alu_result_in    (ex_mem_alu_result),
        .rd_in            (ex_mem_rd),

        .reg_write_in     (ex_mem_reg_write),
        .mem_to_reg_in    (1'b0),

        .mem_read_data_out(),
        .alu_result_out   (wb_data),
        .rd_out           (wb_rd),
        .reg_write_out    (wb_reg_write),
        .mem_to_reg_out   ()
    );

    // ==================================================
    // DEBUG OUTPUT ASSIGNS
    // ==================================================
    assign pc_out             = pc;
    assign dbg_wb_reg_write   = wb_reg_write;
    assign dbg_wb_rd          = wb_rd;
    assign dbg_wb_data        = wb_data;
    assign dbg_alu_result     = alu_result;
    assign dbg_rs1_val        = rs1_val;
    assign dbg_rs2_val        = rs2_val;

endmodule
