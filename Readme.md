# RV32I 5-Stage Pipelined CPU (Verilog)

This repository contains a **work-in-progress implementation of a 5-stage pipelined RISC-V (RV32I) CPU**, written in Verilog HDL.

The project is being developed incrementally with a focus on:
- correct pipeline structure
- proper control/data separation
- cycle-accurate behavior verified through simulation

This is **not** a single-cycle or toy CPU — each stage is explicitly pipelined and verified step by step.

---

## 🧠 Pipeline Overview

Classic 5-stage pipeline target:

## ✅ Implemented So Far

### Instruction Fetch (IF)
- Program Counter (PC)
- Sequential PC + 4 logic
- Instruction memory interface
- IF/ID pipeline register

### Instruction Decode (ID)
- Instruction field extraction (`rs1`, `rs2`, `rd`, `funct3`, `funct7`)
- Register file (2 read ports, 1 write port)
- Immediate generator (I, S, B, U, J formats)
- Main control unit (opcode-based)
- ID/EX pipeline register with **data and control signals**

### Execute (EX)
- ALU operand selection (register vs immediate)
- ALU control unit (decodes `alu_op`, `funct3`, `funct7`)
- ALU implementation (ADD, SUB, AND, OR)
- Branch comparison logic (BEQ, BNE)
- Branch target address computation

All stages are verified via waveform inspection using behavioral simulation.

---

## 🛠️ Module Breakdown

- `pc.v` – Program counter
- `instr_mem.v` – Instruction memory
- `if_id_reg.v` – IF/ID pipeline register
- `regfile.v` – 32×32-bit register file
- `imm_gen.v` – Immediate generator
- `control.v` – Main control unit (opcode decode)
- `id_ex_reg.v` – ID/EX pipeline register
- `alu_control.v` – ALU control decoder
- `alu.v` – Arithmetic Logic Unit
- `cpu_top.v` – Top-level CPU integration

---

## 🧪 Verification
- Simulated using Vivado simulator
- Waveforms inspected to verify:
  - correct PC progression
  - proper pipeline timing
  - control signal alignment
  - correct ALU and branch behavior

---

## 🚧 Planned Next Steps

- EX/MEM pipeline register
- Data memory (load/store support)
- MEM/WB pipeline register
- Write-back stage
- Hazard detection and forwarding
- Control hazard handling (flush/stall)

---

## 📌 Notes
This project is intended as a **learning-focused CPU design**, emphasizing architectural correctness and clean modular design rather than optimization.

---

## 📜 License
MIT (can be updated later)
