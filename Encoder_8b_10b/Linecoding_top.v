`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:34:54 PM
// Design Name: 
// Module Name: linecoding_top
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


module linecoding_top(
    input wire [7:0] data_in,
    input wire       clk,
    input wire       rst,
    output wire [7:0] decoded);
    
    wire rd;
    wire [9:0] data_out;
    
    encoder_8b10b EN1(data_in,clk,rst,data_out,rd);
    decoder_10b8b DE1(data_out,rd,clk,rst,decoded);
    
endmodule
