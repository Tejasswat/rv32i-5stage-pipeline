// regfile.v
`timescale 1ns / 1ps

module regfile(
    input  wire        clk,

    // Read ports
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    output wire [31:0] rd1,
    output wire [31:0] rd2,

    // Write port
    input  wire [4:0]  rd,
    input  wire [31:0] wd,

    // Write enable (support both names)
    input  wire        reg_write
);

    // Register file storage (x0-x31)
    reg [31:0] regs [0:31];

    // Initialize registers to zero (simulation-friendly)
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'd0;
    end

    // Asynchronous read
    assign rd1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign rd2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    // Synchronous write (x0 is hardwired to zero)
    always @(posedge clk) begin
        if (reg_write && rd != 5'd0)
            regs[rd] <= wd;
    end

endmodule
