module counter #(
    parameter length = 10
)
(
    input logic clk,
    input logic cen,       // count enable when 1
    input logic ld,        // load enable when 1
    input logic u_d,       // 1: up, 0: down
    input logic [length-1:0] d_in,      // value to load into the counter
    output logic [length-1:0] q,        // current counter value
    output logic cout       // carry/borrow out
);

    always_ff @(posedge clk) begin
        if (cen) begin
            if (ld) begin
                q <= d_in;
                cout <= 0;
            end else begin
                if (u_d) begin
                    {cout, q} <= q + 1;
                end else begin
                    {cout, q} <= q - 1;
                    cout <= (q == 0); // underflow
                end
            end
        end
    end

endmodule
