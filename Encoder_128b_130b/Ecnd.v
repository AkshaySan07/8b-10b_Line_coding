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
    input [31:0] DLL_data,
    input [1:0] en_scram,
    output data_out0,
    output data_out1,
    output data_out2,
    output data_out3
);


wire serial_data[3:0];
wire [7:0] scram_data_out[3:0];

wire sy_s;
wire sy_k;
wire sy_v;
wire sy_spul;
wire [7:0] Lane [3:0];
wire data_out[3:0];
wire rst_gen;
wire [1:0] lanenum [3:0];

assign rst_gen = rst_8G & rst_mod;
assign {data_out3,data_out2,data_out1,data_out0} = {data_out[3],data_out[2],data_out[1],data_out[0]};

byte_striping BT1(DLL_data, clk_1G, rst_1G, Lane[0], Lane[1], Lane[2], Lane[3]);
header_synchronizer1 HS1(clk_1G, rst_1G, tx_start, tx_valid, k, sy_s, sy_k, sy_v);
levtopulse LP1(clk_8G, rst_8G, sy_s, sy_spul);

genvar i;
generate for(i=0;i<4;i=i+1) begin : instanses
    assign lanenum[i] = i;
    scrambler_23b SC1 (Lane[i], clk_1G, clk_8G, rst_1G, rst_mod, en_scram, lanenum[i], scram_data_out[i]); // 23 bit LFSR with different seed values based on the lane number.
    //LTSSM SC1(DLL_data, clk_1G, rst_1G, en_scram); // Blackbox this for now, write the control based on scrambling rules. 1 bit should be used for not forwarding LFSR, 1 bit for not scrambling.
    piso_serial8b1 PI1(scram_data_out[i], clk_1G, rst_1G, clk_8G, rst_8G, serial_data[i]); // Continuous serialization of bits without any delay between cycles
    fifo_sync1     ff1(serial_data[i], clk_8G, rst_8G, sy_spul, sy_v, sy_k, data_out[i]); 
    end
endgenerate
    
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

reg [2:0] syblk;
reg [2:0] syhhh;
reg [2:0] sy1;

assign tx_s = syblk[1];
assign k_synced = sy1[2];
assign tx_v = syhhh[2];

always @(posedge clk_8G,negedge rst_8G) begin
    if(!rst_8G) begin
        syblk <= 0;
        sy1 <= 0;
        syhhh <= 0;
    end
    else begin
        syblk <= {syblk[1:0],tx_start};
        sy1 <= {sy1[1:0],k};
        syhhh <= {syhhh[1:0],tx_valid};
    end    
end    
    
endmodule

module levtopulse (
    input clk_8G,
    input rst_8G,
    input lev,
    output pulse
);

reg state;

assign pulse = (state & ~lev);

always @(posedge clk_8G,negedge rst_8G) begin
    if(!rst_8G) begin
        state <= 1'b0;
       // pulse <= 1'b0;
    end
    else begin
        state <= lev;
       // pulse <= (~state & lev);
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
            i <= 3'd7;
        end
        else begin
            i <= i + 3'd1;
        end
    end
    
endmodule



module fifo_sync1 (
    input serial_data,
    input clk_8G,
    input rst_8G,
    input tx_start,
    input tx_valid,
    input k_synced,
    output fifo_out
);

reg [255:0] mem;
reg [8:0] wptr;
reg [8:0] rptr;
wire full,empty;
wire [1:0] sync_head;

// The control signal is used to generate the sync header. 
assign sync_head = (k_synced) ? 2'b01 : 2'b10;

// Full empty conditions for the FIFO
assign full = ({!wptr[8],wptr[7:0]} == (rptr[8:0])) ? 1'b1 : 1'b0;
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;

