`timescale 1ns/1ps

module regfile_tb ();
    reg[2:0] ra1;
    reg[2:0] ra2;
    reg[2:0] wa;
    reg we;
    reg[7:0] wd;
    reg clk;
    wire[7:0] rd1;
    wire[7:0] rd2; 


    regfile regfile_dut(rd1,rd2, ra1,ra2, wa, we, wd,clk);

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, regfile_tb);
        $monitor("[%t0 ns] rd1=%b rd2=%b | ra1=%b ra2=%b wa=%b we=%b wd=%b clk=%b",$time,rd1,rd2, ra1,ra2, wa, we, wd,clk);
        // scrittura nei registri
        ra1 = 0;
        ra2 = 0;    
        we=1;
        for(i=0;i<8;i++)begin
            wa=i[2:0];
            wd=8'b1000_0000+wa;
            @(posedge clk);
        end
        we=0;

        //lettura dei registri
        for (i = 0; i < 8; i = i + 1) begin
            ra1 = i;
            ra2 = 7 - i;
            @(posedge clk);+
            #1;
        end
        $finish;
    end
endmodule