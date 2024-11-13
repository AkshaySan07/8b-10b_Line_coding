module tb_byte_strip ();
    reg [31:0] d_in;
    wire [7:0] dL_0,dL_1,dL_2,dL_3;

    byte_striping BS1(d_in,dL_0,dL_1,dL_2,dL_3);

    initial begin
        d_in = 0;
        #9;
        repeat(16) begin
            d_in = $random;
            #16;
        end 
        $finish;
    end
endmodule