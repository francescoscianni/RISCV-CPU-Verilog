`timescale 1ns / 1ps

module ram_tb;

    reg clk;
    reg cs;
    reg oe;
    reg we;
    reg [15:0] addr;
    reg [15:0] dataIn;
    wire [15:0] dataOut;

    // Instantiate the RAM
    ram uut (
        .dataOut(dataOut),
        .dataIn(dataIn),
        .addr(addr),
        .clk(clk),
        .cs(cs),
        .oe(oe),
        .we(we)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk;  // 10ns clock period

    // Initialize memory content from prog.mem
    initial begin
        $readmemh("prog.mem", uut.mem);
    end

    // Test sequence
    initial begin
        $dumpfile("ram_tb.vcd");
        $dumpvars(0, ram_tb);

        // Wait for memory to be loaded
        #10;

        // Read memory from address 7 to 12
        cs = 1;
        we = 0;      // No write
        oe = 1;

        for (addr = 7; addr <= 12; addr = addr + 1) begin
            #10;
            $display("Read addr %d: data = %h", addr, dataOut);
        end

        // Optional: test write
        cs = 1; oe = 0; we = 1;
        addr = 5;
        dataIn = 16'hDEAD;
        #10;

        // Read back
        cs = 1; oe = 1; we = 0;
        #10;
        $display("After write: addr %d = %h", addr, dataOut);

        $finish;
    end

endmodule
