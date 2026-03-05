# 4-Bit ALU (Verilog)

A simple 4-bit Arithmetic Logic Unit (ALU) implemented in Verilog. Supports 8 operations selected by a 3-bit opcode. Written as a first hardware design project.

---

## Supported Operations

| opcode | Operation | Description |
|--------|-----------|-------------|
| `000`  | ADD       | A + B |
| `001`  | SUB       | A - B |
| `010`  | AND       | A & B (bitwise) |
| `011`  | OR        | A \| B (bitwise) |
| `100`  | XOR       | A ^ B (bitwise) |
| `101`  | NOT       | ~A (bitwise, ignores B) |
| `110`  | SHL       | A << 1 (shift left) |
| `111`  | SHR       | A >> 1 (shift right) |

---

## I/O Ports

| Port     | Direction | Width  | Description |
|----------|-----------|--------|-------------|
| `A`      | Input     | 4-bit  | First operand |
| `B`      | Input     | 4-bit  | Second operand |
| `opcode` | Input     | 3-bit  | Selects operation |
| `result` | Output    | 4-bit  | Operation result |
| `zero`   | Output    | 1-bit  | High when result == 0 |
| `carry`  | Output    | 1-bit  | High on arithmetic overflow |

---

## Files

```
├── alu.v        # ALU module
├── alu_tb.v     # Testbench with 4 test cases
└── README.md
```

---

## How to Run

Requires [Icarus Verilog](https://bleyer.org/icarus/) and GTKWave (included in the Icarus installer).

```bash
# 1. Compile
iverilog -o sim.out alu.v alu_tb.v

# 2. Run simulation
vvp sim.out

# 3. Open waveforms
gtkwave alu_tb.vcd
```

**Expected output:**
```
-----------------------------------------------
 A    B    opcode  result  zero  carry
-----------------------------------------------
ADD:  0011 + 0101 = 1000  (decimal: 8)   zero=0 carry=0
AND:  1100 & 1010 = 1000  (decimal: 8)   zero=0 carry=0
NOT:  ~0011       = 1100  (decimal: 12)  zero=0 carry=0
SHL:  0011 <<1    = 0110  (decimal: 6)   zero=0 carry=0
-----------------------------------------------
```

---

## Tools

- **Language:** Verilog (IEEE 1364-2001)
- **Simulator:** Icarus Verilog
- **Waveform viewer:** GTKWave
