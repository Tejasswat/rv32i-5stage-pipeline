`timescale 1ns / 1ps

module mem_wb_reg (
    input  wire        clk,
    input  wire        reset,

    // -------- Data inputs from MEM stage --------
    input  wire [31:0] mem_read_data_in,
    input  wire [31:0] alu_result_in,
    input  wire [4:0]  rd_in,

    // -------- Control inputs from MEM stage --------
    input  wire        reg_write_in,
    input  wire        mem_to_reg_in,

    // -------- Data outputs to WB stage --------
    output reg  [31:0] mem_read_data_out,
    output reg  [31:0] alu_result_out,
    output reg  [4:0]  rd_out,

    // -------- Control outputs to WB stage --------
    output reg        reg_write_out,
    output reg        mem_to_reg_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Data
            mem_read_data_out <= 32'b0;
            alu_result_out    <= 32'b0;
            rd_out            <= 5'b0;

            // Control
            reg_write_out     <= 1'b0;
            mem_to_reg_out    <= 1'b0;
        end else begin
            // Data
            mem_read_data_out <= mem_read_data_in;
            alu_result_out    <= alu_result_in;
            rd_out            <= rd_in;

            // Control
            reg_write_out     <= reg_write_in;
            mem_to_reg_out    <= mem_to_reg_in;
        end
    end

endmodule
