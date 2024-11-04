module byte_striping #(
    parameter integer numlanes = 4
) (
    input  wire [7:0][numlanes-1:0] data_in,
    output wire [7:0] data_out[numlanes-1:0]
);
  
    genvar i;
    generate for (i=0; i<numlanes; i++) begin : striping
        assign data_out[i] = data_in[i];
    end 
    endgenerate
  
endmodule