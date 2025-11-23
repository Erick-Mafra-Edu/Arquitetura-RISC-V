## R-type Instructions

| Instruction | funct7  | rs2   | rs1   | funct3 | rd    | opcode  | Example              |
|------------|---------|-------|-------|--------|-------|---------|-----------------------|
| add (add)  | 0000000 | 00011 | 00010 | 000    | 00001 | 0110011 | add x1, x2, x3        |
| sub (sub)  | 0100000 | 00011 | 00010 | 000    | 00001 | 0110011 | sub x1, x2, x3        |


## I-type Instructions

| Instruction         | immediate     | rs1   | funct3 | rd    | opcode  | Example                 |
|---------------------|---------------|-------|--------|-------|---------|--------------------------|
| addi (add immediate)| 001111101000  | 00010 | 000    | 00001 | 0010011 | addi x1, x2, 1000        |
| ld (load doubleword)| 001111101000  | 00010 | 011    | 00001 | 0000011 | ld x1, 1000(x2)          |


## S-type Instructions

| Instruction        | immediate | rs2   | rs1   | funct3 | immediate | opcode  | Example                |
|--------------------|-----------|-------|-------|--------|-----------|---------|-------------------------|
| sd (store doubleword) | 0011111  | 00001 | 00010 | 011    | 01000    | 0100011 | sd x1, 1000(x2)        |
