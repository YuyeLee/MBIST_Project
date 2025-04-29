module tb_decoder;

    // DUT IO
    logic [2:0] q;
    logic [7:0] data_t;

    // Instantiate DUT
    decoder dut (
        .q(q),
        .data_t(data_t)
    );

    // expected data set
    logic [7:0] expected_data [0:7] = '{
        8'b10101010,  // q = 000
        8'b01010101,  // q = 001
        8'b11110000,  // q = 010
        8'b00001111,  // q = 011
        8'b00000000,  // q = 100
        8'b11111111,  // q = 101
        8'bxxxxxxxx,  // q = 110
        8'bxxxxxxxx   // q = 111
    };

    initial begin
        $display("Starting decoder test...");

        for (int i = 0; i < 8; i++) begin
            q = i[2:0];
            #1;

            if (q < 6) begin
                if (data_t === expected_data[i])
                    $display("PASS: q=%03b, data_t=%b", q, data_t);
                else
                    $display("FAIL: q=%03b, expected=%b, got=%b", q, expected_data[i], data_t);
            end
            else begin
                if (^data_t === 1'bx)  // check if x exist
                    $display("PASS: q=%03b (invalid), data_t contains x", q);
                else
                    $display("FAIL: q=%03b (invalid), data_t should be x, got %b", q, data_t);
            end
        end

        $display("Decoder test completed.");
    end

endmodule
