`timescale 1ns / 1ps

module b8_10b_tb();
    reg [7:0] data_in;
    reg       clk;
    reg       rst;
    wire [9:0] data_out;
    wire       rd;
    integer i;
    
    encoder_8b10b ecd1(data_in,clk,rst,data_out,rd);
    
    initial begin
        clk = 1;
        rst = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        #20 rst = 1;
        #25
        repeat(40)begin
            #10 data_in = $urandom;
        end
    end
    initial begin
        $monitor("At time ",$time," data_in = %b, encoded = %b, rd = %d",data_in,data_out,rd);
    end
    
endmodule
