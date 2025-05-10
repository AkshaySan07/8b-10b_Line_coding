module scrambler(
  input [127:0] data_in,
  input scram_en,
  input [1:0] lanenum,
  output reg [127:0] data_out,
  input rst,
  input clk);

  reg [22:0] lfsr_q,lfsr_c;
  reg [127:0] data_c;

  always @(*) begin
    lfsr_c[0] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    lfsr_c[1] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    lfsr_c[2] = lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    lfsr_c[3] = lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[20] ^ lfsr_q[21];
    lfsr_c[4] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[21] ^ lfsr_q[22];
    lfsr_c[5] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
    lfsr_c[6] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    lfsr_c[7] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20] ^ lfsr_q[21];
    lfsr_c[8] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[19];
    lfsr_c[9] = lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[20];
    lfsr_c[10] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[21];
    lfsr_c[11] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[22];
    lfsr_c[12] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[21];
    lfsr_c[13] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[22];
    lfsr_c[14] = lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18];
    lfsr_c[15] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19];
    lfsr_c[16] = lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    lfsr_c[17] = lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    lfsr_c[18] = lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    lfsr_c[19] = lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    lfsr_c[20] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
    lfsr_c[21] = lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    lfsr_c[22] = lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];

    data_c[0] = data_in[0] ^ lfsr_q[22];
    data_c[1] = data_in[1] ^ lfsr_q[21];
    data_c[2] = data_in[2] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[3] = data_in[3] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[4] = data_in[4] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[5] = data_in[5] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[6] = data_in[6] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[7] = data_in[7] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[8] = data_in[8] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[9] = data_in[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[10] = data_in[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[11] = data_in[11] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[12] = data_in[12] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[13] = data_in[13] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[14] = data_in[14] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[15] = data_in[15] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
    data_c[16] = data_in[16] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18];
    data_c[17] = data_in[17] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17];
    data_c[18] = data_in[18] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16];
    data_c[19] = data_in[19] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15];
    data_c[20] = data_in[20] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[22];
    data_c[21] = data_in[21] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[21];
    data_c[22] = data_in[22] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[23] = data_in[23] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[24] = data_in[24] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[25] = data_in[25] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[26] = data_in[26] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[27] = data_in[27] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[28] = data_in[28] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[29] = data_in[29] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[30] = data_in[30] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[31] = data_in[31] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[32] = data_in[32] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[33] = data_in[33] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[34] = data_in[34] ^ lfsr_q[0] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[35] = data_in[35] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[36] = data_in[36] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[37] = data_in[37] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[38] = data_in[38] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[39] = data_in[39] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[40] = data_in[40] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[41] = data_in[41] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
    data_c[42] = data_in[42] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
    data_c[43] = data_in[43] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20];
    data_c[44] = data_in[44] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19] ^ lfsr_q[22];
    data_c[45] = data_in[45] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[21];
    data_c[46] = data_in[46] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[20];
    data_c[47] = data_in[47] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[19];
    data_c[48] = data_in[48] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[18] ^ lfsr_q[22];
    data_c[49] = data_in[49] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[21];
    data_c[50] = data_in[50] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[51] = data_in[51] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[52] = data_in[52] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[53] = data_in[53] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[54] = data_in[54] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[55] = data_in[55] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[56] = data_in[56] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[57] = data_in[57] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[58] = data_in[58] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[59] = data_in[59] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[60] = data_in[60] ^ lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[61] = data_in[61] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[62] = data_in[62] ^ lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[63] = data_in[63] ^ lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[64] = data_in[64] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[65] = data_in[65] ^ lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[66] = data_in[66] ^ lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[67] = data_in[67] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[68] = data_in[68] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[69] = data_in[69] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[70] = data_in[70] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[71] = data_in[71] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[72] = data_in[72] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
    data_c[73] = data_in[73] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
    data_c[74] = data_in[74] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[75] = data_in[75] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[76] = data_in[76] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[77] = data_in[77] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[78] = data_in[78] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[79] = data_in[79] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[80] = data_in[80] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[22];
    data_c[81] = data_in[81] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[21];
    data_c[82] = data_in[82] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[20];
    data_c[83] = data_in[83] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[19];
    data_c[84] = data_in[84] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[18];
    data_c[85] = data_in[85] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[17] ^ lfsr_q[22];
    data_c[86] = data_in[86] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[16] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[87] = data_in[87] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[15] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[88] = data_in[88] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[14] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[89] = data_in[89] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[13] ^ lfsr_q[18] ^ lfsr_q[19];
    data_c[90] = data_in[90] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[12] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
    data_c[91] = data_in[91] ^ lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[11] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[92] = data_in[92] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[10] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[93] = data_in[93] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[9] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[94] = data_in[94] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[8] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[95] = data_in[95] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[7] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[96] = data_in[96] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[6] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[97] = data_in[97] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[5] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[98] = data_in[98] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[4] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[99] = data_in[99] ^ lfsr_q[0] ^ lfsr_q[3] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[100] = data_in[100] ^ lfsr_q[2] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[101] = data_in[101] ^ lfsr_q[1] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[102] = data_in[102] ^ lfsr_q[0] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
    data_c[103] = data_in[103] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
    data_c[104] = data_in[104] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
    data_c[105] = data_in[105] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[106] = data_in[106] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[107] = data_in[107] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[108] = data_in[108] ^ lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[109] = data_in[109] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[20];
    data_c[110] = data_in[110] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[19];
    data_c[111] = data_in[111] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[22];
    data_c[112] = data_in[112] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[21];
    data_c[113] = data_in[113] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[114] = data_in[114] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[115] = data_in[115] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[116] = data_in[116] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[117] = data_in[117] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[118] = data_in[118] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[119] = data_in[119] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[120] = data_in[120] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[5] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[121] = data_in[121] ^ lfsr_q[0] ^ lfsr_q[4] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[8] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[122] = data_in[122] ^ lfsr_q[3] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[7] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21];
    data_c[123] = data_in[123] ^ lfsr_q[2] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[6] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[124] = data_in[124] ^ lfsr_q[1] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[5] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
    data_c[125] = data_in[125] ^ lfsr_q[0] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[4] ^ lfsr_q[8] ^ lfsr_q[10] ^ lfsr_q[11] ^ lfsr_q[13] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[20] ^ lfsr_q[21];
    data_c[126] = data_in[126] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[3] ^ lfsr_q[7] ^ lfsr_q[9] ^ lfsr_q[10] ^ lfsr_q[12] ^ lfsr_q[13] ^ lfsr_q[15] ^ lfsr_q[17] ^ lfsr_q[19] ^ lfsr_q[20] ^ lfsr_q[22];
    data_c[127] = data_in[127] ^ lfsr_q[0] ^ lfsr_q[1] ^ lfsr_q[2] ^ lfsr_q[6] ^ lfsr_q[8] ^ lfsr_q[9] ^ lfsr_q[11] ^ lfsr_q[12] ^ lfsr_q[14] ^ lfsr_q[16] ^ lfsr_q[18] ^ lfsr_q[19] ^ lfsr_q[21] ^ lfsr_q[22];
  end // always

  always @(posedge clk, negedge rst) begin
    if(!rst) begin
      case(lanenum)
            2'd0 : lfsr_q <= 23'h1DBFBC;
            2'd1 : lfsr_q <= 23'h0607BB;
            2'd2 : lfsr_q <= 23'h1EC760;
            2'd3 : lfsr_q <= 23'h18C0DB;
            default : lfsr_q <= 23'h1DBFBC;
      endcase
      data_out <= {128{1'b0}};
    end
    else begin
      lfsr_q <= scram_en ? lfsr_c : lfsr_q;
      data_out <= scram_en ? data_c : data_out;
    end
  end // always
endmodule // scrambler