// Final Output 
assign fifo_out = (!empty) ? mem[rptr[7:0]] : (tx_start ? sync_head[0] : 1'b0);

always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        rptr <= 9'd0;
    end
    else begin
        rptr <= (!empty) ? (rptr + 9'd1) : (rptr);
    end
end
always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        wptr <= 9'd0;
    end
    else if(tx_start) begin
        wptr <= (!full && tx_valid) ? (!empty ? (wptr + 9'd3) : (wptr + 9'd2)) : (wptr);
    end
    else begin
        wptr <= (!full && tx_valid) ? (wptr + 9'd1) : (wptr);
    end
end

always @(posedge clk_8G) begin
    if (tx_start && tx_valid && !full) begin
        {mem[wptr[7:0]+8'd2], mem[wptr[7:0]+8'd1], mem[wptr[7:0]]} <= !empty ? {serial_data,sync_head[1:0]} : {mem[wptr[7:0]+8'd2], serial_data, sync_head[1]};
    end
    else if(tx_valid && !full) begin
        {mem[wptr[7:0]+8'd2], mem[wptr[7:0]+8'd1], mem[wptr[7:0]]} <= {mem[wptr[7:0]+8'd2], mem[wptr[7:0]+8'd1], serial_data};
    end
    else begin
        {mem[wptr[7:0]+8'd2], mem[wptr[7:0]+8'd1], mem[wptr[7:0]]} <= {mem[wptr[7:0]+8'd2], mem[wptr[7:0]+8'd1], mem[wptr[7:0]]};
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

reg [129:0] mem;
reg [8:0] wptr;
reg [8:0] rptr;
wire full,empty;
wire [1:0] sync_head;
wire rst_gen;


//assign rst_gen = tx_valid & rst_8G;
assign sync_head = (k_synced) ? 2'b01 : 2'b10;

//assign full = ({!wptr[9],wptr[8:0]} == rptr-9'd1 || {!wptr[9],wptr[8:0]} == rptr) ? 1'b1 : 1'b0;
assign full = (({!wptr[8],wptr[7:0]} == (rptr[8:0])) && (tx_start == 1)) ? 1'b1 : 1'b0;
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;
assign fifo_out = (!empty) ? mem[rptr[7:0]] : (tx_start ? sync_head[0] : 1'b0);

always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        rptr <= 9'd0;
    end
    else if (rptr[7:0] == 8'd129) begin
        rptr <= {~rptr[8],8'd0};
    end
    else if (rptr[7:0] == 8'd130) begin
        rptr <= {~rptr[8],8'd1};
    end
    else if (rptr[7:0] == 8'd131) begin
        rptr <= {~rptr[8],8'd2};
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
    else if (wptr[7:0] == 8'd129) begin
        wptr <= {~wptr[8],8'd0};
    end
    else if (wptr[7:0] == 8'd130) begin
        wptr <= {~wptr[8],8'd1};
    end 
    else if (wptr[7:0] == 8'd131) begin
        wptr <= {~wptr[8],8'd2};
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
        mem[wptr[7:0]+7'd1] <= serial_data;
        mem[wptr[6:0]] <= sync_head[1];
    end
    else if(tx_valid && !full) begin
        mem[wptr[6:0]] <= serial_data;
    end
    else begin
        mem[wptr[6:0]] <= wptr[wptr[6:0]];
    end
end

always @(posedge clk_8G) begin
    if (tx_start && tx_valid && !full && !empty) begin
        mem[wptr[7:0]+8'd2] <= serial_data;
        mem[wptr[7:0]+8'd1] <= sync_head[1];
        mem[wptr[7:0]] <= sync_head[0];
    end
    else if (tx_start && tx_valid && !full) begin
        mem[wptr[7:0]+8'd1] <= serial_data;
        mem[wptr[7:0]] <= sync_head[1];
    end
    else if(tx_valid && !full) begin
        mem[wptr[7:0]] <= serial_data;
    end
    else begin
        mem[wptr[7:0]] <= mem[wptr[7:0]];
    end
end

    
endmodule
*/



