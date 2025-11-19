module main_fsm (
    input clk, input reset, input zero,
    input [6:0] op,
    output reg PCUpdate, Branch,
    output reg RegWrite, MemWrite, IRWrite, AdrSrc,
    output reg [1:0] ALUSrcA, ALUSrcB, ResultSrc,
    output reg [1:0] ALUOp
);

    reg [3:0] cs, ns;

    // Stato corrente
    always @(posedge clk or posedge reset) begin
        if (reset)
            cs <= 4'b0000;
        else
            cs <= ns;
    end

    // Prossimo stato
    always @(*) begin
        case (cs)
            4'b0000: ns = 4'b0001;  // FETCH -> DECODE
            4'b0001: begin
                case (op)
                    7'b0000011, 7'b0100011: ns = 4'b0010; // LOAD/STORE
                    7'b0110011: ns = 4'b0110; // ALU R-R
                    7'b0010011: ns = 4'b1000; // ALU IMM
                    7'b1101111: ns = 4'b1001; // JAL
                    7'b1100011: ns = 4'b1010; // BEQ
                    default: ns = 4'b0000;
                endcase
            end
            4'b0010: ns = (op == 7'b0000011) ? 4'b0011 : 4'b0101; // LOAD or STORE
            4'b0011: ns = 4'b0100; // LOAD -> WB
            4'b0100, 4'b0101, 4'b0111: ns = 4'b0000; // WB or END
            4'b0110: ns = 4'b0111; // ALU -> WB
            4'b1000: ns = 4'b0111; // ALU IMM -> WB
            4'b1001: ns = 4'b0000; // JAL -> END
            4'b1010: ns = 4'b0000; // BEQ -> END
            default: ns = 4'b0000;
        endcase
    end

    // Uscite per stato
    always @(*) begin
        // Default
        PCUpdate   = 0; Branch = 0;
        RegWrite   = 0; MemWrite = 0;
        IRWrite    = 0; AdrSrc   = 0;
        ALUSrcA    = 2'b00; ALUSrcB = 2'b00;
        ResultSrc  = 2'b00; ALUOp = 2'b00;

        case (cs)
            4'b0000: begin // FETCH
                IRWrite   = 1;
                PCUpdate  = 1;
                ALUSrcA   = 2'b00;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b10;
            end
            4'b0001: begin // DECODE
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b01;
                ALUOp     = 2'b00;
            end
            4'b0010: begin // address calculation
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b00;
            end
            4'b0011: begin // LOAD memory read
                AdrSrc    = 1;
                ResultSrc = 2'b00;
            end
            4'b0100: begin
                RegWrite = 1;
                ResultSrc = 2'b01;
            end
            4'b0101: begin
                AdrSrc  = 1;
                MemWrite = 1;
                ResultSrc = 2'b00;
            end
            4'b0110: begin // R-R
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp   = 2'b10;
            end
            4'b1000: begin // R-I
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b10;
            end
            4'b0111: begin
                RegWrite = 1;
                ResultSrc = 2'b00;
            end
            4'b1001: begin // JAL
                ALUSrcA   = 2'b01;
                ALUSrcB   = 2'b10;
                ALUOp     = 2'b00;
                ResultSrc = 2'b00;
                PCUpdate  = 1;
            end
            4'b1010: begin // BRANCH
                ALUSrcA   = 2'b10;
                ALUSrcB   = 2'b00;
                ALUOp     = 2'b01;
                ResultSrc = 2'b00;
                Branch    = 1;
            end
        endcase
    end
endmodule