module regfile (
    output [31:0] rd1, rd2,
    input  [4:0] ra1, ra2,
    input  [4:0] wa,
    input        we,
    input  [31:0] wd,
    input        clk
);
    reg [31:0] regs [0:31];

    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

    always @(posedge clk) begin
        if (we && wa != 5'd0)
            regs[wa] <= wd;
    end

    initial begin
        regs[0] = 32'd0;
    end
endmodule
