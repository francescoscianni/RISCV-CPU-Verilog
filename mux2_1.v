module mux2_1 (
    output reg[31:0]out,
    input [31:0]a,
    input [31:0]b,
    input sel
);
    always@(*)begin
        case (sel)
            1'b0: out = a;
            1'b1: out = b;
            default: out = 32'bz;
        endcase
    end
    
endmodule