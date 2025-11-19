module ram #(parameter RAM_DEPTH = 256)(
    output wire [31:0] dataOut,
    input [31:0] dataIn,
    input [31:0] addr,
    input clk,
    input cs,
    input oe,
    input we
);
    reg [31:0] mem [0:RAM_DEPTH-1];

    always @(posedge clk) begin
        if (cs && we)
            mem[addr] <= dataIn;
    end

    assign dataOut = (cs && oe && !we) ? mem[addr] : 32'bz;
endmodule
