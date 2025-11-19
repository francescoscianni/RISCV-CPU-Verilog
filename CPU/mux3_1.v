module mux3_1 (
    output reg[31:0]out,
    input [31:0]a,
    input [31:0]b,
    input [31:0]c,
    input [1:0]sel
);
    always@(*)begin
        case(sel)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            default: out = 31'd0;
        endcase
    end
endmodule