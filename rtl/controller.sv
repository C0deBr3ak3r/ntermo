`default_nettype none

module controller (
    input wire logic CLK,
    input wire logic RST,
    input wire logic ENTER,
    input wire logic EQ_R0,
    input wire logic EQ_R1,
    input wire logic EQ_R2,
    output logic RNG_LOAD,
    output logic H0_ENABLE,
    output logic H1_ENABLE,
    output logic H2_ENABLE,
    output logic [1:0] H_SELECT,
    output logic [1:0] N_SELECT
);
`ifdef WAIT_SCORE
    typedef enum {
        RESET,
        COMPARE_N2,
        COMPARE_N1,
        COMPARE_N0,
        WAIT_SCORE,
        WAIT_ENTER
    } state_t;
`else
    typedef enum {
        RESET,
        COMPARE_N2,
        COMPARE_N1,
        COMPARE_N0,
        WAIT_ENTER
    } state_t;
`endif

    state_t current_state;
    state_t next_state;

    always_ff @(posedge CLK or posedge RST) begin : SYNC
        if (RST) begin
            current_state <= RESET;
        end else begin
            current_state <= next_state;
        end
    end

    always_comb begin : COMB
        RNG_LOAD  = 1'b0;
        H0_ENABLE = 1'b0;
        H1_ENABLE = 1'b0;
        H2_ENABLE = 1'b0;
        H_SELECT  = 2'b00;
        N_SELECT  = 2'b01;

        unique case (current_state)
            RESET: begin
                H0_ENABLE = 1'b0;
                H1_ENABLE = 1'b0;
                H2_ENABLE = 1'b0;
                H_SELECT  = 2'b00;
                N_SELECT  = 2'b01;
                if (ENTER) begin
                    RNG_LOAD   = 1'b0;
                    next_state = COMPARE_N2;
                end else begin
                    RNG_LOAD   = 1'b1;
                    next_state = RESET;
                end
            end

            COMPARE_N2: begin
                H2_ENABLE  = 1'b1;
                N_SELECT   = 2'b10;
                next_state = COMPARE_N1;
                if (EQ_R2) begin
                    H_SELECT = 2'b10;
                end else if (EQ_R1 || EQ_R0) begin
                    H_SELECT = 2'b01;
                end else begin
                    H_SELECT = 2'b00;
                end
            end

            COMPARE_N1: begin
                H1_ENABLE  = 1'b1;
                N_SELECT   = 2'b11;
                next_state = COMPARE_N0;
                if (EQ_R1) begin
                    H_SELECT = 2'b10;
                end else if (EQ_R2 || EQ_R0) begin
                    H_SELECT = 2'b01;
                end else begin
                    H_SELECT = 2'b00;
                end
            end

            COMPARE_N0: begin
                H0_ENABLE = 1'b1;
`ifdef WAIT_SCORE
                next_state = WAIT_SCORE;
`else
                next_state = WAIT_ENTER;
`endif
                if (EQ_R0) begin
                    H_SELECT = 2'b10;
                end else if (EQ_R2 || EQ_R1) begin
                    H_SELECT = 2'b01;
                end else begin
                    H_SELECT = 2'b00;
                end
            end

`ifdef WAIT_SCORE
            WAIT_SCORE: begin
                N_SELECT   = 2'b01;
                next_state = WAIT_ENTER;
            end
`endif

            WAIT_ENTER: begin
                N_SELECT = 2'b01;
                if (ENTER) begin
                    next_state = COMPARE_N2;
                end else begin
                    next_state = WAIT_ENTER;
                end
            end

        endcase
    end
endmodule : controller

`default_nettype wire
