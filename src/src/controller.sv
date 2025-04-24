module controller
(
    input logic start,      // Triggers the BIST process, 1 -> start
    input logic rst,        // Resets the FSM to idle state
    input logic clk,        // Clock
    input logic cout,       // Signals test completion
    output logic NbarT,     // 1 during test phase
    output logic ld         // 1 during reset phase (loads counter)
);

    typedef enum logic {RESET, TEST} state_t;
    state_t current_state, next_state;

    always_ff(posedge clk or posedge rst) begin
        if(rst)
            current_state <= RESET;
        else
            current_state <= next_state;
    end

    always_comb begin
        case(current_state)
            RESET: begin
                if (start)
                    next_state = TEST;
                else
                    next_state = RESET;
            end

            TEST: begin
                if(cout)
                    next_state = RESET;
                else
                    next_state = TEST;
            end

            default: next_state = RESET;
        endcase
    end

    always_comb begin
        case(current_state)
            RESET: begin
                NbarT = 0;
                ld = 1;
            end

            TEST: begin
                NbarT = 1;
                ld = 0;
            end

            default: begin
                NbarT = 0;
                ld = 0;
            end
        endcase
    end
endmodule