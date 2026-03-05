// קובץ: alu_tb.v
// תיאור: קובץ בדיקה (Testbench) עבור ה-ALU
// מריץ 4 דוגמאות ומדפיס את התוצאות למסך

`timescale 1ns / 1ps   // יחידת זמן: ננו-שנייה, דיוק: פיקו-שנייה

module alu_tb;

    // משתנים שנשלח כקלט ל-ALU (reg = אנחנו שולטים בהם)
    reg [3:0] A;
    reg [3:0] B;
    reg [2:0] opcode;

    // משתנים שנקבל כפלט מה-ALU (wire = הם מחוברים לאות יוצא)
    wire [3:0] result;
    wire zero;
    wire carry;

    // חיבור מופע של ה-ALU לקובץ הבדיקה הזה
    alu uut (
        .A      (A),
        .B      (B),
        .opcode (opcode),
        .result (result),
        .zero   (zero),
        .carry  (carry)
    );

    // שמירת הסימולציה לקובץ גרפים (waveforms) — לצפייה ב-GTKWave
    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);
    end

    // -----------------------------------------------------------
    // הדפסת כותרת לטבלת התוצאות
    // -----------------------------------------------------------
    initial begin
        $display("-----------------------------------------------");
        $display(" A    B    opcode  result  zero  carry");
        $display("-----------------------------------------------");
    end

    // -----------------------------------------------------------
    // הרצת הבדיקות אחת אחרי השנייה
    // -----------------------------------------------------------
    initial begin

        // === בדיקה 1: חיבור — 3 + 5 = 8 ===
        // A = 0011 (3), B = 0101 (5), opcode 000 = ADD
        A = 4'b0011; B = 4'b0101; opcode = 3'b000;
        #10;  // ממתינים 10 ננו-שניות עד שהמעגל מתייצב
        $display("ADD:  %b + %b = %b  (עשרוני: %0d)  zero=%b carry=%b",
                  A, B, result, result, zero, carry);

        // === בדיקה 2: AND — 1100 & 1010 = 1000 ===
        // A = 1100 (12), B = 1010 (10), opcode 010 = AND
        A = 4'b1100; B = 4'b1010; opcode = 3'b010;
        #10;
        $display("AND:  %b & %b = %b  (עשרוני: %0d)  zero=%b carry=%b",
                  A, B, result, result, zero, carry);

        // === בדיקה 3: NOT — ~0011 = 1100 ===
        // A = 0011 (3), opcode 101 = NOT (B לא רלוונטי כאן)
        A = 4'b0011; B = 4'b0000; opcode = 3'b101;
        #10;
        $display("NOT:  ~%b   = %b  (עשרוני: %0d)  zero=%b carry=%b",
                  A, result, result, zero, carry);

        // === בדיקה 4: הזזה שמאלה — 0011 → 0110 ===
        // A = 0011 (3), opcode 110 = SHL (שקול לכפל ב-2 = 6)
        A = 4'b0011; B = 4'b0000; opcode = 3'b110;
        #10;
        $display("SHL:  %b <<1  = %b  (עשרוני: %0d)  zero=%b carry=%b",
                  A, result, result, zero, carry);

        $display("-----------------------------------------------");

        // סיום הסימולציה
        $finish;
    end

endmodule
