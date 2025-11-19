`timescale 1ns/1ps

module alu8bit_tb ();
    reg [7:0]a;
    reg [7:0]b;
    reg [1:0]op;
    reg ci;
    wire [7:0]r;
    wire co;

    alu8bit alu(.res(r), .cout(co), .in1(a), .in2(b), .opSel(op), .cin(ci));

    initial begin
        $monitor("[%0t ns] a=%b b=%b op=%b cin=%b | res=%b cout=%b", $time, a, b, op, ci, r, co);
        $dumpfile("dump.vcd");
        $dumpvars(0, alu8bit_tb);
        
        //Somma
        a=8'b1010_1010;
        b=8'b0000_0001;
        op=2'b00;
        ci=1'b0;
        #10;

        //Differenza
        a=8'b1010_1010;
        b=8'b0000_0001;
        op=2'b01;
        ci=1'b0;
        #10;

        //Moltiplicazione
        a = 8'b00000011;
        b = 8'b00000100;
        op = 2'b10;
        ci = 1'b0;
        #10;

         //Divisione
        a = 8'b00010000;
        b = 8'b00000010;
        op = 2'b11;
        ci = 1'b0;
        #10;

        $finish;
    end

endmodule