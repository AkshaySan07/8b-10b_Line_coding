`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SSwitch Technologies
// Engineer: Akshay V
// 
// Create Date: 11/04/2024 11:41:27 AM
// Design Name: Physical Layer (Logical)
// Module Name: Scrambler_23b
// Project Name: PCIexpress 3.0
//////////////////////////////////////////////////////////////////////////////////


/*
||-------------------------------------Design-Comments---------------------------------------------||
||-------------------------------------------------------------------------------------------------||
 =>(1):The LFSR reset can be activated by scram_control block if it detects certain ordereed symbols.
 =>(2):The clocks should be generated from the same PLL(therefore synchronous). Should have the same rising 
       edge.
 =>(3):We need proper control logic from enables and resets. Enables are responsible for proper sync
       between LFSR feed values and DLL_data. en_scram[1] should only go high with the posedge of clk1,
       so that there will be a full feed register by the next posedge on clk1.
 =>(4):23'h1DBFBC feed value is defined by the standard. The polynomial is also defined along with it.
*/

module scrambler_23b (
    input [7:0] DLL_data,
    input clk_1G,
    input clk_8G,
    input rst_1G,
    input rst_mod,           
    input [1:0] en_scram,
    input [1:0] lanenum,
    output [7:0] scram_data_out
);

wire [7:0] feed;
reg [7:0] scram_data, feed_reg;

LFSR_23b LR1 (clk_8G, rst_mod, en_scram[1], lanenum, feed);

assign scram_data_out = (en_scram[0]) ? (scram_data^feed_reg) : (scram_data);

always @(posedge clk_1G, negedge rst_1G) begin
    if (!rst_1G) begin
        scram_data <= 8'd0;
        feed_reg <= 8'd0;
    end
    else begin
        scram_data <= DLL_data;
        feed_reg <= feed;
    end
end

endmodule

module LFSR_23b (
    input clk_8G,
    input rst_mod,            // Active low
    input en_lfsr,           // Active high
    input [1:0] lanenu,
    output reg [7:0] feed_reg
);

reg [22:0] LR;
wire feed;

assign feed = LR[22];

always @(posedge clk_8G, negedge rst_mod) begin
    if (!rst_mod) begin
        feed_reg <= 8'd0;
    end
    else begin
        feed_reg <= {feed,feed_reg[7:1]};
    end
end

always @(posedge clk_8G, negedge rst_mod) begin
    if (!rst_mod) begin
//        if (lanenu == 0)
//        LR <= 23'h1DBFBC;
//        else if (lanenu == 1)
//        LR <= 23'h0607BB;
//        else if (lanenu == 2)
//        LR <= 23'h1EC760;
//        else
//        LR <= 23'h18C0DB;
        case(lanenu)
            2'd0 : LR <= 23'h1DBFBC;
            2'd1 : LR <= 23'h0607BB;
            2'd2 : LR <= 23'h1EC760;
            2'd3 : LR <= 23'h18C0DB;
            default : LR <= 23'h1DBFBC;
        endcase
                  
    end
    else if(en_lfsr) begin
        LR <= {LR[21],LR[22]^LR[20],LR[19:16],LR[22]^LR[15],LR[14:8],LR[22]^LR[7],LR[6:5],LR[22]^LR[4],LR[3:2],LR[22]^LR[1],LR[0],LR[22]};
    end
    else begin
        LR <= LR;
    end
end
    
endmodule
