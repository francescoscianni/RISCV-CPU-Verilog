module pc_tb ();
    wire[7:0]pc;
    reg clk;
    reg [7:0]PCNext;
    reg PCWrite;

    pc pc_dut(pc,clk,PCNext,PCWrite);

    initial clk=0;
    always #5 clk=~clk;

    initial begin
        $monitor("[%0t ns] pc=%b clk=%b PCNext=%b PCWrite=%b", $time, pc, clk, PCNext, PCWrite);

        // inizializzazione
        PCWrite = 0;
        PCNext = 8'b0000_0000;

        // aspetta un clock per stabilizzare
        @(posedge clk);

        // Primo aggiornamento PC
        PCNext = 8'b0000_1111;
        PCWrite = 1;
        #1;
        @(posedge clk);  // su questo fronte pc si aggiorna
        
        // Cambia PCNext per il prossimo valore
        PCNext = 8'b0100_0000;
        
        @(posedge clk);  // su questo fronte pc si aggiorna ancora

        // Disabilita scrittura
        PCWrite = 0;
        PCNext = 8'b1111_1111; // Non dovrebbe aggiornare pc perché PCWrite=0

        @(posedge clk);
        
        $finish;
    end

endmodule