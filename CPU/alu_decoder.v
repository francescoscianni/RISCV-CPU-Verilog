module alu_decoder (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input       funct7_5,
    output reg [2:0] ALUControl
);
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 3'b000; // ADD
            2'b01: ALUControl = 3'b001; // SUB (per branch)
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl = funct7_5 ? 3'b001 : 3'b000; // SUB/ADD
                    3'b111: ALUControl = 3'b111; // AND
                    3'b110: ALUControl = 3'b110; // OR
                    3'b100: ALUControl = 3'b100; // XOR
                    3'b010: ALUControl = 3'b011; // SLT
                    3'b001: ALUControl = 3'b010; // SLL
                    3'b101: ALUControl = 3'b101; // SRL
                    default: ALUControl = 3'b000;
                endcase
            end
            default: ALUControl = 3'b000;
        endcase
    end
endmodule
