module single_port_ram(
    input logic [5:0] ramaddr,  // address for memory
    input logic [7:0] ramin,    // Data to be written into memory
    input logic rwbar,          // 0= write, 1 = read
    input logic clk,            // Clock signal (rising edge triggered)
    input logic cs,             // Active high chip select
    output logic [7:0] ramout   // Data read from memory
);
    logic [7:0] ram [0:63];      // 64 x 8-bit memory
    logic [5:0] addr_reg;

    always_ff@(posedge clk) begin
        if(cs) begin
            addr_reg <= ramaddr;
            if(!rwbar) begin
                ram[ramaddr] <= ramin;
            end
        end
    end

    always_comb begin
        if(!cs || !rwbar)begin
            ramout = 8'b0;
        end
        else begin 
            ramout = ram[addr_reg];
        end
    end
endmodule