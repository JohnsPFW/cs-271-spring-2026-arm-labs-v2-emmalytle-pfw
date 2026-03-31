# Lab 02 Answers
**Student Name:** Emma Lytle

---

## How to decode an instruction encoding

For each question below, find the hex encoding in your disassembly log, convert it to 32-bit binary, then fill in each field using the bit layout diagram.

**Worked Example: `MOVZ X1, #1` (encoding: `d2800021`)**

Step 1 — Convert hex to binary (4 bits per digit):
```
d    2    8    0    0    0    2    1
1101 0010 1000 0000 0000 0000 0010 0001
```

Step 2 — Map bits to the MOVZ field layout:

| 31 | 30-29 | 28-23  | 22-21 | 20-5             | 4-0   |
|----|-------|--------|-------|------------------|-------|
| sf | 10    | 100101 | hw    | imm16            | Rd    |
| 1  | 10    | 100101 | 00    | 0000000000000001 | 00001 |

Step 3 — Identify each field:
- `sf` = 1 → 64-bit register
- `hw` = 00 → no shift (LSL #0)
- `imm16` = 0000000000000001 = 1
- `Rd` = 00001 = X1

---

## Section 3.2 — Interpreting Instruction Encodings

---

**1. `MOVZ X0, #5`**

Hex encoding (from disassembly log): `0x` 
encoding = d28000a0

Binary (32-bit):
```
d    2    8    0    0    0    a    0
1101 0010 1000 0000 0000 0000 1010 0000
```

| 31 | 30-29 | 28-23  | 22-21 | 20-5             |  4-0  |
|----|-------|--------|-------|------------------|-------|
| sf | 10    | 100101 | hw    | imm16            |   Rd  |
| 1  | 10    | 100101 | 00    | 0000000000000101 | 00000 |

- `sf` = 1 → 64-bit register
- `hw` = 00 → no shift (LSL #0)
- `imm16` = 0000000000000101 = 5
- `Rd` = 00000 = X0

---

**2. `ADD X4, X4, X0`**

Hex encoding (from disassembly log): `0x`
encoding = 8b000084

Binary (32-bit):
```
8    b    0    0    0    0    8    4
1000 1011 0000 0000 0000 0000 1000 0100
```

| 31 | 30 | 29 | 28-24 | 23-22 | 20-16 |  15-10 |  9-5  |  4-0  |
|----|----|----|-------|-------|-------|--------|-------|-------|
| sf | op | S  | 01011 | shift | Rm    |  imm6  |  Rn   |  Rd   |
| 1  | 0  | 0  | 01011 | 00    | 00000 | 000000 | 00100 | 00100 |

- `Rm` (binary) = 00000
- `Rn` (binary) = 00100
- `Rd` (binary) = 00100

---

**3. `SUBS X0, X0, X1`**

Hex encoding (from disassembly log): `0x`
encoding = eb010000

Binary (32-bit):
```
e    b    0    1    0    0    0    0
1110 1011 0000 0001 0000 0000 0000 0000
```

| 31 | 30 | 29 | 28-24 | 23-22 |  20-16 | 15-10 |  9-5  |  4-0  |
|----|----|----|-------|-------|--------|-------|-------|-------|
| sf | op | S  | 01011 | shift |  Rm    | imm6  |  Rn   |   Rd  |
| 1  | 1  | 1  | 01011 |   00  | 00001 | 00000 | 00000 | 00000 |

Compare the `op` and `S` bits to `ADD` above:
- How does the encoding differ to signal that condition flags should be updated?
'op' and 's' are encoded to 1 instead of 0, signaling that the operation should be changed from ADD (0) to SUB (1), and S tells the condition flags what signals to be updated after the operation. S = 1 turns SUB into SUBS 

---

**4. `B.NE sum_loop`**

Hex encoding (from disassembly log): `0x`
encoding = 54ffffa1

Binary (32-bit):
```
5    4    f    f    f    f    a    1
0101 0100 1111 1111 1111 1111 1010 0001
```

| 31-24    |         23-5        | 4 | 3-0  |
|----------|---------------------|---|------|
| 01010100 |        imm19        | 0 | cond |
| 01010100 | 1111111111111111101 | 0 | 0001 |

- `imm19` (binary) = ffffd
- `imm19` as a two's complement integer = -3
- Byte offset (imm19 × 4) = -12
- `B.NE` address (from disassembly) = 0x1c
- `sum_loop` address (from disassembly) = 0x10
- Do they match? Yes

---

## Section 4.1 — Logical Immediate Values

`MOVZ` and `MOVK` each write a 16-bit immediate into one of four slots in a 64-bit register. The `LSL` shift selects which slot:

| bits 63-48 | bits 47-32 | bits 31-16 | bits 15-0 |
|------------|------------|------------|-----------|
| LSL #48    | LSL #32    | LSL #16    | LSL #0    |

`MOVZ` writes the selected slot and **zeros** all others.
`MOVK` writes the selected slot and **keeps** all other bits unchanged.

Use this layout to trace the value of X5 step by step before answering.

---

**X5** (after `MOVZ` + `MOVK`):
`X5 = 0x`
X5 = 0000 0000 00ff ffff

**X6** (after `AND X6, X5, #0x00003ffc00003ffc`):
`X6 = 0x`
0x 0000 0000 00ff ffff
0x 0000 3ffc 0000 3ffc

upper
0x 0000 0000 = 0000 0000 0000 0000 0000 0000 0000 0000

0x 0000 3ffc = 0000 0000 0000 0000 0011 1111 1111 1100
AND = 0x 0000 0000

lower
0x 00ff ffff = 0000 0000 1111 1111 1111 1111 1111 1111

0x 0000 3ffc = 0000 0000 0000 0000 0011 1111 1111 1100
         AND = 0000 0000 0000 0000 0011 1111 1111 1100
X6 = 0x0000 0000 0000 3ffc

**X7** (after `ORR X7, X5, #0x00003ffc00003ffc`):
`X7 = 0x`
0x 0000 0000 00ff ffff
0x 0000 3ffc 0000 3ffc

upper
0x 0000 0000 = 0000 0000 0000 0000 0000 0000 0000 0000

0x 0000 3ffc = 0000 0000 0000 0000 0011 1111 1111 1100
          OR = 0x 0000 3ffc

lower
0x 00ff ffff = 0000 0000 1111 1111 1111 1111 1111 1111

0x 0000 3ffc = 0000 0000 0000 0000 0011 1111 1111 1100
          OR = 0000 0000 1111 1111 1111 1111 1111 1111
X7 = 0x0000 3ffc 00ff ffff

---

## Section 5 — Instruction Aliases

- What is the base instruction that `CMP X0, X1` translates to?
CMP is converted by the assembler to SUBS, subtracting X1 from X0 and updating the condition flag based on the compared result, not the actual numeric subtracted value.
- What is the full expanded form (including all operands)?
SUBS    XZR, X0, X1