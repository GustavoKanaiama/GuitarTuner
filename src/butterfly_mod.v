module butterfly_mod #(
    parameter WIDTH = 16
)(
    //input clk,
    
    input signed [WIDTH-1:0] a_real,
    input signed [WIDTH-1:0] a_imag,
    input signed [WIDTH-1:0] b_real,
    input signed [WIDTH-1:0] b_imag,
    
    input signed [WIDTH-1:0] twiddle_real,
    input signed [WIDTH-1:0] twiddle_imag,

    output signed [WIDTH-1:0] out1_real,
    output signed [WIDTH-1:0] out1_imag,
    output signed [WIDTH-1:0] out2_real,
    output signed [WIDTH-1:0] out2_imag
);

    // Intermediate wires for b * twiddle
    wire signed [2*WIDTH-1:0] mult_br_tr = b_real * twiddle_real;
    wire signed [2*WIDTH-1:0] mult_bi_ti = b_imag * twiddle_imag;
    wire signed [2*WIDTH-1:0] mult_br_ti = b_real * twiddle_imag;
    wire signed [2*WIDTH-1:0] mult_bi_tr = b_imag * twiddle_real;

    // b * twiddle results
    wire signed [2*WIDTH:0] bw_real = mult_br_tr - mult_bi_ti;
    wire signed [2*WIDTH:0] bw_imag = mult_br_ti + mult_bi_tr;

    // Scale back to WIDTH bits (you might need to adjust shift depending on your fixed point format)
    wire signed [WIDTH-1:0] b_tw_real = bw_real >>> (WIDTH-1);
    wire signed [WIDTH-1:0] b_tw_imag = bw_imag >>> (WIDTH-1);

    // Butterfly computation
    assign out1_real = a_real + b_tw_real;
    assign out1_imag = a_imag + b_tw_imag;

    assign out2_real = a_real - b_tw_real;
    assign out2_imag = a_imag - b_tw_imag;

endmodule
