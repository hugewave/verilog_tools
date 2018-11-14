`timescale 1ns / 100ps

module tb_sim_avalon_src;

reg         clk;
reg         rest_n;
wire        sop;
wire        eop;
wire        val;
wire [7:0]  dat;
reg  [7:0]  mod;
reg  [10:0] cnt;
wire [15:0] sig;

initial begin
    clk    = 1'b0;
    rest_n = 1'b1;
    mod    = 8'd0;
    #100 rest_n = 1'b0;
    #10  rest_n = 1'b1;
end


 sim_avalon_src UUT
(

    .I_clk      (clk),
    .I_rst_n    (rest_n),
    .I_mod      (mod),
    .I_src_rdy  (1'd1),
    .O_src_sop  (sop),
    .O_src_eop  (eop),
    .O_src_val  (val),
    .O_src_dat  (dat)
);

always #5 clk = ~clk;
endmodule
