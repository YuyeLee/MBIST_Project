module bist_top #(
    parameter size   = 6,  // Address width
    parameter length = 8   // Data width
)(
    input  logic               start,       // Triggers the BIST test sequence
    input  logic               rst,
    input  logic               clk,
    input  logic               csin,        // Chip Select input (used in normal mode)
    input  logic               rwbarin,     // Read/Write control for normal mode
    input  logic               opr,         // 1 = BIST mode, 0 = normal mode
    input  logic [size-1:0]    address,     // Address input for normal mode
    input  logic [length-1:0]  datain,      // Data input for normal write operation
    output logic [length-1:0]  dataout,     // Data output from SRAM
    output logic               fail         // Indicates memory test failure during BIST
);
       // ==== Controller FSM ==== //
    controller ctrl (
        .start(start),
        .rst(rst),
        .clk(clk),
        .cout(cout),
        .NbarT(NbarT),
        .ld(ld)
    );

    // ==== Counter ==== //
    counter #(.length(10)) counter_inst (
        .d_in(10'd0),
        .clk(clk),
        .ld(ld),
        .u_d(1'b1),       // Up count
        .cen(NbarT),
        .q(q),
        .cout(cout)
    );

    assign decoder_sel = q[2:0];         // Lower 3 bits to decoder
    assign addr_bist = q[size-1:0];      // Lower bits to address

    // ==== Decoder ==== //
    decoder decoder_inst (
        .q(decoder_sel),
        .data_t(data_bist)
    );

    // ==== Multiplexers ==== //
    multiplexer #(.WIDTH(size)) mux_addr (
        .normal_in(address),
        .bist_in(addr_bist),
        .NbarT(NbarT),
        .out(addr_mux_out)
    );

    multiplexer #(.WIDTH(length)) mux_data (
        .normal_in(datain),
        .bist_in(data_bist),
        .NbarT(NbarT),
        .out(data_mux_out)
    );

    // ==== RWBAR mux ==== //
    assign rw_mux = (NbarT) ? q[6] : rwbarin;

    // ==== Chip Select ==== //
    logic cs;
    assign cs = (NbarT) ? 1'b1 : csin;

    // ==== SRAM ==== //
    smar sram_inst (
        .ramaddr(addr_mux_out),
        .ramin(data_mux_out),
        .rwbar(rw_mux),
        .clk(clk),
        .cs(cs),
        .ramout(ramout)
    );

    assign dataout = ramout;

    // ==== Comparator ==== //
    comparator cmp_inst (
        .data_t(data_bist),
        .ramout(ramout),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    // ==== Fail Logic ==== //
    always_comb begin
        if (NbarT && opr) begin
            fail = (!eq) && ((rwbarin && NbarT) || (q[6] && NbarT));
        end else begin
            fail = 1'b0;
        end
    end

endmodule