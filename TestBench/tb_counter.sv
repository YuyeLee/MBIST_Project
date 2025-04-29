module tb_counter;

    parameter length = 10;
    logic clk, cen, ld, u_d;
    logic [length-1:0] d_in;
    logic [length-1:0] q;
    logic cout;

    // Instantiate DUT
    counter #(.length(length)) dut (
        .clk(clk),
        .cen(cen),
        .ld(ld),
        .u_d(u_d),
        .d_in(d_in),
        .q(q),
        .cout(cout)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Starting Counter Test...");
        clk = 0; cen = 0; ld = 0; u_d = 1; d_in = 0;

        // Test 1: Load value
        #10 cen = 1; ld = 1; d_in = 10'd3;
        #10 ld = 0;

        if (q == 10'd3) 
            $display("PASS: Load test");
        else 
            $display("FAIL: Load test - q = %0d", q);

        // Test 2: Count up
        #10;
        if (q == 10'd4)
            $display("PASS: Count up 1");
        else
            $display("FAIL: Count up 1 - q = %0d", q);

        #10;
        if (q == 10'd5)
            $display("PASS: Count up 2");
        else
            $display("FAIL: Count up 2 - q = %0d", q);

        // Test 3: Count down
        u_d = 0;
        #10;
        if (q == 10'd4)
            $display("PASS: Count down 1");
        else
            $display("FAIL: Count down 1 - q = %0d", q);

        #10;
        if (q == 10'd3)
            $display("PASS: Count down 2");
        else
            $display("FAIL: Count down 2 - q = %0d", q);

        // Test 4: Underflow
        ld = 1; d_in = 10'd0;
        #10 ld = 0; u_d = 0;
        #10;

        if (q == 10'h3FF && cout == 1)
            $display("PASS: Underflow detected");
        else
            $display("FAIL: Underflow - q = %0d, cout = %0b", q, cout);

        // Test 5: Disable count
        cen = 0;
        d_in = 10'd7;  // this shouldn't matter
        #10;
        if (q == 10'h3FF) // should remain unchanged
            $display("PASS: Count disable");
        else
            $display("FAIL: Count disable - q = %0d", q);

        $display("Counter Test Complete.");
        $stop;
    end

endmodule
