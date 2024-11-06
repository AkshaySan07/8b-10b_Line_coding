module byte_striping #(
    parameter integer numlanes = 4
) (
    input [7:0][numlanes-1:0] data_in,
    output [7:0] data_0L,
    output [7:0] data_1L,
    output [7:0] data_2L,
    output [7:0] data_3L
);
  
    wire [7:0] data_out [numlanes-1:0];
    assign {data_0L,data_1L,data_2L,data_3L} = {data_out[0],data_out[1],data_out[2],data_out[3]};
    
    genvar i;
    generate for (i=0; i<numlanes; i=i+1) begin : striping
        assign data_out[i] = data_in[i];
    end 
    endgenerate
  
endmodule