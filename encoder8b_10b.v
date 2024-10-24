`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SSwitch Technologies
// Engineer: Akshay V
// 
// Create Date: 10/09/2024 11:38:49 PM
// Design Name: Phsical Layer (Logical)
// Module Name: encoder8b_10b
// Project Name: PCIexpress
//////////////////////////////////////////////////////////////////////////////////


module encoder_8b10b (
    input wire [7:0] data_in,
    input wire       clk,
    input wire       rst,
    output reg [9:0] data_out,
    output reg       rd);

    wire [9:0] encoded;
    reg [3:0] count; 
    reg       new_rd;

    table_8b10b TB1(data_in,rd,encoded);

    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            data_out <= 10'd0;
            rd <= 1'b0;  
        end
        else begin
            data_out <= encoded;
            rd <= new_rd;
        end
    end

    always @(*) begin
        count = noofones(encoded);
        
        if(count > 4'd5)
            new_rd = 1'b1;
        else if(count < 4'd5)
            new_rd = 1'b0;
        else 
            new_rd = rd;       // count == 5 then equal number of 0's and 1's. We retain the previous value
            
    end
    
    function integer noofones(input [9:0] enc);
        integer j;
        integer ones;
        begin
            ones = 0;
            for (j = 0; j < 10; j = j + 1) begin
                ones = ones + enc[j];  // Increment count for every '1' found in the vector
            end
            noofones = ones;
        end        
    endfunction

endmodule