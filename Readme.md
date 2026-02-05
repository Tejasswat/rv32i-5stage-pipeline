# RV32I 5-Stage Pipelined CPU (Verilog HDL)

This repository contains a work-in-progress implementation of a 5-stage pipelined RISC-V (RV32I) CPU, written entirely in Verilog HDL.

The project is built incrementally with an emphasis on:
- correct pipeline structure
- proper separation of control and datapath
- cycle-accurate behavior verified through simulation

This is not a single-cycle CPU and not a behavioral model — each pipeline stage is explicitly implemented and validated.

---

## Pipeline Target

Classic 5-stage RISC pipeline: IF → ID → EX → MEM → WB

### Current implementation status: IF → ID → ID/EX → EX


---

## Implemented Features

### Instruction Fetch (IF)
- Program Counter (PC)
- Sequential PC + 4 logic
- Instruction memory interface
- IF/ID pipeline register

### Instruction Decode (ID)
- Instruction field extraction (`rs1`, `rs2`, `rd`, `funct3`, `funct7`)
- 32 × 32-bit register file (2 read ports, 1 write port)
- Immediate generator (I, S, B, U, J formats)
- Main control unit (opcode-based decoding)
- ID/EX pipeline register with data and control signal propagation

### Execute (EX)
- ALU operand selection (register vs immediate)
- ALU control unit (`alu_op`, `funct3`, `funct7` decoding)
- Arithmetic Logic Unit (ADD, SUB, AND, OR)
- Branch comparison logic (BEQ, BNE)
- Branch target address computation

All implemented stages have been verified using cycle-accurate simulation and waveform inspection.

---

## Module Overview

| File | Description |
|----|------------|
| `pc.v` | Program counter |
| `instr_mem.v` | Instruction memory |
| `if_id_reg.v` | IF/ID pipeline register |
| `regfile.v` | Register file |
| `imm_gen.v` | Immediate generator |
| `control.v` | Main control unit |
| `id_ex_reg.v` | ID/EX pipeline register |
| `alu_control.v` | ALU control decoder |
| `alu.v` | Arithmetic Logic Unit |
| `cpu_top.v` | Top-level CPU integration |

---

## Verification

- Simulated using Vivado behavioral simulation
- Waveform-based verification used to confirm:
  - correct PC progression
  - proper instruction flow through pipeline stages
  - correct alignment of control and datapath signals
  - correct ALU operation and branch decisions

---

## Work in Progress / Planned Features

- EX/MEM pipeline register
- Data memory stage (load/store support)
- MEM/WB pipeline register
- Write-back stage
- Data forwarding
- Hazard detection and pipeline stalling
- Control hazard handling (branch flush)

---

## Notes

This project is intended as a learning-focused CPU design, emphasizing architectural correctness and clean modular design rather than performance optimization.

Each stage is implemented and tested incrementally to maintain correctness and clarity.

---



