module tb_single_port_ram;
    logic        clk;
    logic        cs;
    logic        rwbar;
    logic [5:0]  ramaddr;
    logic [7:0]  ramin;
    logic [7:0]  ramout;

    single_port_ram uut (
        .clk(clk),
        .cs(cs),
        .rwbar(rwbar),
        .ramaddr(ramaddr),
        .ramin(ramin),
        .ramout(ramout)
    );

    // Clock
    always #5 clk = ~clk;

    initial begin
        $display("Starting SRAM Test...");
        clk = 0;
        cs = 0;
        rwbar = 0;
        ramaddr = 0;
        ramin = 0;

        // Write
        #10;
        cs = 1;
        rwbar = 0;       // write
        ramaddr = 6'd10;
        ramin = 8'hA5;
        #10;

        // Read
        rwbar = 1;
        ramin = 8'h00;   // clear ramin
        #10;

        // Check write and read operation
        if (ramout == 8'hA5)
            $display("PASS: Data correctly written and read from SRAM.");
        else
            $display("FAIL: Expected 0xA5, got %h", ramout);

        // check if cs is low, the output is 0 or not
        cs = 0;
        #10;
        if (ramout == 8'd0)
            $display("PASS: ramout = 0 when cs is low.");
        else
            $display("FAIL: ramout should be 0 when cs is low, got %h", ramout);

        $finish;
    end
endmodule
