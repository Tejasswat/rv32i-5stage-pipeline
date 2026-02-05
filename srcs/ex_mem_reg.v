`timescale 1ns / 1ps

module ex_mem_reg (
    input  wire        clk,
    input  wire        reset,

    // -------- Data inputs from EX stage --------
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_val_in,
    input  wire [4:0]  rd_in,
    input  wire [31:0] branch_target_in,

    // -------- Control inputs from EX stage --------
    input  wire        reg_write_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire        mem_to_reg_in,
    input  wire        branch_taken_in,

    // -------- Data outputs to MEM stage --------
    output reg  [31:0] alu_result_out,
    output reg  [31:0] rs2_val_out,
    output reg  [4:0]  rd_out,
    output reg  [31:0] branch_target_out,

    // -------- Control outputs to MEM stage --------
    output reg        reg_write_out,
    output reg        mem_read_out,
    output reg        mem_write_out,
    output reg        mem_to_reg_out,
    output reg        branch_taken_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Data
            alu_result_out    <= 32'b0;
            rs2_val_out       <= 32'b0;
            rd_out            <= 5'b0;
            branch_target_out <= 32'b0;

            // Control
            reg_write_out     <= 1'b0;
            mem_read_out      <= 1'b0;
            mem_write_out     <= 1'b0;
            mem_to_reg_out    <= 1'b0;
            branch_taken_out  <= 1'b0;
        end else begin
            // Data
            alu_result_out    <= alu_result_in;
            rs2_val_out       <= rs2_val_in;
            rd_out            <= rd_in;
            branch_target_out <= branch_target_in;

            // Control
            reg_write_out     <= reg_write_in;
            mem_read_out      <= mem_read_in;
            mem_write_out     <= mem_write_in;
            mem_to_reg_out    <= mem_to_reg_in;
            branch_taken_out  <= branch_taken_in;
        end
    end

endmodule
