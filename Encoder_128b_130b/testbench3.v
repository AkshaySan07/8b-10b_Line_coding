`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/29/2024 11:48:49 AM
// Design Name: 
// Module Name: tb_encode_seri
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


module tb_encode_seri();
  reg [7:0] DLL_data;
  reg clk1;
  reg rst1;
  reg clk8;
  reg rst8;
  reg k;
  reg tx_start, tx_valid;
  reg [1:0] en_scram;
  reg rst_mod;

  wire data_out;
  
 
  Top_module_logical_Tx1 TL1(clk1,clk8,rst1,rst8,rst_mod,k,tx_valid,tx_start,DLL_data,en_scram,data_out);
  
  initial begin
    rst1 = 0;
    rst_mod = 0;
    clk1 = 0;
    #1;
    forever #8 clk1 = ~clk1;
  end
  
  initial begin
    rst8 = 0;
    clk8 = 0;
    forever #1 clk8 = ~clk8;
  end

  initial begin
    DLL_data = 0;
    k = 1'bx;
    tx_start = 0;
    #9 tx_start = 0;
    repeat(16*68) begin
       DLL_data = $random;
       #16;
    end
    
    #5 $finish;
  end
  
  initial begin
    #9 tx_start = 1;
    k = 1'b1;
    #2 tx_start = 0;
    k = 1'bx;
    repeat(68) begin
    #254;
    tx_start = 1;
    k = 1'b0;
    #2 tx_start = 0;
    k = 1'bx;
    end
  end
  
  initial begin
    tx_valid = 0;
    en_scram = 0;
    #9 tx_valid = 1;
    en_scram = 2'd3;
    #16384 tx_valid = 0;
  end

  
  initial begin
    #8 rst1 = 1'b1;
    rst8 = 1'b1;
    rst_mod = 1'b1;
  end
  
endmodule
