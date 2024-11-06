`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SSwitch Technologies
// Engineer: Akshay V
// 
// Create Date: Create Date: 10/29/2024 11:41:42 AM
// Design Name: Physical Layer (Logical)
// Module Name: Encoder and serializer
// Project Name: PCIexpress 3.0
//////////////////////////////////////////////////////////////////////////////////

module Top_module_logical_Tx(
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

//wire [1:0] en_scram;
wire serial_data;
wire fifo_out;
wire [7:0] scram_data_out;

wire sy2;
wire syblk2;

scrambler_23b SC1(DLL_data, clk_1G, clk_8G, rst1G, rst_mod, en_scram, scram_data_out); // 23 bit LFSR with different seed values based on the lane number.
header_synchronizer HS1(clk_8G, rst_8G, tx_start, k, sy2, syblk2);
//scram_control SC1(DLL_data, clk_1G, rst_1G, en_scram); // Blackbox this for now, write the control based on scrambling rules. 1 bit should be used for not forwarding LFSR, 1 bit for not scrambling.
piso_serial8b PI1(scram_data_out, clk_1G, rst_1G, clk_8G, rst_8G, serial_data); // Continuous serialization of bits without any delay between cycles
fifo_sync     ff1(serial_data, clk_8G, rst_8G, sy2, tx_valid, fifo_out); // tx_valid is used for write_en, tx_start is used for read_en
sync_head_add SH1(fifo_out, clk_8G, rst_8G, sy2, syblk2, data_out); // Use tx_start for muxing between fifo_out and synchead bits
    
endmodule

/*
module header_synchronizer (
    input clk_8G,
    input rst_8G,
    input tx_start,
    input k,
    output reg sy2,
    output reg  syblk2);

reg syblk1;
reg sy1;

always @(posedge clk_8G,negedge rst_8G) begin
        if(!rst_8G) begin
            sy1 <= 0;
            sy2 <= 0;
            syblk1 <= 0;
            syblk2 <= 0;
        end
        else begin
            sy1 <= tx_start;
            sy2 <= sy1;
            syblk1 <= k;
            syblk2 <= syblk1;
        end    
    end    
    
endmodule
*/

module header_synchronizer (
    input clk_8G,
    input rst_8G,
    input tx_start,
    input k,
    output tx_s,
    output k_synced);

reg [11:0] syblk;
reg [11:0] sy1;

assign tx_s = syblk[11];
assign k_synced = sy1[11];

always @(posedge clk_8G,negedge rst_8G) begin
        if(!rst_8G) begin
            syblk <= 0;
            sy1 <= 0;
        end
        else begin
            syblk <= {syblk[10:0],tx_start};
            sy1 <= {sy1[10:0],k};
        end    
    end    
    
endmodule




module piso_serial8b (
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

module sync_head_add (
    input fifo_out,
    input clk_8G,
    input rst_8G,
    input tx_start,         // This signal is only high for 2 cycles 
    input k,
    output reg data_out
);

    reg cnt;
    wire [1:0] synchead;
    
    assign synchead = k ? 2'b01 : 2'b10;
    
    always @(posedge clk_8G,negedge rst_8G) begin
        if (!rst_8G) begin
            data_out <= 1'b0;
            cnt <= 1'b0;
        end
        else if (tx_start) begin
            data_out <= synchead[cnt];
            cnt <= cnt + 1'b1;
        end 
        else begin
            data_out <= fifo_out;
            cnt <= 1'b0;
        end
    end

endmodule

module fifo_sync (
    input serial_data,
    input clk_8G,
    input rst_8G,
    input tx_start,
    input tx_valid,
    output fifo_out
);

reg [511:0] mem;
reg [9:0] wptr;
reg [9:0] rptr;
wire full,empty;

assign full = ({!wptr[9],wptr[8:0]} == rptr) ? 1'b1 : 1'b0;
assign empty = (wptr == rptr) ? 1'b1 : 1'b0;
assign fifo_out = (!tx_start && !empty) ? mem[rptr[8:0]] : 1'b0;

always @(posedge clk_8G, negedge rst_8G) begin
    if (!rst_8G) begin
        wptr <= 9'd0;
        rptr <= 9'd0;
    end
    else begin
        wptr <= (tx_valid && !full) ? (wptr + 9'd1) : (wptr);
        rptr <= (!tx_start && !empty) ? (rptr + 9'd1) : (rptr);
    end
end

always @(posedge clk_8G) begin
    if(tx_valid && !full) begin
        mem[wptr[8:0]] <= serial_data;
    end
    else begin
        mem[wptr[8:0]] <= wptr[wptr];
    end
end
    
endmodule

