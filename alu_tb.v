// File: alu_tb.v
// Description: Self-checking testbench for the 4-bit ALU.
//              Sweeps every opcode against every operand pair
//              (8 x 16 x 16 = 2048 vectors) and compares result,
//              zero and carry against a golden reference model.
//              Any mismatch is printed and counted; the run ends
//              with an explicit PASS/FAIL summary.

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

    // Golden reference values
    reg [3:0] exp_result;
    reg       exp_carry;
    reg       exp_zero;

    // Sweep counters and bookkeeping
    integer op, ia, ib;
    integer checks;
    integer errors;

    // Instantiate the Device Under Test
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

    // ------------------------------------------------------------
    // Golden reference model - written independently of alu.v so a
    // mismatch points at a real disagreement, not at a shared bug.
    // The 5-bit width is what makes the carry/borrow bit observable.
    // ------------------------------------------------------------
    function [4:0] ref_model;
        input [3:0] a;
        input [3:0] b;
        input [2:0] opc;
        begin
            case (opc)
                3'b000: ref_model = {1'b0, a} + {1'b0, b};  // ADD: bit 4 = carry out
                3'b001: ref_model = {1'b0, a} - {1'b0, b};  // SUB: bit 4 = borrow
                3'b010: ref_model = {1'b0, a & b};
                3'b011: ref_model = {1'b0, a | b};
                3'b100: ref_model = {1'b0, a ^ b};
                3'b101: ref_model = {1'b0, ~a};
                3'b110: ref_model = {1'b0, a << 1};         // MSB drops, carry stays 0
                3'b111: ref_model = {1'b0, a >> 1};         // LSB drops, carry stays 0
                default: ref_model = 5'b00000;
            endcase
        end
    endfunction

    // Names for readable failure messages
    function [23:0] op_name;
        input [2:0] opc;
        begin
            case (opc)
                3'b000: op_name = "ADD";
                3'b001: op_name = "SUB";
                3'b010: op_name = "AND";
                3'b011: op_name = "OR ";
                3'b100: op_name = "XOR";
                3'b101: op_name = "NOT";
                3'b110: op_name = "SHL";
                3'b111: op_name = "SHR";
                default: op_name = "???";
            endcase
        end
    endfunction

    // Compare DUT outputs against the reference for the current inputs
    task check_current;
        reg [4:0] golden;
        begin
            golden     = ref_model(A, B, opcode);
            exp_result = golden[3:0];
            exp_carry  = golden[4];
            exp_zero   = (golden[3:0] == 4'b0000);
            checks     = checks + 1;

            if (result !== exp_result || carry !== exp_carry || zero !== exp_zero) begin
                errors = errors + 1;
                $display("MISMATCH  %0s  A=%b B=%b | got result=%b zero=%b carry=%b | expected result=%b zero=%b carry=%b",
                         op_name(opcode), A, B,
                         result, zero, carry,
                         exp_result, exp_zero, exp_carry);
            end
        end
    endtask

    // ------------------------------------------------------------
    // Exhaustive sweep
    // ------------------------------------------------------------
    initial begin
        checks = 0;
        errors = 0;

        $display("-----------------------------------------------");
        $display(" 4-bit ALU - exhaustive self-checking sweep");
        $display(" 8 opcodes x 16 A values x 16 B values");
        $display("-----------------------------------------------");

        for (op = 0; op < 8; op = op + 1) begin
            for (ia = 0; ia < 16; ia = ia + 1) begin
                for (ib = 0; ib < 16; ib = ib + 1) begin
                    opcode = op[2:0];
                    A      = ia[3:0];
                    B      = ib[3:0];
                    #1;
                    check_current;
                end
            end
        end

        $display("-----------------------------------------------");
        $display(" vectors checked : %0d", checks);
        $display(" mismatches      : %0d", errors);
        if (errors == 0)
            $display(" RESULT          : PASS");
        else
            $display(" RESULT          : FAIL");
        $display("-----------------------------------------------");

        if (errors != 0) $stop;
        $finish;
    end

endmodule
