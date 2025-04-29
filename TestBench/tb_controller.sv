module tb_controller;

    logic start, rst, clk, cout;
    logic NbarT, ld;

    // Instantiate DUT
    controller dut (
        .start(start),
        .rst(rst),
        .clk(clk),
        .cout(cout),
        .NbarT(NbarT),
        .ld(ld)
    );

    // T = 10ns
    always #5 clk = ~clk;

    initial begin
        $display("Starting controller test...");

        // Initialization
        clk = 0;
        rst = 1;   // start as RESET
        start = 0;
        cout = 0;
        #10;

        rst = 0;   // release reset
        #10;

        // FSM should be in RESET state → ld = 1, NbarT = 0
        if (ld == 1 && NbarT == 0)
            $display("PASS: Initial RESET state");
        else
            $display("FAIL: Initial RESET state");

        // emable start signal → next_state is TEST
        start = 1;
        #10;
        start = 0;  // pull down start，FSM should keep in TEST state

        if (ld == 0 && NbarT == 1)
            $display("PASS: Transition to TEST state");
        else
            $display("FAIL: Transition to TEST state");

        // Keep in TEST state（cout=0）
        #10;
        if (ld == 0 && NbarT == 1)
            $display("PASS: Remain in TEST state");
        else
            $display("FAIL: Remain in TEST state");

        // set cout = 1，next_state is RESET
        cout = 1;
        #10;
        cout = 0;

        if (ld == 1 && NbarT == 0)
            $display("PASS: Returned to RESET state");
        else
            $display("FAIL: Returned to RESET state");

        $display("Controller test completed.");
        $finish;
    end

endmodule
