`default_nettype none

module ntermo (
    input wire logic CLK,
    input wire logic ENTER,
    input wire logic RESET,
    input wire logic [2:0] N0,
    input wire logic [2:0] N1,
    input wire logic [2:0] N2,
    output logic [1:0] H0,
    output logic [1:0] H1,
    output logic [1:0] H2
);

    logic rng_load;
    logic h0_enable, h1_enable, h2_enable;
    logic [1:0] h_select;
    logic [1:0] n_select;
    logic eq_r0, eq_r1, eq_r2;

    datapath dp (
        .CLK(CLK),
        .RST(RESET),
        .RNG_LOAD(rng_load),
        .H0_ENABLE(h0_enable),
        .H1_ENABLE(h1_enable),
        .H2_ENABLE(h2_enable),
        .H_SELECT(h_select),
        .N_SELECT(n_select),
        .N0(N0),
        .N1(N1),
        .N2(N2),
        .EQ_R0(eq_r0),
        .EQ_R1(eq_r1),
        .EQ_R2(eq_r2),
        .H0(H0),
        .H1(H1),
        .H2(H2)
    );

    controller controller (
        .CLK(CLK),
        .RST(RESET),
        .ENTER(ENTER),
        .EQ_R0(eq_r0),
        .EQ_R1(eq_r1),
        .EQ_R2(eq_r2),
        .RNG_LOAD(rng_load),
        .H0_ENABLE(h0_enable),
        .H1_ENABLE(h1_enable),
        .H2_ENABLE(h2_enable),
        .H_SELECT(h_select),
        .N_SELECT(n_select)
    );
endmodule : ntermo

`default_nettype wire
