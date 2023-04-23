`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.04.2023 20:06:12
// Design Name: 
// Module Name: IIR_Filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IIR_Filter(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
    );
    // coefficients definition
    // IIR Low-pass filter, 2nd order
    // three feedforward coefficients
    // three feedback coefficients
    // 0.25 x 128(scaling factor) = 32 = 6'b100000
    wire [5:0] b0 = 6'b000001; 
    wire [5:0] b1 = 6'b000001; 
    wire [5:0] b2 = 6'b000001; 
    wire [5:0] b3 = 6'b000001; 
    wire [5:0] a1 = 6'b111111; 
    wire [5:0] a2 = 6'b111111;
    
    wire [15:0] x1, x2, x3, y1, y2;
    
    // Create delays i.e x[n-1], x[n-2], y[n-1], y[n-2]
    // Instantiate D Flip Flops
    DFF DFF_x1(clk, reset, data_in, x1); // x[n-1]
    DFF DFF_x2(clk, reset, x1, x2);      // x[n-2]
    DFF DFF_x3(clk, reset, x2, x3);      // x[n-3]
    DFF DFF_y1(clk, reset, 0, y1);       // y[n-1]
    DFF DFF_y2(clk, reset, 0, y2);       // y[n-2] 
    
    //  Multiplication
    wire [15:0] Mul_b0, Mul_b1, Mul_b2, Mul_b3, Mul_a1, Mul_a2;  
    assign Mul_b0 = data_in * b0; 
    assign Mul_b1 = x1 * b1;  
    assign Mul_b2 = x2 * b2; 
    assign Mul_b3 = x3 * b3; 
    assign Mul_a1 = y1 * a1; 
    assign Mul_a2 = y2 * a2; 
    
    // Adder
    wire [15:0] Adder1, Adder2, Adder3; 
    assign Adder1 = Mul_b0 + Mul_b1 + Mul_b2 + Mul_b3;
    assign Adder2 = Mul_a1 + Mul_a2; 
    assign Adder3 = Adder1 - Adder2; 

    // Final calculation to output 
    always@(posedge clk)
    begin
        data_out <= Adder3;
    end
       
endmodule

module DFF(clk, reset, data_in, data_delayed);
    input clk, reset;
    input [15:0] data_in;
    output reg [15:0] data_delayed; 

    always@(posedge clk, posedge reset)
    begin
        if (reset)
            data_delayed <= 0;
        else
            data_delayed <= data_in; 
    end
endmodule
