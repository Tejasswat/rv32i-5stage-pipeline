`timescale 1ns / 1ps

module tb_cpu;

    reg clk;
    reg reset;

    // ===== DUT outputs =====
    wire [31:0] pc_out;
    wire [31:0] if_id_instr;

    // ===== Debug outputs =====
    wire        dbg_wb_reg_write;
    wire [4:0]  dbg_wb_rd;
    wire [31:0] dbg_wb_data;
    wire [31:0] dbg_alu_result;
    wire [31:0] dbg_rs1_val;
    wire [31:0] dbg_rs2_val;

    // ===== DUT =====
    cpu_top dut (
        .clk(clk),
        .reset(reset),

        .pc_out(pc_out),
        .if_id_instr(if_id_instr),

        .dbg_wb_reg_write(dbg_wb_reg_write),
        .dbg_wb_rd       (dbg_wb_rd),
        .dbg_wb_data     (dbg_wb_data),
        .dbg_alu_result  (dbg_alu_result),
        .dbg_rs1_val     (dbg_rs1_val),
        .dbg_rs2_val     (dbg_rs2_val)
    );

    // ===== Clock: 10 ns period =====
    always #5 clk = ~clk;

    // ===== Stimulus =====
    initial begin
        clk   = 0;
        reset = 1;

        #20;
        reset = 0;

        // Let pipeline fill and execute
        #400;

        $stop;
    end

    // ===== Console monitor (optional but useful) =====
    initial begin
        $display("TIME | PC | WB_WE | WB_RD | WB_DATA | ALU_RES | RS1 | RS2");
        $monitor(
            "%4t | %h |   %b   |  %0d  | %h | %h | %h | %h",
            $time,
            pc_out,
            dbg_wb_reg_write,
            dbg_wb_rd,
            dbg_wb_data,
            dbg_alu_result,
            dbg_rs1_val,
            dbg_rs2_val
        );
    end

endmodule
