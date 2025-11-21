module regnbit #(parameter N = 32)(
    output reg [N-1:0] dataOut,
    input clk,
    input [N-1:0] dataIn,
    input en,
    input reset
);
    always @(posedge clk) begin
        if (reset)
            dataOut <= 0;
        else if (en)
            dataOut <= dataIn;
    end
endmodule

module pc_reg #(parameter N = 32)(
    output reg [N-1:0] dataOut,
    input clk,
    input [N-1:0] dataIn,
    input en,
    input reset
);
    always @(posedge clk) begin
        if (reset)
            dataOut <= 32'h00000010;  //Program Counter starting value: 0b0001_0000 = 16
        else if (en)
            dataOut <= dataIn;
    end
endmodule
