`timescale 1ns/1ps

module tb_bist;

  parameter size = 6;
  parameter length = 8;

  logic start, rst, clk;
  logic csin, rwbarin, opr;
  logic [size-1:0] address;
  logic [length-1:0] datain;
  logic [length-1:0] dataout;
  logic fail;

  // DUT Instance
  bist #(.size(size), .length(length)) dut (
    .start(start),
    .rst(rst),
    .clk(clk),
    .csin(csin),
    .rwbarin(rwbarin),
    .opr(opr),
    .address(address),
    .datain(datain),
    .dataout(dataout),
    .fail(fail)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    $display("===== Starting BIST Testbench =====");
    clk = 0; 
    rst = 1;
    csin = 0; 
    rwbarin = 0; 
    opr = 0;
    address = 0; 
    datain = 0;
    start = 0;

    // Phase 1: Initialization
    #10 rst = 0;
    #10 rst = 1;
    #10;

    // Phase 2: Normal Mode Write
    csin = 1;
    opr = 0;
    rwbarin = 0;       // write
    address = 6'd5;
    datain = 8'hDE;
    #10;

    // Phase 3: Normal Mode Read
    rwbarin = 1;       // read
    datain = 8'h00;
    #10;

    if (dataout == 8'hDE)
      $display("PASS: Normal mode write/read successful.");
    else
      $display("FAIL: Normal mode read returned %h", dataout);

    // Phase 4: BIST Start
    opr = 1;     // BIST mode
    start = 1;
    #10 start = 0;

    // Phase 5: BIST Run - let it run ~100 cycles
    repeat (100) @(posedge clk);
    if (!fail)
      $display("PASS: BIST run completed with no fault.");
    else
      $display("FAIL: BIST incorrectly flagged error.");

    // Phase 6: Inject Fault - forcibly overwrite SRAM inside DUT
    force dut.sram_inst.ram[6'd3] = 8'hFF; // should not match expected decoder pattern
    $display("INJECT: Fault injected at address 3.");

    // Phase 7: Re-check with BIST
    start = 1;
    #10 start = 0;
    repeat (100) @(posedge clk);
    if (fail)
      $display("PASS: BIST correctly detected the injected fault.");
    else
      $display("FAIL: BIST failed to detect the fault.");

    $display("===== Testbench Completed =====");
    $finish;
  end
endmodule
