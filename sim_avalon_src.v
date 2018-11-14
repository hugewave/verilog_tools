`timescale 1ns/100ps
module sim_avalon_src
(

    input           I_clk,
    input           I_rst_n,
    input  [7:0]    I_mod,
    input           I_src_rdy,
    input           O_src_sop,
    input           O_src_eop,
    input           O_src_val,
    input  [7:0]    O_src_dat
);

reg [10:0] cnt;
reg [15:0] mem1[0:2047]; //for tpc1024 bpsk mod
reg [15:0] mem2[0:2047]; //for tpc2048 qpsk mod
reg [15:0] mem3[0:2047]; //for tpc2048 16qam mod
wire [15:0] sig;

initial begin
        $readmemh("1024src.txt",mem1);
        $readmemh("2048src.txt",mem2);
        $readmemh("4096src.txt",mem3);
end

always @(posedge I_clk or negedge I_rst_n)begin
    if(!I_rst_n)begin
        cnt <= 11'd0;
    end else if(I_src_rdy) begin
        cnt <= cnt + 1'd1;
    end
end

assign sig = (I_mod == 8'd0) ? mem1[cnt] : ((I_mod == 8'd1) ? mem2[cnt] : mem3[cnt]);
assign O_src_sop = sig[10];
assign O_src_eop = sig[9];
assign O_src_val = sig[8];
assign O_src_dat = sig[7:0];



endmodule