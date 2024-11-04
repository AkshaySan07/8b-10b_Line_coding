module tb_scram();
    reg [7:0] DLL_data;
    reg clk_1G, clk_8G, rst_1G, rst_mod;    
    reg [1:0] en_scram;
    wire [7:0] scram_data_out;

scrambler_23b SC1(DLL_data,clk_1G,clk_8G,rst_1G,rst_mod,en_scram,scram_data_out);

initial begin
    en_scram <= 2'b11;
    DLL_data <= $random;
    #16 rst_1G <= 1;
    rst_mod <= 1;
    repeat(16) begin
      #16 DLL_data = $random;
      en_scram <= $random;
    end
    #10 $finish;

end

initial begin
    rst_1G <= 0;
    clk_1G <= 0;
    #1;
    forever #8 clk_1G = ~clk_1G;
end
  
initial begin
    rst_mod = 0;
    clk_8G = 0;
    forever #1 clk_8G = ~clk_8G;
end

endmodule