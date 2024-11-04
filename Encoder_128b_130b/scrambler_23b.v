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
 => The LFSR reset can be activated by scram_control block if it detects certain ordereed symbols.
 => We need proper control logic from enables and resets. Enables are responsible for proper sync
    between LFSR feed values and DLL_data. en_scram[1] should only go high with the posedge of clk1,
    so that there will be a full feed register by the next posedge on clk1.
 => 23'h1DBFBC feed value is defined by the standard. The polynomial is also defined along with it.
*/

module scrambler_23b(
    input [7:0] DLL_data,
    input clk_1G,
    input clk_8G,
    input rst_1G,
    input rst_mod,           
    input [1:0] en_scram,
    output [7:0] scram_data_out
);

wire [7:0] feed;
reg [7:0] scram_data, feed_reg;

LFSR_23b LR1(clk_8G, rst_mod, en_scram[1], feed);

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
        feed_reg <= {feed_reg[6:0],feed};
    end
end

always @(posedge clk_8G, negedge rst_mod) begin
    if (!rst_mod) begin
        LR <= 23'h1DBFBC;                
    end
    else if(en_lfsr) begin
        LR <= {LR[21],LR[22]^LR[20],LR[19:16],LR[22]^LR[15],LR[14:8],LR[22]^LR[7],LR[6:5],LR[22]^LR[4],LR[3:2],LR[22]^LR[1],LR[0],LR[22]};
    end
    else begin
        LR <= LR;
    end
end
    
endmodule
