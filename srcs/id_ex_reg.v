`timescale 1ns / 1ps

module id_ex_reg (
    input  wire        clk,
    input  wire        reset,

    // =====================
    // Data inputs
    // =====================
    input  wire [31:0] pc_in,
    input  wire [31:0] rs1_val_in,
    input  wire [31:0] rs2_val_in,
    input  wire [31:0] imm_in,
    input  wire [4:0]  rd_in,
    input  wire [2:0]  funct3_in,
    input  wire        funct7_in,

    // =====================
    // Control inputs
    // =====================
    input  wire        alu_src_in,
    input  wire        branch_in,
    input  wire [1:0]  alu_op_in,
    input  wire        reg_write_in,   // NEW

    // =====================
    // Data outputs
    // =====================
    output reg  [31:0] pc_out,
    output reg  [31:0] rs1_val_out,
    output reg  [31:0] rs2_val_out,
    output reg  [31:0] imm_out,
    output reg  [4:0]  rd_out,
    output reg  [2:0]  funct3_out,
    output reg         funct7_out,

    // =====================
    // Control outputs
    // =====================
    output reg        alu_src_out,
    output reg        branch_out,
    output reg [1:0]  alu_op_out,
    output reg        reg_write_out     // NEW
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Data
            pc_out        <= 32'b0;
            rs1_val_out   <= 32'b0;
            rs2_val_out   <= 32'b0;
            imm_out       <= 32'b0;
            rd_out        <= 5'b0;
            funct3_out    <= 3'b0;
            funct7_out    <= 1'b0;

            // Control
            alu_src_out   <= 1'b0;
            branch_out    <= 1'b0;
            alu_op_out    <= 2'b00;
            reg_write_out <= 1'b0;
        end else begin
            // Data
            pc_out        <= pc_in;
            rs1_val_out   <= rs1_val_in;
            rs2_val_out   <= rs2_val_in;
            imm_out       <= imm_in;
            rd_out        <= rd_in;
            funct3_out    <= funct3_in;
            funct7_out    <= funct7_in;

            // Control
            alu_src_out   <= alu_src_in;
            branch_out    <= branch_in;
            alu_op_out    <= alu_op_in;
            reg_write_out <= reg_write_in;
        end
    end

endmodule
