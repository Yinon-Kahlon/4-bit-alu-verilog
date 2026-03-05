// File: alu.v
// Description: 4-bit Arithmetic Logic Unit (ALU)
// Supports 8 operations selected by a 3-bit opcode

module alu(
    input  [3:0] A,          // First operand (4-bit)
    input  [3:0] B,          // Second operand (4-bit)
    input  [2:0] opcode,     // Operation select: 000 to 111
    output reg [3:0] result, // Operation result (4-bit)
    output zero,             // Flag: high when result == 0
    output carry             // Flag: high on arithmetic overflow
);

// 5-bit temp register to capture carry out from bit 4
reg [4:0] temp;

// ----------- Opcode Table -----------
// 000 = ADD  (A + B)
// 001 = SUB  (A - B)
// 010 = AND  (A & B)
// 011 = OR   (A | B)
// 100 = XOR  (A ^ B)
// 101 = NOT  (~A)
// 110 = SHL  (A << 1)
// 111 = SHR  (A >> 1)
// ------------------------------------

// Zero flag: asserted when result is all zeros
assign zero  = (result == 4'b0000);

// Carry flag: bit 4 of the extended temp register
assign carry = temp[4];

// Combinational block: recomputes on any input change
always @(*) begin

    // Default values to avoid latches
    temp   = 5'b00000;
    result = 4'b0000;

    case (opcode)

        // ADD: A + B, bit[4] captures carry out
        3'b000: begin
            temp   = {1'b0, A} + {1'b0, B};
            result = temp[3:0];
        end

        // SUB: A - B, bit[4] indicates borrow
        3'b001: begin
            temp   = {1'b0, A} - {1'b0, B};
            result = temp[3:0];
        end

        // AND: bitwise AND
        3'b010: begin
            result = A & B;
        end

        // OR: bitwise OR
        3'b011: begin
            result = A | B;
        end

        // XOR: bitwise XOR
        3'b100: begin
            result = A ^ B;
        end

        // NOT: bitwise invert of A (B is unused)
        3'b101: begin
            result = ~A;
        end

        // SHL: logical shift left by 1 (equivalent to multiply by 2)
        // Example: 0011 -> 0110
        3'b110: begin
            result = A << 1;
        end

        // SHR: logical shift right by 1 (equivalent to divide by 2)
        // Example: 0110 -> 0011
        3'b111: begin
            result = A >> 1;
        end

        // Default: clear output
        default: begin
            result = 4'b0000;
        end

    endcase
end

endmodule
