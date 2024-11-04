// Code your testbench here
// or browse Examples
module tb();
  reg [7:0] scram_data_out;
  reg clk1;
  reg rst1;
  reg clk8;
  reg rst8;
  reg [1:0] synchead;
  reg tx_start, tx_valid;

  wire data_out;
  
  Top_module_logical TL1(scram_data_out,clk1,rst1,clk8,rst8,synchead,tx_valid,tx_start,data_out);
  
  initial begin
    rst1 = 0;
    clk1 = 0;
    #1;
    forever #8 clk1 = ~clk1;
  end
  
  initial begin
    rst8 = 0;
    clk8 = 0;
    forever #1 clk8 = ~clk8;
  end
  
  /*initial begin
    scram_data_out = 8'd0;
    #25;
    repeat(20) begin
      scram_data_out = $random;
      #16;
    end
    #5 $finish;
  end*/

  initial begin
    scram_data_out = 0;
    synchead = 2'bxx;
    tx_start = 0;
    tx_valid = 0;
    #8 tx_valid = 1;
    tx_start = 0;
    repeat(16) begin
      #16 scram_data_out = $random;
    end
    tx_start = 1;
    synchead = 2'b01;
    #32 tx_start = 0;
    synchead = 2'bxx;
    repeat(16) begin
      #16 scram_data_out = $random;
    end
    #5 $finish;
  end

  
  initial begin
    #8 rst1 = 1'b1;
    rst8 = 1'b1;
  end
  
endmodule