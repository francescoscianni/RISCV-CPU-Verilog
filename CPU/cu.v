module cu (
    input clk,
    input reset,
    input zero,
    input [6:0] op,
    input [2:0] funct3,
    input [6:0] funct7,

    output PCwrite,
    output AdrSrc,
    output MemWrite,
    output IRWrite,
    output [1:0] ResultSrc,
    output [2:0] ALUControl,
    output [1:0] ALUSrcA,
    output [1:0] ALUSrcB,
    output [1:0] ImmSrc,
    output RegWrite
);

    wire PCUpdate, Branch;
    wire [1:0] ALUOp;

    // FSM
    main_fsm fsm (
        .clk(clk), .reset(reset), .zero(zero), .op(op),
        .PCUpdate(PCUpdate), .Branch(Branch),
        .RegWrite(RegWrite), .MemWrite(MemWrite), .IRWrite(IRWrite),
        .AdrSrc(AdrSrc),
        .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB),
        .ResultSrc(ResultSrc),
        .ALUOp(ALUOp)
    );

    // ALU Decoder
    alu_decoder alu_dec (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7_5(funct7[5]),
        .ALUControl(ALUControl)
    );

    // Instruction Decoder
    instr_decoder instr_dec (
        .opcode(op),
        .ImmSrc(ImmSrc)
    );

    // Logica per PCwrite
    assign PCwrite = PCUpdate | (Branch & zero);

endmodule
