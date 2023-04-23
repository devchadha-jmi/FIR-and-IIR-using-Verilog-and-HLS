`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2023 17:31:50
// Design Name: 
// Module Name: FIR_Filter
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


module FIR_Filter(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [15:0] data_out
    );
    
    // coefficients defination
    // Moving Average Filter, 3rd order
    // four coefficients; 1/(order+1) = 1/4 = 0.25 
    // 0.25 x 128(scaling factor) = 32 = 6'b100000
    wire [5:0] b0 =  6'b100000; 
    wire [5:0] b1 =  6'b100000; 
    wire [5:0] b2 =  6'b100000; 
    wire [5:0] b3 =  6'b100000;
    wire [15:0] x1, x2, x3;
    
    // Create delays i.e x[n-1], x[n-2], .. x[n-N]
    // Instantiate D Flip Flops
    DFF DFF0(clk, 0, data_in, x1); // x[n-1]
    DFF DFF1(clk, 0, x1, x2);      // x[n-2]
    DFF DFF2(clk, 0, x2, x3);      // x[n-3] 
    
    //  Multiplication
    wire [15:0] Mul0, Mul1, Mul2, Mul3;  
    assign Mul0 = data_in * b0; 
    assign Mul1 = x1 * b1;  
    assign Mul2 = x2 * b2;  
    assign Mul3 = x3 * b3;  
 
// Addition operation
    wire [15:0] Add_final; 
    assign Add_final = Mul0 + Mul1 + Mul2 + Mul3; 

  // Final calculation to output 
   always@(posedge clk)
    data_out <= Add_final; 
    
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