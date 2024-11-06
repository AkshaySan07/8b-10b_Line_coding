`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SSwitch Technologies
// Engineer: Akshay V
// 
// Create Date: Create Date: 11/5/2024 2:30:42 AM
// Design Name: Physical Layer (Logical)
// Module Name: Top_module_logical
// Project Name: PCIexpress 3.0
//////////////////////////////////////////////////////////////////////////////////

//------------------------------Pending tickets---------------------------------//
//=>The scrambling is not implimented on the first data byte figure out if its a
//  feature or bug. Try to fix it.
//
//------------------------------------------------------------------------------//

//----------------------------Design Constraints--------------------------------//
//(1):The clocks should be generated from the same PLL(therefore synchronous) 
//    ,should also the same rising edge.
//(2):PISO convertion will add latency of 1 clock cycle(1G).
//(3):We are expecting the tx_valid signal to be on for a 'HIGH' for a maximum of
//    63 blocks. Hence maximum packet size can be of 4032 bytes.
//(4):Tx_start is a 1 clock cycle pulse(8G) that arrives at the start of every 
//    data block(16 bytes, by data block we mean both data & ordered sets).
//(5):For 4 lane we need 2 clocks, one of 250MHz(1G) and 2GHz(8G).
//(6):Enable signals form the scram control are being driven by testbench for now.
//(7):The LFSR only starts when the tx_valid is high.   
//------------------------------------------------------------------------------//


module Top_module_logical_Tx1(
    input clk_1G,
    input clk_8G,
    input rst_1G,
    input rst_8G,
    input rst_mod,
    input k,
    input tx_valid,
    input tx_start,
    input [7:0] DLL_data,
    input [1:0] en_scram,
    output data_out
);

wire serial_data;
wire [7:0] scram_data_out;

wire sy2;
wire syblk2;
wire sy_v;

scrambler_23b SC1(DLL_data, clk_1G, clk_8G, rst_1G, rst_mod, en_scram, scram_data_out); // 23 bit LFSR with different seed values based on the lane number.
header_synchronizer1 HS1(clk_8G, rst_8G, tx_start, tx_valid, k, sy2, syblk2, sy_v);
//scram_control SC1(DLL_data, clk_1G, rst_1G, en_scram); // Blackbox this for now, write the control based on scrambling rules. 1 bit should be used for not forwarding LFSR, 1 bit for not scrambling.
piso_serial8b1 PI1(scram_data_out, clk_1G, rst_1G, clk_8G, rst_8G, serial_data); // Continuous serialization of bits without any delay between cycles
fifo_sync1     ff1(serial_data, clk_8G, rst_8G, sy2, sy_v, syblk2, data_out); 

    
endmodule


module header_synchronizer1 (
    input clk_8G,
    input rst_8G,
    input tx_start,
    input tx_valid,
    input k,
    output tx_s,
    output k_synced,
    output tx_v);

reg [8:0] syblk;
reg [8:0] syhhh;
reg [8:0] sy1;

assign tx_s = syblk[8];
assign k_synced = sy1[8];
assign tx_v = syhhh[8];

always @(posedge clk_8G,negedge rst_8G) begin
        if(!rst_8G) begin
            syblk <= 0;
            sy1 <= 0;
            syhhh <= 0;
        end
        else begin
            syblk <= {syblk[7:0],tx_start};
            sy1 <= {sy1[7:0],k};
            syhhh <= {syhhh[7:0],tx_valid};
        end    
    end    
    
endmodule



module piso_serial8b1 (
    input [7:0] scram_data_out,
    input clk_1G,
    input rst_1G,
    input clk_8G,
    input rst_8G,
    output serial_data
);

    reg [7:0] piso;
    reg [2:0] i;

    assign serial_data = piso[i]; 

    always @(posedge clk_1G, negedge rst_1G) begin
        if (!rst_1G) begin
            piso <= 8'd0;
        end
        else begin
            piso <= scram_data_out;
        end
    end

    always @(posedge clk_8G, negedge rst_8G) begin
        if (!rst_8G) begin
            i <= 7;
        end
        else begin
            i <= i+1;
        end
    end
    
endmodule


/*
module fifo_sync1 (
    input serial_data,
    input clk_8G,
    input rst_8G,
    input tx_start,
    input tx_valid,
    input k_synced,
    output fifo_out
);

reg [127:0] mem;
reg [7:0] wptr;
reg [7:0] rptr;
wire full,empty;
wire [1:0] sync_head;
wire rst_gen;


//assign rst_gen = tx_valid & rst_8G;
assign sync_head = (k_synced) ? 2'b01 : 2'b10;

//assign full = ({!wptr[9],wptr[8:0]} == rptr-9'd1 || {!wptr[9],wptr[8:0]} == rptr) ? 1'b1 : 1'b0;
assign full = (({!wptr[7],wptr[6:0]} == (rptr-8'd1)) && (tx_start == 1)) ? 1'b1 : 1'b0;
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;
assign fifo_out = (!empty) ? mem[rptr[6:0]] : 1'b0;

always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        wptr <= 8'd0;
        rptr <= 8'd0;
    end
    else if(tx_start) begin
        wptr <= (!full && tx_valid) ? (wptr + 8'd3) : (wptr);
        rptr <= (!empty) ? (rptr + 8'd1) : (rptr);
    end
    else begin
        wptr <= (!full && tx_valid) ? (wptr + 8'd1) : (wptr);
        rptr <= (!empty) ? (rptr + 8'd1) : (rptr);
    end
end

always @(posedge clk_8G) begin
    if (tx_start && tx_valid && !full) begin
        mem[wptr[6:0]+7'd2] <= serial_data;
        mem[wptr[6:0]+7'd1] <= sync_head[1];
        mem[wptr[6:0]] <= sync_head[0];
    end
    else if(tx_valid && !full) begin
        mem[wptr[6:0]] <= serial_data;
    end
    else begin
        mem[wptr[6:0]] <= wptr[wptr[6:0]];
    end
end
    
endmodule
*/

module fifo_sync1 (
    input serial_data,
    input clk_8G,
    input rst_8G,
    input tx_start,
    input tx_valid,
    input k_synced,
    output fifo_out
);

reg [129:0] mem;
reg [8:0] wptr;
reg [8:0] rptr;
wire full,empty;
wire [1:0] sync_head;
wire rst_gen;


//assign rst_gen = tx_valid & rst_8G;
assign sync_head = (k_synced) ? 2'b01 : 2'b10;

//assign full = ({!wptr[9],wptr[8:0]} == rptr-9'd1 || {!wptr[9],wptr[8:0]} == rptr) ? 1'b1 : 1'b0;
assign full = (({!wptr[8],wptr[7:0]} == (rptr[7:0]-8'd1)) && (tx_start == 1)) ? 1'b1 : 1'b0;
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;
assign fifo_out = (!empty) ? mem[rptr[6:0]] : (tx_start ? sync_head[0] : 1'b0);

always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        rptr <= 9'd0;
    end
    else if (rptr[7:0] == 8'd130) begin
        rptr <= {~rptr[8],8'd0};
    end
    else if(tx_start) begin
        rptr <= (!empty) ? ({rptr[8],rptr[7:0] + 8'd1}) : rptr;
    end
    else begin
        rptr <= (!empty) ? ({rptr[8],rptr[7:0] + 8'd1}) : (rptr);
    end
end
always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        wptr <= 9'd0;
    end
    else if (wptr[7:0] == 8'd130) begin
        wptr <= {~wptr[8],8'd0};
    end
    else if(tx_start) begin
        wptr <= (!full && tx_valid) ? ((!empty) ? ({wptr[8],wptr[7:0] + 8'd3}) : ({wptr[8],wptr[7:0]+8'd2})) : (wptr);
    end
    else begin
        wptr <= (!full && tx_valid) ? ({wptr[8],wptr[7:0] + 8'd1}) : (wptr);
    end
end

always @(posedge clk_8G) begin
    if (tx_start && tx_valid && !full) begin
        mem[wptr[6:0]+7'd1] <= serial_data;
        mem[wptr[6:0]] <= sync_head[1];
    end
    else if(tx_valid && !full) begin
        mem[wptr[6:0]] <= serial_data;
    end
    else begin
        mem[wptr[6:0]] <= wptr[wptr[6:0]];
    end
end
    
endmodule


