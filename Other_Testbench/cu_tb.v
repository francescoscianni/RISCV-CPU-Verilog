`timescale 1ns / 1ps

module cu_tb;

    // Inputs
    reg clk;
    reg reset;
    reg [2:0] op;
    reg [1:0] AluFunc;
    reg zero;

    // Outputs
    wire PCwrite;
    wire AdrSrc;
    wire MemWrite;
    wire IRWrite;
    wire [1:0] ResultSrc;
    wire [1:0] ALUControl;
    wire [1:0] ALUSrcA;
    wire [1:0] ALUSrcB;
    wire RegWrite;

    // Instantiate the Unit Under Test (UUT)
    cu uut (
        .op(op),
        .AluFunc(AluFunc),
        .zero(zero),
        .clk(clk),
        .reset(reset),
        .PCwrite(PCwrite),
        .AdrSrc(AdrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .RegWrite(RegWrite)
    );

    // Clock generation (period = 20ns)
    always #10 clk = ~clk;

    // Stimulus
    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        op = 3'b000;
        AluFunc = 2'b00;
        zero = 0;

        // Dump VCD file for waveform analysis
        $dumpfile("cu_tb.vcd");
        $dumpvars(0, cu_tb);

        // Reset the system
        #20 reset = 0;

        $display("Testing FETCH state (op=xxx)");
        #20; // Wait for one clock cycle in FETCH
        
        // Test LOAD instruction (op=000)
        $display("\nTesting LOAD instruction (op=000)");
        op = 3'b000;
        #60; // Go through all LOAD states
        
        // Test STORE instruction (op=001)
        $display("\nTesting STORE instruction (op=001)");
        op = 3'b001;
        #60; // Go through all STORE states
        
        // Test ADD instruction (op=010, AluFunc=00)
        $display("\nTesting ADD instruction (op=010, AluFunc=00)");
        op = 3'b010;
        AluFunc = 2'b00;
        #40; // Go through all ALU R-R states
        
        // Test SUB instruction (op=010, AluFunc=01)
        $display("\nTesting SUB instruction (op=010, AluFunc=01)");
        op = 3'b010;
        AluFunc = 2'b01;
        #40;
        reset=1;
        #10;
        reset=0;
        // Test ADDI instruction (op=011)
        $display("\nTesting ADDI instruction (op=011)");
        op = 3'b011;
        #100;
        
        // Test JAL instruction (op=100)
        $display("\nTesting JAL instruction (op=100)");
        op = 3'b100;
        #40;
        
        // Test BEQ instruction (op=101) with zero=1
        $display("\nTesting BEQ instruction (op=101) with zero=1");
        op = 3'b101;
        zero = 1;
        #40;
        
        // Test BEQ instruction (op=101) with zero=0
        $display("\nTesting BEQ instruction (op=101) with zero=0");
        op = 3'b101;
        zero = 0;
        #40;
        
        // Test invalid opcode (op=111)
        $display("\nTesting invalid opcode (op=111)");
        op = 3'b111;
        #40;
        
        $display("\nTest completed");
        $finish;
    end

    // Monitor state changes and outputs
    reg [3:0] prev_state;
    always @(posedge clk) begin
        prev_state <= uut.cs;
        
        if (uut.cs !== prev_state) begin
            $display("Time=%0t: State changed from %b to %b", $time, prev_state, uut.cs);
            $display("  Control signals: PCwrite=%b, RegWrite=%b, MemWrite=%b, IRWrite=%b", 
                     PCwrite, RegWrite, MemWrite, IRWrite);
            $display("  ALU controls: ALUControl=%b, ALUSrcA=%b, ALUSrcB=%b, ResultSrc=%b",
                     ALUControl, ALUSrcA, ALUSrcB, ResultSrc);
        end
    end

endmodule