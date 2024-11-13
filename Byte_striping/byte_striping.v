module byte_striping #(
    parameter integer numlanes = 4
) (
    input [((numlanes*8)-1):0] data_in,
    input clk_1G,
    input rst_1G,
    output reg [7:0] data_0L,
    output reg [7:0] data_1L,
    output reg [7:0] data_2L,
    output reg [7:0] data_3L
);
  
    //wire [7:0] data_out [numlanes-1:0];
    
    always @(posedge clk_1G, negedge rst_1G) begin
        if (!rst_1G) begin
            {data_0L,data_1L,data_2L,data_3L} <= 32'd0;
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