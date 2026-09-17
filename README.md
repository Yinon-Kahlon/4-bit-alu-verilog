# 4-Bit ALU (Verilog)

A 4-bit Arithmetic Logic Unit implemented in Verilog, supporting 8 operations
selected by a 3-bit opcode. Verified by an exhaustive self-checking testbench:
every opcode is swept against every operand pair and compared to an independent
reference model.

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
| `carry`  | Output    | 1-bit  | Carry out on ADD, borrow on SUB, 0 otherwise |

---

## Design Notes

**Carry is an arithmetic flag only.** The datapath computes into a 5-bit
temporary, so bit 4 naturally captures the carry out of an ADD and the borrow
of a SUB. Logic and shift operations leave the temporary at zero, so `carry`
reads 0 for them.

**Shifts are logical, and the shifted-out bit is discarded.** `SHL` on `1000`
gives `0000` with `carry = 0`; the MSB is not routed to the carry flag. This is
a deliberate choice to keep `carry` meaning "arithmetic carry/borrow" rather
than overloading it with a shift-out bit. A design that needs rotate-through-carry
semantics would wire `A[3]` into `carry` on SHL and `A[0]` on SHR.

**No latches.** `result` and the temporary are assigned default values at the top
of the `always @(*)` block, so every path through the `case` writes both.

---

## Verification

`alu_tb.v` is self-checking. It walks all **8 opcodes x 16 values of A x 16
values of B = 2,048 vectors** and, for each one, compares `result`, `zero` and
`carry` against a golden reference model written separately from the DUT. Any
disagreement prints the inputs, the observed outputs and the expected outputs,
and increments an error counter. The run ends with an explicit PASS/FAIL line,
so the result does not depend on a human reading a table.

**Current status:**

```
-----------------------------------------------
 4-bit ALU - exhaustive self-checking sweep
 8 opcodes x 16 A values x 16 B values
-----------------------------------------------
-----------------------------------------------
 vectors checked : 2048
 mismatches      : 0
 RESULT          : PASS
-----------------------------------------------
```

The VCD dump is still produced, so the same run can be opened in GTKWave to
inspect any individual vector on the waveform.

---

## Files

```
├── alu.v        # ALU module
├── alu_tb.v     # Self-checking testbench (2,048-vector exhaustive sweep)
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

# 3. Open waveforms (optional)
gtkwave alu_tb.vcd
```

---

## Tools

- **Language:** Verilog (IEEE 1364-2001)
- **Simulator:** Icarus Verilog 12.0
- **Waveform viewer:** GTKWave
