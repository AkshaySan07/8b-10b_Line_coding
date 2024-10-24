`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:41:38 PM
// Design Name: Testbench
// Module Name: linecoding_8b10b_tb
// Project Name: PCIexpress
//////////////////////////////////////////////////////////////////////////////////


module linecoding_8b10b_tb();

reg [7:0] data_in;
reg [7:0] golden;
reg clk;
reg rst;
wire [7:0] decoded;
wire error;
wire [9:0] data_out;
wire rd;

encoder_8b10b ENC1(data_in,clk,rst,data_out,rd);
decoder_10b8b DEC1(data_out,rd,clk,rst,decoded);

assign error = (golden !== decoded) ? 1'b1:1'b0; 

initial begin
    clk = 0;
    rst = 0;
    #5 forever #5 clk = ~clk;
end

initial begin
    #10 rst = ~rst;
    repeat(40) begin
        #10 golden = data_in;
        data_in = $urandom;
    end
    #5 $finish;
end



/*always @(posedge clk or negedge rst)begin
    if(!rst) begin
        golden = 'd0;
    end
    else begin
        golden = data_in;
    end

end
*/

endmodule
