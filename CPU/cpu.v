module cpu (
    input clk,
    input reset
);
    // PC
    wire [31:0] pc_out, pc_in;
    wire PCwrite;
    pc_reg #(32) pc_inst(.dataOut(pc_out), .clk(clk), .dataIn(pc_in), .en(PCwrite), .reset(reset));

    // Address MUX
    wire AdrSrc;
    wire [31:0] Result, Adr;
    mux2_1 mux_addr(.out(Adr), .a(pc_out), .b(Result), .sel(AdrSrc));

    assign pc_in = Result;

    // Memory
    wire MemWrite;
    wire [31:0] ir_in;
    ram memory(
        .dataOut(ir_in),
        .dataIn(outB),
        .addr(Adr),
        .clk(clk),
        .cs(1'b1),
        .oe(!MemWrite),
        .we(MemWrite)
    );

    // Instruction Register
    wire [31:0] ir_out;
    wire IRWrite;
    regnbit #(32) ir(.dataOut(ir_out), .clk(clk), .dataIn(ir_in), .en(IRWrite), .reset(reset));

    // Old PC (for JAL)
    wire [31:0] opc_out;
    regnbit #(32) old_pc(.dataOut(opc_out), .clk(clk), .dataIn(pc_out), .en(IRWrite), .reset(reset));

    // Register File
    wire [31:0] inA, inB;
    wire RegWrite;
    regfile regfile_inst(
        .rd1(inA), .rd2(inB),
        .ra1(ir_out[19:15]), .ra2(ir_out[24:20]),
        .wa(ir_out[11:7]),
        .we(RegWrite),
        .wd(Result),
        .clk(clk)
    );

    wire [31:0] outA, outB;
    regnbit #(32) regA(.dataOut(outA), .clk(clk), .dataIn(inA), .en(1'b1), .reset(reset));
    regnbit #(32) regB(.dataOut(outB), .clk(clk), .dataIn(inB), .en(1'b1), .reset(reset));

    // Immediate Extension
    wire [1:0] ImmSrc;
    wire [31:0] ImmExt;
    extend extend_unit(.instr(ir_out), .ImmSrc(ImmSrc), .extended(ImmExt));

    // ALU MUXes
    wire [1:0] ALUSrcA, ALUSrcB;
    wire [31:0] SrcA, SrcB;
    mux3_1 muxA(.out(SrcA), .a(pc_out), .b(opc_out), .c(outA), .sel(ALUSrcA));
    mux3_1 muxB(.out(SrcB), .a(outB), .b(ImmExt), .c(32'd1), .sel(ALUSrcB));

    // ALU
    wire [2:0] ALUControl;
    wire zero;
    wire [31:0] alu_res;
    alu alu_inst(.a(SrcA), .b(SrcB), .alucontrol(ALUControl), .result(alu_res), .zero(zero));

    wire [31:0] alu_out;
    regnbit #(32) alu_reg(.dataOut(alu_out), .clk(clk), .dataIn(alu_res), .en(1'b1), .reset(reset));

    // Memory Read Register
    wire [31:0] readData_o;
    regnbit #(32) readData(.dataOut(readData_o), .clk(clk), .dataIn(ir_in), .en(1'b1), .reset(reset));

    // Result MUX
    wire [1:0] ResultSrc;
    mux3_1 muxResult(.out(Result), .a(alu_out), .b(readData_o), .c(alu_res), .sel(ResultSrc));

    // CONTROL UNIT
    cu control_unit(
        .clk(clk), .reset(reset), .zero(zero),
        .op(ir_out[6:0]),
        .funct3(ir_out[14:12]),
        .funct7(ir_out[31:25]),
        .PCwrite(PCwrite),
        .AdrSrc(AdrSrc),
        .MemWrite(MemWrite),
        .IRWrite(IRWrite),
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite)
    );

endmodule