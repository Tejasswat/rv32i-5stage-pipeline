`timescale 1ns / 1ps

module tb_cpu;

    reg clk;
    reg reset;

    // DUT outputs
    wire [31:0] pc_out;
    wire [31:0] if_id_instr;

    // Instantiate DUT
    cpu_top dut (
        .clk        (clk),
        .reset      (reset),
        .pc_out     (pc_out),
        .if_id_instr(if_id_instr)
    );

    // -------------------------------------------------
    // Clock generation: 10 ns period
    // -------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // -------------------------------------------------
    // Reset & simulation control
    // -------------------------------------------------
    initial begin
        reset = 1'b1;
        #20;            // hold reset for 2 cycles
        reset = 1'b0;

        // Let pipeline run for a while
        #300;

        $display("Simulation complete");
        $stop;
    end

endmodule
