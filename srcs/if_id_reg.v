module if_id_reg (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] instr_in,
    input  wire [31:0] pc4_in,
    output reg  [31:0] instr_out,
    output reg  [31:0] pc4_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr_out <= 32'b0;
            pc4_out   <= 32'b0;
        end else begin
            instr_out <= instr_in;
            pc4_out   <= pc4_in;
        end
    end

endmodule
