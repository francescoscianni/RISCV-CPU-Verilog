module extend (
    input [31:0] instr,
    input [1:0] ImmSrc,
    output reg [31:0] extended
);

always @(*) begin
    case (ImmSrc)
        2'b00: // I-type
            extended = {{20{instr[31]}}, instr[31:20]};
        2'b01: // S-type
            extended = {{20{instr[31]}}, instr[31:25], instr[11:7]};
        2'b10: // B-type
            extended = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};
        2'b11: // J-type
            extended = {{11{instr[31]}}, instr[31], instr[19:12], instr[20], instr[30:21], 1'b0};
        default:
            extended = 32'b0;
    endcase
end

endmodule
