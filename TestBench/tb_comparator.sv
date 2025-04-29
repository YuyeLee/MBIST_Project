module tb_comparator;

    logic [7:0] data_t, ramout;
    logic gt, eq, lt;
    int error_count = 0;

    // Instantiate DUT
    comparator dut (
        .data_t(data_t),
        .ramout(ramout),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    // Start Testing
    initial begin
        // Test 1: data_t > ramout
        data_t = 8'd100;
        ramout = 8'd1;
        #1;
        if (gt && !eq && !lt)
            $display("PASS: Greater than");
        else begin
            $display("FAIL: Greater than");
            error_count++;
        end

        // Test 2: data_t == ramout
        data_t = 8'd100;
        ramout = 8'd100;
        #1;
        if (!gt && eq && !lt)
            $display("PASS: Equal");
        else begin
            $display("FAIL: Equal");
            error_count++;
        end

        // Test 3: data_t < ramout
        data_t = 8'd1;
        ramout = 8'd100;
        #1;
        if (!gt && !eq && lt)
            $display("PASS: Less than");
        else begin
            $display("FAIL: Less than");
            error_count++;
        end

        // Final Result
        if (error_count == 0)
            $display("PASS");
        else
            $display("FAIL");

        $finish;
    end

endmodule
