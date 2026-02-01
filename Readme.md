## RV32I 5-Stage Pipelined CPU (Work in Progress)

### Implemented so far
- Instruction Fetch (IF)
- Instruction Decode (ID)
- Pipeline registers: IF/ID, ID/EX
- Register file integration
- Cycle-accurate simulation verified in Vivado

### Current pipeline
IF → IF/ID → ID → ID/EX → (EX/MEM/WB pending)

### Next steps
- Immediate generator
- Control unit
- EX stage (ALU)
- MEM & WB stages
- Hazard detection & forwarding

### Tools
- Verilog HDL
- Vivado Simulator
