module id_ex_reg (
    input  wire        clk,
    input  wire        reset,

    input  wire [31:0] rs1_val_in,
    input  wire [31:0] rs2_val_in,
    input  wire [4:0]  rd_in,

    output reg  [31:0] rs1_val_out,
    output reg  [31:0] rs2_val_out,
    output reg  [4:0]  rd_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            rs1_val_out <= 32'b0;
            rs2_val_out <= 32'b0;
            rd_out      <= 5'b0;
        end else begin
            rs1_val_out <= rs1_val_in;
            rs2_val_out <= rs2_val_in;
            rd_out      <= rd_in;
        end
    end

endmodule
