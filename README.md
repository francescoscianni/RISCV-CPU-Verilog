# RISC-V CPU in Verilog

## Overview
This project implements a **Single-Cycle 32-bit RISC-V Processor** from scratch using Verilog. It is designed for learning purposes to understand the fundamentals of computer architecture, the RISC-V ISA (Instruction Set Architecture), and digital logic design.

The CPU currently supports a subset of the **RV32I** base integer instruction set and is fully simulatable using open-source tools like **Icarus Verilog** and **GTKWave**.

---

## Features
- **Architecture:** 32-bit Single-Cycle RISC-V
- **Modular Design:** modules including ALU, Control Unit, Register File, Immediate Generator, and Memory
- **Simulation:** full testbench for verification and waveform generation
- **Supported Instructions:**
  - *Arithmetic:* `ADD`, `ADDI`
  - *Memory:* `LW` (Load Word), `SW` (Store Word)
  - *Branching:* `BEQ` (Branch if Equal)
  - *Jump:* `JAL` (Jump and Link)
  - 
---

##   Prerequisites
To run the simulation, install the following open-source tools:

### Linux / Ubuntu
```
sudo apt-get update
sudo apt-get install iverilog gtkwave
```

### Windows
Download the Windows installer for Icarus Verilog and ensure the executables are added to your PATH.

---

## Getting Started
Follow these steps to compile and run the CPU simulation.

### 1. Clone the Repository
```
git clone https://github.com/francescoscianni/RISCV-CPU-Verilog.git
cd RISCV-CPU-Verilog/CPU
```

### 2. Compile the Design
Use Icarus Verilog to compile all Verilog source files and the testbench (You must be in the /CPU directory):
```
iverilog -o cpu_sim *.v
```

### 3. Run the Simulation
```
vvp cpu_sim
```
The simulation prints the Program Counter, Instruction, and Register File state for every clock cycle.

### 4. View Waveforms
The testbench generates a VCD file. To inspect signals, run:
```
gtkwave cpu_tb.vcd
```
---

## 📝 Customizing the Program
To run your own RISC-V machine code:
1. Write your assembly code in the file
3. Run `File/compiler.py`
4. Copy the output of the program in `CPU/prog.mem`
5. Follow the steps of 2. Compile the design

---

## 🔮 Future Roadmap
- Expand ISA: AND, OR, XOR, SUB, SLT
- Complete Python-based assembler in `Files/`
- Implement pipelined CPU
- Synthesize on FPGA

