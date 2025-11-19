# RISC-V CPU Design in Verilog

## Overview
This is a **personal project** implementing a simple **RISC-V CPU** in **Verilog** for learning purposes.  
The CPU is currently **simulatable using Icarus Verilog (`iverilog`)** and visualized with **GTKWave (`gtkwave`)**.  

It demonstrates key CPU architecture concepts:
- Instruction fetch, decode, execute, memory access, write-back  
- Finite State Machine (FSM) control  
- Modular design for ALU, Register File, Memory, and Control Unit  

>  Note: The CPU has **not yet been tested on FPGA**.

---

## Features
- Implements a subset of **RISC instructions**:
  - Arithmetic: `ADD`, `ADDI`
  - Memory access: `LW`, `SW`
  - Branch: `BEQ`
  - Jump: `JAL`
- Modular components:
  - `ALU`, `Register File`, `Instruction Decoder`, `Main FSM`, `Control Unit`, `RAM`
- Includes **Verilog testbench** (`cpu_tb.v`)  
- Produces **VCD waveform file** for signal inspection  
- Prints **PC, IR, control signals, ALU outputs, register file, and memory contents** per cycle  

---

## Tools Used
- **Verilog** for hardware description  
- **Icarus Verilog** (`iverilog`) for simulation  
- **GTKWave** (`gtkwave`) for waveform viewing  
- Python (**assembler/compiler in progress**)  

---

## Simulation Instructions
1. **Compile** the project using Icarus Verilog. Form the /CPU directory:
```bash
iverilog -o cpu_sim *.v
```

2. **Run** the simulation:
```bash
vvp cpu_sim
```

3. View **waveforms** with GTKWave:
```bash
gtkwave cpu_tb.vcd
```
4. Check **console outputs** for registers and memory after each instruction cycle.

---
## Future Work
- Complete the Python assembler/compiler
- Expand CPU instruction set
- Deploy CPU on FPGA

