module tb_multiplexer;

    // Test signals for 8-bit version (default)
    logic [7:0] normal_in_8, bist_in_8, out_8;
    logic       NbarT_8;

    // Test signals for 6-bit version (parameter override)
    logic [5:0] normal_in_6, bist_in_6, out_6;
    logic       NbarT_6;

    // DUT 1: Default WIDTH = 8
    multiplexer dut_8bit (
        .normal_in(normal_in_8),
        .bist_in(bist_in_8),
        .NbarT(NbarT_8),
        .out(out_8)
    );

    // DUT 2: Explicitly set WIDTH = 6
    multiplexer #(.WIDTH(6)) dut_6bit (
        .normal_in(normal_in_6),
        .bist_in(bist_in_6),
        .NbarT(NbarT_6),
        .out(out_6)
    );

    initial begin
        $display("MUX Test: 8-bit Version");

        // Initialize test values
        normal_in_8 = 8'hA5;  // 10100101
        bist_in_8   = 8'h3C;  // 00111100

        // Test: NbarT = 0 (expect normal_in_8)
        NbarT_8 = 0; #1;
        if (out_8 == normal_in_8)
            $display("PASS: NbarT=0 → out = %h", out_8);
        else
            $display("FAIL: NbarT=0 → out = %h (expected %h)", out_8, normal_in_8);

        // Test: NbarT = 1 (expect bist_in_8)
        NbarT_8 = 1; #1;
        if (out_8 == bist_in_8)
            $display("PASS: NbarT=1 → out = %h", out_8);
        else
            $display("FAIL: NbarT=1 → out = %h (expected %h)", out_8, bist_in_8);

        $display("MUX Test: 6-bit Version");

        // Initialize test values
        normal_in_6 = 6'b110011;
        bist_in_6   = 6'b001100;

        // Test: NbarT = 0 (expect normal_in_6)
        NbarT_6 = 0; #1;
        if (out_6 == normal_in_6)
            $display("PASS: NbarT=0 → out = %b", out_6);
        else
            $display("FAIL: NbarT=0 → out = %b (expected %b)", out_6, normal_in_6);

        // Test: NbarT = 1 (expect bist_in_6)
        NbarT_6 = 1; #1;
        if (out_6 == bist_in_6)
            $display("PASS: NbarT=1 → out = %b", out_6);
        else
            $display("FAIL: NbarT=1 → out = %b (expected %b)", out_6, bist_in_6);

        $display("MUX Test Completed");
        $finish;
    end

endmodule
