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


module Top_module_logical_Tx2(
    input clk_625M,
    input clk_8G,
    input rst,
    input rst_mod,
    input k,
    input tx_valid,
    input tx_start,
    input [511:0] DLL_data,
    input [1:0] en_scram,
    output data_out0,
    output data_out1,
    output data_out2,
    output data_out3
);


wire serial_data[3:0];
wire [127:0] scram_data_out[3:0];

wire sy_s;
wire sy_k;
wire sy_v;
wire sy_spul;
wire [127:0] Lane [3:0];
wire data_out[3:0];
wire rst_gen;
wire [1:0] lanenum [3:0];

assign rst_gen = rst & rst_mod;
assign {data_out3,data_out2,data_out1,data_out0} = {data_out[3],data_out[2],data_out[1],data_out[0]};

byte_striping_gg BT1(DLL_data, clk_625M, rst, Lane[0], Lane[1], Lane[2], Lane[3]);
header_synchronizer1 HS1(clk_625M, rst, tx_start, tx_valid, k, sy_s, sy_k, sy_v);
//levtopulse LP1(clk_8G, rst, tx_start, sy_s, sy_spul);
//header_synchronizer2 HS2(clk_625M, rst, tx_valid, k, sy_k, sy_v);

genvar i;
/*generate for(i=0;i<4;i=i+1) begin : instanses
    assign lanenum[i] = i;
    scrambler SC2(Lane[i], en_scram, lanenum[i], scram_data_out[i], rst_gen, clk_625M); // 23 bit LFSR with different seed values based on the lane number.
    //LTSSM SC1(DLL_data, clk_625M, rst, en_scram); // Blackbox this for now, write the control based on scrambling rules. 1 bit should be used for not forwarding LFSR, 1 bit for not scrambling.
    piso_serial8b1 PI1(scram_data_out[i], clk_625M, rst, clk_8G, serial_data[i]); // Continuous serialization of bits without any delay between cycles
    fifo_sync1     ff1(serial_data[i], clk_8G, rst, sy_spul, sy_v, sy_k, data_out[i]); 
    end
endgenerate*/

generate for(i=0;i<4;i=i+1) begin : instanses
    assign lanenum[i] = i;
    scrambler SC2(Lane[i], en_scram, lanenum[i], scram_data_out[i], rst_gen, clk_625M); // 23 bit LFSR with different seed values based on the lane number.
    //LTSSM SC1(DLL_data, clk_625M, rst, en_scram); // Blackbox this for now, write the control based on scrambling rules. 1 bit should be used for not forwarding LFSR, 1 bit for not scrambling.
    piso_serial8b1 PI1(scram_data_out[i], clk_625M, rst, clk_8G, serial_data[i]); // Continuous serialization of bits without any delay between cycles
    fifo_sync1     ff1(serial_data[i], clk_8G, rst, tx_start, tx_valid, k, data_out[i]); 
    //fifo_sync1     ff1(serial_data[i], clk_8G, rst, tx_start, sy_v, sy_k, data_out[i]);
    end
endgenerate


    
endmodule

module byte_striping_gg #(
    parameter integer numlanes = 4
) (
    input [((numlanes*128)-1):0] data_in,
    input clk_1G,
    input rst_1G,
    output reg [127:0] data_0L,
    output reg [127:0] data_1L,
    output reg [127:0] data_2L,
    output reg [127:0] data_3L
);
  
    //wire [7:0] data_out [numlanes-1:0];
    
    always @(posedge clk_1G, negedge rst_1G) begin
        if (!rst_1G) begin
            {data_0L,data_1L,data_2L,data_3L} <= 512'd0;
        end
        else begin
            {data_0L,data_1L,data_2L,data_3L} <= data_in;
        end
    end

    
    /*
    genvar i;
    generate for (i=0; i<numlanes; i=i+1) begin : striping
        assign data_out[i] = data_in[(8*(i+1))-1:i*8];
    end 
    endgenerate
    */
  
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

reg [1:0] syblk;
reg [1:0] syhhh;
reg [1:0] sy1;

assign tx_s = syblk[0];
assign k_synced = sy1[1];
assign tx_v = syhhh[1];

always @(posedge clk_8G,negedge rst_8G) begin
    if(!rst_8G) begin
        syblk <= 0;
        sy1 <= 0;
        syhhh <= 0;
    end
    else begin
        syblk <= {syblk[0],tx_start};
        sy1 <= {sy1[0],k};
        syhhh <= {syhhh[0],tx_valid};
    end    
end    
    
endmodule

module header_synchronizer2 (
    input clk_8G,
    input rst_8G,
    input tx_valid,
    input k,
    output k_synced,
    output tx_v);

reg [1:0] syhhh;
reg [1:0] sy1;

assign k_synced = sy1[1];
assign tx_v = syhhh[1];

always @(posedge clk_8G,negedge rst_8G) begin
    if(!rst_8G) begin
        sy1 <= 0;
        syhhh <= 0;
    end
    else begin
        sy1 <= {sy1[0],k};
        syhhh <= {syhhh[0],tx_valid};
    end    
end    
    
endmodule

module levtopulse (
    input clk_8G,
    input rst_8G,
    input tx_start,
    input lev,
    output pulse
);

reg state;

assign pulse = (state & tx_start);

always @(posedge clk_8G,negedge rst_8G) begin
    if(!rst_8G) begin
        state <= 1'b0;
    end
    else begin
        state <= lev;
    end  
end
    
endmodule


module piso_serial8b1 (
    input [127:0] scram_data_out,
    input clk_625M,
    input rst,
    input clk_8G,
    output serial_data
);

    reg [127:0] piso;
    reg [6:0] i;

   assign serial_data = piso[i]; 

    always @(posedge clk_625M, negedge rst) begin
        if (!rst) begin
            piso <= 8'd0;
        end
        else begin
            piso <= scram_data_out;
        end
    end

    always @(posedge clk_8G, negedge rst) begin
        if (!rst) begin
            i <= 7'd127;
        end
        else begin
            i <= i + 7'd1;
        end
    end
    
endmodule

/*
module fifo_sync1 (
    input serial_data,
    input clk_625M,
    input rst,
    input clk_8G,
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

always @(posedge clk_8G, negedge rst) begin
    if (!rst) begin
        rptr <= 9'd0;
    end
    else begin
        rptr <= (!empty) ? (rptr + 9'd1) : (rptr);
    end
end
always @(posedge clk_8G, negedge rst) begin
    if (!rst) begin
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
*/


module fifo_sync1 (
    input serial_data,
    input clk_8G,
    input rst,
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

always @(posedge clk_8G, negedge rst) begin
    if (!rst) begin
        rptr <= 9'd0;
    end
    else begin
        rptr <= (!empty) ? (rptr + 9'd1) : (rptr);
    end
end
always @(posedge clk_8G, negedge rst) begin
    if (!rst) begin
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


