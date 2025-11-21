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
Download the Windows installer for Icarus Verilog.

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

## Customizing the Program

### **1. Write your assembly program**
Edit the file:

```
Files/assembly.asm
```

and add your RISC-V instructions.

---

### **2. Compile the assembly into machine code**
Run the Python compiler:

```bash
python3 Files/compiler.py
```

This generates a sequence of 32-bit instructions in hexadecimal.

---

### **3. Load the machine code into the CPU**
Copy the compiler output into:

```
CPU/prog.mem
```

This file is read at simulation startup and loaded into the instruction memory.

---

### **4. Recompile and simulate**
Return to the `CPU/` directory and compile the design:

```bash
iverilog -o cpu_sim *.v
vvp cpu_sim
```

---

## Additional Notes

### **Memory Layout**
The Python compiler inserts **16 empty memory locations (32-bit words)** before your code:

```python
(151) for i in range(16):   # Number of empty memory locations before code
```

You may increase or decrease this number.  
If you change it, update the program counter starting value inside:

```
CPU/regnbit.v
```

to match the new starting address.

---

### **End of Program Instruction**
To mark the end of the program, `compiler.py` uses:

```
JAL x0, 0   # END instruction
```


---

## Future work
- Expand ISA: AND, OR, XOR, SUB, SLT
- Complete Python-based assembler in `Files/`
- Implement pipelined CPU
- Synthesize on FPGA

