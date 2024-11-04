`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2024 01:29:36 PM
// Design Name: Physical Layer (Logical)
// Module Name: decoder_10b8b
// Project Name: PCIexpress
//////////////////////////////////////////////////////////////////////////////////


module decoder_10b8b(
    input wire [9:0] data_in,
    input wire       rd,
    input wire       clk,
    input wire       rst,
    output reg [7:0] data_out);

    reg [7:0] decoded;
    reg rd_prev;

    always @(posedge clk, negedge rst) begin
        if(!rst)begin
            data_out = 8'd0;
            rd_prev = 0;
        end
        else begin
            data_out = decoded;
            rd_prev = rd;
        end
    end


    always @(*) begin
        case (rd_prev)
        1'b0: begin
            case (data_in[3:0])
                4'b1011: decoded[7:5] = 3'b000;
                4'b1001: decoded[7:5] = 3'b001;
                4'b0101: decoded[7:5] = 3'b010;
                4'b1100: decoded[7:5] = 3'b011;
                4'b1101: decoded[7:5] = 3'b100;
                4'b1010: decoded[7:5] = 3'b101;
                4'b0110: decoded[7:5] = 3'b110;
                4'b1110: decoded[7:5] = 3'b111;
                default: decoded[7:5] = 3'bxxx; // Handle default case
            endcase

            case (data_in[9:4])  // Decode the higher 6 bits first
                6'b100111: decoded[4:0] = 5'd0;
                6'b011101: decoded[4:0] = 5'd1;
                6'b101101: decoded[4:0] = 5'd2;
                6'b110001: decoded[4:0] = 5'd3;  // Does not depend on RD
                6'b110101: decoded[4:0] = 5'd4;
                6'b101001: decoded[4:0] = 5'd5;  // Does not depend on RD
                6'b011001: decoded[4:0] = 5'd6;
                6'b111000: decoded[4:0] = 5'd7;
                6'b111001: decoded[4:0] = 5'd8;
                6'b100101: decoded[4:0] = 5'd9;  // Does not depend on RD
                6'b010101: decoded[4:0] = 5'd10;
                6'b110100: decoded[4:0] = 5'd11;
                6'b001101: decoded[4:0] = 5'd12;
                6'b101100: decoded[4:0] = 5'd13;  // Does not depend on RD
                6'b011100: decoded[4:0] = 5'd14;
                6'b010111: decoded[4:0] = 5'd15;
                6'b011011: decoded[4:0] = 5'd16;
                6'b100011: decoded[4:0] = 5'd17;
                6'b010011: decoded[4:0] = 5'd18;
                6'b110010: decoded[4:0] = 5'd19;
                6'b001011: decoded[4:0] = 5'd20;
                6'b101010: decoded[4:0] = 5'd21;  // Does not depend on RD
                6'b011010: decoded[4:0] = 5'd22;
                6'b111010: decoded[4:0] = 5'd23;
                6'b001100: decoded[4:0] = 5'd24;
                6'b100110: decoded[4:0] = 5'd25;  // Does not depend on RD
                6'b010110: decoded[4:0] = 5'd26;
                6'b110110: decoded[4:0] = 5'd27;
                6'b001110: decoded[4:0] = 5'd28;
                6'b101110: decoded[4:0] = 5'd29;
                6'b011110: decoded[4:0] = 5'd30;
                6'b101011: decoded[4:0] = 5'd31;  // Does not depend on RD
                default: decoded[4:0] = 5'bxxxxx;  // Invalid case
            endcase
            end

        1'b1: begin
            case (data_in[3:0])  // Decode the lower 4 bits
                4'b0100: decoded[7:5] = 3'b000;
                4'b1001: decoded[7:5] = 3'b001;
                4'b0101: decoded[7:5] = 3'b010;
                4'b0011: decoded[7:5] = 3'b011;
                4'b0010: decoded[7:5] = 3'b100;
                4'b1010: decoded[7:5] = 3'b101;
                4'b0110: decoded[7:5] = 3'b110;
                4'b0001: decoded[7:5] = 3'b111;
                default: decoded[7:5] = 3'bxxx;  // Invalid case
            endcase

            case (data_in[9:4])  // Decode the higher 6 bits first
                6'b011000: decoded[4:0] = 5'd0;
                6'b100010: decoded[4:0] = 5'd1;
                6'b010010: decoded[4:0] = 5'd2;
                6'b110001: decoded[4:0] = 5'd3;  // Does not depend on RD
                6'b001010: decoded[4:0] = 5'd4;
                6'b101001: decoded[4:0] = 5'd5;  // Does not depend on RD
                6'b011001: decoded[4:0] = 5'd6;
                6'b000111: decoded[4:0] = 5'd7;
                6'b000110: decoded[4:0] = 5'd8;
                6'b100101: decoded[4:0] = 5'd9;  // Does not depend on RD
                6'b010101: decoded[4:0] = 5'd10;
                6'b110100: decoded[4:0] = 5'd11;
                6'b001101: decoded[4:0] = 5'd12;
                6'b101100: decoded[4:0] = 5'd13;  // Does not depend on RD
                6'b011100: decoded[4:0] = 5'd14;
                6'b101000: decoded[4:0] = 5'd15;
                6'b100100: decoded[4:0] = 5'd16;
                6'b100011: decoded[4:0] = 5'd17;
                6'b010011: decoded[4:0] = 5'd18;
                6'b110010: decoded[4:0] = 5'd19;
                6'b001011: decoded[4:0] = 5'd20;
                6'b101010: decoded[4:0] = 5'd21;  // Does not depend on RD
                6'b011010: decoded[4:0] = 5'd22;
                6'b000101: decoded[4:0] = 5'd23;
                6'b001100: decoded[4:0] = 5'd24;
                6'b100110: decoded[4:0] = 5'd25;  // Does not depend on RD
                6'b010110: decoded[4:0] = 5'd26;
                6'b001001: decoded[4:0] = 5'd27;
                6'b001110: decoded[4:0] = 5'd28;
                6'b010001: decoded[4:0] = 5'd29;
                6'b100001: decoded[4:0] = 5'd30;
                6'b010100: decoded[4:0] = 5'd31;  // Does not depend on RD
                default: decoded[4:0] = 5'bxxxxx;  // Invalid case
            endcase   
        end       
        endcase
    end


endmodule
