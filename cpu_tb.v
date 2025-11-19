`timescale 1ns/1ps

module cpu_tb;

    reg clk;
    reg reset;

    // Instantiate the CPU
    cpu uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    integer idx;
    integer instruction_count = 0;

    // Reset logic and simulation
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        // Load program into memory
        $display("Loading prog.mem into RAM...");
        $readmemh("prog.mem", uut.memory.mem);
        
        $display("\nInitial RAM contents (first 32 words):");
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $display("mem[%0d] = %08x", idx, uut.memory.mem[idx]);
        end

        reset = 1;
        #20;          // Hold reset for 20 ns
        reset = 0;

        // Run for enough cycles to execute all instructions
        repeat (15) @(posedge clk);

        $display("\nFinal Register File Contents:");
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $display("x%0d = %08x", idx, uut.regfile_inst.regs[idx]);
        end

        $display("\nFinal RAM contents (first 32 words):");
        for (idx = 0; idx < 32; idx = idx + 1) begin
            $display("mem[%0d] = %08x", idx, uut.memory.mem[idx]);
        end

        $display("\nSimulation completed.");
        $finish;
    end

    // Monitor important signals and state after each instruction
    always @(posedge clk) begin
         // Capture state after each instruction fetch
            instruction_count = instruction_count + 1;
            
            $display("\n--------------------------------------------------");
            $display("Instruction #%0d at Time: %0t ns", instruction_count, $time);
            $display("--------------------------------------------------");
            
            // Current state information
            $display("PC = %h (%0d)", uut.pc_out, uut.pc_out);
            $display("IR = %h", uut.ir_out);
            $display("Current State: %b", uut.control_unit.fsm.cs);
            
            // Control signals
            $display("Control Signals:");
            $display("  PCwrite=%b, Branch=%b, RegWrite=%b, MemWrite=%b", 
                     uut.PCwrite, uut.control_unit.Branch, uut.RegWrite, uut.MemWrite);
            $display("  IRWrite=%b, AdrSrc=%b, ResultSrc=%b", 
                     uut.IRWrite, uut.AdrSrc, uut.ResultSrc);
            $display("  ALUSrcA=%b, ALUSrcB=%b, ALUOp=%b", 
                     uut.ALUSrcA, uut.ALUSrcB, uut.control_unit.fsm.ALUOp);
            $display("  ImmSrc=%b, ALUControl=%b", 
                     uut.control_unit.ImmSrc, uut.ALUControl);
            
            // ALU and data path
            $display("\nData Path:");
            $display("  ALU inputs: A=%h, B=%h", uut.SrcA, uut.SrcB);
            $display("  ALU result: %h, zero=%b", uut.alu_res, uut.zero);
            $display("  ALU_out reg: %h", uut.alu_out);
            $display("  Result MUX output: %h", uut.Result);
            
            // Register file state
            $display("\nRegister File State:");
            for (idx = 0; idx < 8; idx = idx + 1) begin  // Display first 8 registers for brevity
                $display("  x%0d = %h", idx, uut.regfile_inst.regs[idx]);
            end
            
            // Memory state at relevant addresses
            $display("\nMemory State:");
            $display("  mem[0] = %h", uut.memory.mem[0]);
            $display("  mem[1] = %h", uut.memory.mem[1]);
            $display("  mem[16] = %h", uut.memory.mem[16]);
            $display("  mem[17] = %h", uut.memory.mem[17]);
            $display("  mem[18] = %h", uut.memory.mem[18]);
        end

endmodule