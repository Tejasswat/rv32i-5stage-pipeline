`timescale 1ns / 1ps

module cpu_top (
    input  wire        clk,
    input  wire        reset,
    output wire [31:0] pc_out,
    output wire [31:0] if_id_instr
);

    // Internal wires
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] instr;
    wire [31:0] pc4;
    
    wire [4:0] rs1 = if_id_instr[19:15];
    wire [4:0] rs2 = if_id_instr[24:20];
    wire [4:0] rd  = if_id_instr[11:7];


    // --------------------------------------------------
    // IF STAGE
    // --------------------------------------------------

    // Next PC logic (simple sequential execution)
    assign pc4     = pc + 32'd4;
    assign pc_next = pc4;

    // Program Counter
    pc pc_inst (
        .clk     (clk),
        .reset   (reset),
        .pc_next (pc_next),
        .pc      (pc)
    );

    // Instruction Memory
    instr_mem imem_inst (
        .addr  (pc),
        .instr (instr)
    );

    // --------------------------------------------------
    // IF / ID PIPELINE REGISTER
    // --------------------------------------------------

    if_id_reg if_id_inst (
        .clk       (clk),
        .reset     (reset),
        .instr_in  (instr),
        .pc4_in    (pc4),
        .instr_out (if_id_instr),
        .pc4_out   ()
    );
    
    //---------------------------------------------------
    //ID stage
    //---------------------------------------------------
    wire [31:0] rs1_val;
    wire [31:0] rs2_val;
    // ID/EX pipeline outputs (for debug/visibility)
    wire [31:0] id_ex_rs1;
    wire [31:0] id_ex_rs2;
    wire [4:0]  id_ex_rd;

    wire [31:0] imm;
    
    wire [31:0] id_ex_imm;


    
    regfile rf_inst (
        .clk      (clk),
        .reg_write       (1'b0),      // NO write yet
        .rs1      (rs1),
        .rs2      (rs2),
        .rd       (5'b0),
        .wd       (32'b0),
        .rd1      (rs1_val),
        .rd2      (rs2_val)
    );
    
   id_ex_reg id_ex_inst (
        .clk         (clk),
        .reset       (reset),
        .rs1_val_in  (rs1_val),
        .rs2_val_in  (rs2_val),
        .imm_in      (imm),
        .rd_in       (rd),
        .rs1_val_out (id_ex_rs1),
        .rs2_val_out (id_ex_rs2),
        .imm_out     (id_ex_imm),
        .rd_out      (id_ex_rd)
    );

    
    imm_gen imm_gen_inst (
        .instr (if_id_instr),
        .imm   (imm)
    );  
            
    

    // ===== ID/EX PIPELINE REGISTER (end of ID stage) =====



    // Debug / observation output
    assign pc_out = pc;

endmodule
