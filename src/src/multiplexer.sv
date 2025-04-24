module multiplexer #(
    parameter WIDTH = 8  // choose 6 or 8
)(
    input  logic [WIDTH-1:0] normal_in,  // Normal operation input
    input  logic [WIDTH-1:0] bist_in,    // BIST mode input
    input  logic             NbarT,      // Select signal (0: normal, 1: BIST)
    output logic [WIDTH-1:0] out         // Selected output
);

    always_comb begin
        if (NbarT)
            out = bist_in;
        else
            out = normal_in;
    end

endmodule
