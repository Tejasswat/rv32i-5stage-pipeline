module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7,
    output reg  [3:0] alu_ctrl
);

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = 4'b0010; // ADD (lw, sw)
            2'b01: alu_ctrl = 4'b0110; // SUB (branch)
            2'b10: begin               // R/I-type
                case (funct3)
                    3'b000: alu_ctrl = (funct7) ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b111: alu_ctrl = 4'b0000; // AND
                    3'b110: alu_ctrl = 4'b0001; // OR
                    default: alu_ctrl = 4'b0010;
                endcase
            end
            default: alu_ctrl = 4'b0010;
        endcase
    end

endmodule
