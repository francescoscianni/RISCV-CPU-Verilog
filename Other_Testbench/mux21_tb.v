module mux_tb();
    reg[15:0] a;
    reg[15:0] b;
    reg sel;
    wire[15:0] out;

    mux2_1 dut(out, a,b,sel);

    initial begin
        $dumpfile("mux_tb.vcd");
        $dumpvars(0, mux_tb);
        a=16'd20;
        b=16'd30;
        sel=1'b0;
        #5
        sel=1'b1;
        #5;
        $finish;
    end

endmodule