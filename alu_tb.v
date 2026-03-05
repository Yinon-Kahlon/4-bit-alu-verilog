// File: alu_tb.v
// Description: Testbench for the 4-bit ALU
// Runs 4 test cases and prints results to console

`timescale 1ns / 1ps

module alu_tb;

    // Inputs driven by the testbench
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] opcode;

    // Outputs received from the ALU
    wire [3:0] result;
    wire zero;
    wire carry;

    // Instantiate the ALU
    alu uut (
        .A      (A),
        .B      (B),
        .opcode (opcode),
        .result (result),
        .zero   (zero),
        .carry  (carry)
    );

    // Dump waveform data for GTKWave
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // Print table header
    initial begin
        $display("-----------------------------------------------");
        $display(" A    B    opcode  result  zero  carry");
        $display("-----------------------------------------------");
    end

    // Test cases
    initial begin

        // Test 1: ADD — 3 + 5 = 8
        A = 4'b0011; B = 4'b0101; opcode = 3'b000;
        #10;
        $display("ADD:  %b + %b = %b  (dec: %0d)  zero=%b carry=%b",
                  A, B, result, result, zero, carry);

        // Test 2: AND — 1100 & 1010 = 1000
        A = 4'b1100; B = 4'b1010; opcode = 3'b010;
        #10;
        $display("AND:  %b & %b = %b  (dec: %0d)  zero=%b carry=%b",
                  A, B, result, result, zero, carry);

        // Test 3: NOT — ~0011 = 1100
        A = 4'b0011; B = 4'b0000; opcode = 3'b101;
        #10;
        $display("NOT:  ~%b   = %b  (dec: %0d)  zero=%b carry=%b",
                  A, result, result, zero, carry);

        // Test 4: SHL — 0011 << 1 = 0110
        A = 4'b0011; B = 4'b0000; opcode = 3'b110;
        #10;
        $display("SHL:  %b <<1  = %b  (dec: %0d)  zero=%b carry=%b",
                  A, result, result, zero, carry);

        $display("-----------------------------------------------");
        $finish;
    end

endmodule
