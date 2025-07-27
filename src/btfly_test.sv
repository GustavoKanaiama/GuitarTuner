`timescale 1ns / 1ps

module btfly_test;

parameter WIDTH_IN = 16;

//reg clk_in;
reg signed [WIDTH_IN-1:0] w_a_real;
reg signed [WIDTH_IN-1:0] w_a_imag;
reg signed [WIDTH_IN-1:0] w_b_real;
reg signed [WIDTH_IN-1:0] w_b_imag;

reg signed [WIDTH_IN-1:0] w_twiddle_real;
reg signed [WIDTH_IN-1:0] w_twiddle_imag;

reg signed [WIDTH_IN-1:0] w_out1_real;
reg signed [WIDTH_IN-1:0] w_out1_imag;
reg signed [WIDTH_IN-1:0] w_out2_real;
reg signed [WIDTH_IN-1:0] w_out2_imag;
 
butterfly_mod #(
    .WIDTH(WIDTH_IN)
) uut(
    //.clk(clk_in),
    .a_real(w_a_real),
    .a_imag(w_a_imag),
    .b_real(w_b_real),
    .b_imag(w_b_imag),
    
    .twiddle_real(w_twiddle_real),
    .twiddle_imag(w_twiddle_imag),
    
    
    .out1_real(w_out1_real),
    .out1_imag(w_out1_imag),
    .out2_real(w_out2_real),
    .out2_imag(w_out2_imag)
);

//Clock generation
//initial clk_in = 0;
//always #50 clk_in = ~clk_in; //10MHz Clock

//Simulação
initial begin
    $display("Starting simulation... bip bop");
    w_a_real = 0;
    w_a_imag = 0;
    w_b_real = 0;
    w_b_imag = 0;
    
    w_twiddle_real = 0;
    w_twiddle_imag = 0;
    
    
    #50
    
    send_numbers(16'h2000, 16'h4000, //a = 0.25 +i0.5
                 16'h6000, 16'h0,   //b = 0.7+ i0
                 16'hCCD,  16'h999A); // twiddle = 0.1 - i0.8
    #100;  // Added delay to allow results to stabilize
    get_results();
    #200 $finish;  // Changed to $finish
end

task send_numbers(input [WIDTH_IN-1:0] a_real_arg, input [WIDTH_IN-1:0] a_imag_arg,
    input [WIDTH_IN-1:0] b_real_arg, input [WIDTH_IN-1:0] b_imag_arg,
    input [WIDTH_IN-1:0] twiddle_real_arg, input [WIDTH_IN-1:0] twiddle_imag_arg);
    begin
        w_a_real = a_real_arg;
        w_a_imag = a_imag_arg;
        
        w_b_real = b_real_arg;
        w_b_imag = b_imag_arg;
        
        w_twiddle_real = twiddle_real_arg;
        w_twiddle_imag = twiddle_imag_arg;
        
        #50;
    end
endtask

task get_results();
  real out1_real_f, out1_imag_f;
  real out2_real_f, out2_imag_f;
  begin
    // Convert to real
    out1_real_f = $itor($signed(w_out1_real)) / 32768.0;
    out1_imag_f = $itor($signed(w_out1_imag)) / 32768.0;

    out2_real_f = $itor($signed(w_out2_real)) / 32768.0;
    out2_imag_f = $itor($signed(w_out2_imag)) / 32768.0;

    // Display
    $display("Result out1: %0.5f + i*%0.5f", out1_real_f, out1_imag_f);
    $display("Result out2: %0.5f + i*%0.5f", out2_real_f, out2_imag_f);
  end
endtask
endmodule