`default_nettype none

module rng (
    input wire logic CLK,
    input wire logic RST,
    input wire logic [2:0] N2,
    input wire logic [2:0] N1,
    input wire logic [2:0] N0,
    output logic [2:0] R2,
    output logic [2:0] R1,
    output logic [2:0] R0
);
    logic [8:0] count;

    always_ff @(posedge CLK or posedge RST) begin : COUNTER
        if (RST) begin
            count <= 9'd0;
        end else begin
            count <= count + 1;
        end
    end

    always_comb begin
        R2 = count[8:6] ^ N2;
        R1 = count[5:3] ^ N1;
        R0 = count[2:0] ^ N0;
    end
endmodule : rng

module mux #(
    parameter type T = logic,
    parameter int INPUT_COUNT = 4
) (
    input wire integer SEL,
    input wire T [(INPUT_COUNT - 1):0] DATA_IN,
    output T DATA_OUT
);
    always_comb begin
        DATA_OUT = DATA_IN[SEL];
    end
endmodule : mux

module register #(
    parameter int WORD_WIDTH = 3
) (
    input wire logic CLK,
    input wire logic RST,
    input wire logic LD,
    input wire logic [(WORD_WIDTH - 1):0] D,
    output logic [(WORD_WIDTH - 1):0] Q
);
    always_ff @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= '0;
        end else if (LD) begin
            Q <= D;
        end
    end
endmodule : register

module datapath (
    input wire logic CLK,
    input wire logic RST,
    input wire logic RNG_LOAD,
    input wire logic H0_ENABLE,
    input wire logic H1_ENABLE,
    input wire logic H2_ENABLE,
    input wire logic [1:0] H_SELECT,
    input wire logic [1:0] N_SELECT,
    input wire logic [2:0] N0,
    input wire logic [2:0] N1,
    input wire logic [2:0] N2,
    output logic EQ_R0,
    output logic EQ_R1,
    output logic EQ_R2,
    output logic [1:0] H0,
    output logic [1:0] H1,
    output logic [1:0] H2
);
    logic [2:0] reg_q0, reg_q1, reg_q2;
    logic [2:0] r0, r1, r2;
    logic [1:0] h_data;
    logic [1:0] n_select_reg;
    logic [2:0] n_data;

    register #(
        .WORD_WIDTH(3)
    ) reg_r0 (
        .CLK(CLK),
        .RST(RST),
        .LD (RNG_LOAD),
        .D  (r0),
        .Q  (reg_q0)
    );

    register #(
        .WORD_WIDTH(3)
    ) reg_r1 (
        .CLK(CLK),
        .RST(RST),
        .LD (RNG_LOAD),
        .D  (r1),
        .Q  (reg_q1)
    );

    register #(
        .WORD_WIDTH(3)
    ) reg_r2 (
        .CLK(CLK),
        .RST(RST),
        .LD (RNG_LOAD),
        .D  (r2),
        .Q  (reg_q2)
    );

    register #(
        .WORD_WIDTH(2)
    ) reg_h0 (
        .CLK(CLK),
        .RST(RST),
        .LD (H0_ENABLE),
        .D  (h_data),
        .Q  (H0)
    );

    register #(
        .WORD_WIDTH(2)
    ) reg_h1 (
        .CLK(CLK),
        .RST(RST),
        .LD (H1_ENABLE),
        .D  (h_data),
        .Q  (H1)
    );

    register #(
        .WORD_WIDTH(2)
    ) reg_h2 (
        .CLK(CLK),
        .RST(RST),
        .LD (H2_ENABLE),
        .D  (h_data),
        .Q  (H2)
    );

    register #(
        .WORD_WIDTH(2)
    ) reg_n_select (
        .CLK(CLK),
        .RST(RST),
        .LD (1'b1),
        .D  (N_SELECT),
        .Q  (n_select_reg)
    );

    mux #(
        .T(logic [2:0]),
        .INPUT_COUNT(4)
    ) mux_n (
        .SEL(integer'(n_select_reg)),
        .DATA_IN({N0, N1, N2, 3'b000}),
        .DATA_OUT(n_data)
    );

    mux #(
        .T(logic [1:0]),
        .INPUT_COUNT(4)
    ) mux_h (
        .SEL(integer'(H_SELECT)),
        .DATA_IN({2'b00, 2'b10, 2'b01, 2'b00}),
        .DATA_OUT(h_data)
    );

    rng rng_inst (
        .CLK(CLK),
        .RST(RST),
        .N2 (N2),
        .N1 (N1),
        .N0 (N0),
        .R2 (r2),
        .R1 (r1),
        .R0 (r0)
    );

    always_comb begin
        EQ_R0 = 1'b0;
        EQ_R1 = 1'b0;
        EQ_R2 = 1'b0;

        if (reg_q0 == n_data) begin
            EQ_R0 = 1'b1;
        end

        if (reg_q1 == n_data) begin
            EQ_R1 = 1'b1;
        end

        if (reg_q2 == n_data) begin
            EQ_R2 = 1'b1;
        end
    end
endmodule : datapath

`default_nettype wire
