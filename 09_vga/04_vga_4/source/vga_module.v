`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:35:29 08/11/2018 
// Design Name: 
// Module Name:    vga_module 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_module(
    input clk,
    input rst_n,
    output VSYNC_Sig,
    output HSYNC_Sig,
    output [4:0]Red_Sig,
    output [5:0]Green_Sig,
    output [4:0]Blue_Sig
    );
    
    
    wire clk_out;
    wire clk_locked; //要求分频/倍频的时钟达到稳态时,clk_locked维持高电平
    
    wire isReady;
    wire [11:0]x_addr;
    wire [11:0]y_addr;
    
    wire [5:0] rom_addr;
    wire [63:0] rom_data;
    
    
    pll_ip pll_ip_inst(
        .CLK_IN1(clk),
        .CLK_OUT1(clk_out),
        .RESET(~rst_n),
        .LOCKED(clk_locked)
    );

    vga_sync_module_800_600_60 S1(
        .vga_clk(clk_out),
        .rst_n(rst_n),
        .VSYNC_Sig(VSYNC_Sig),
        .HSYNC_Sig(HSYNC_Sig),
        .Ready_Sig(isReady),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr)
    );
    
    rom_ip rom(
        .clka(clk_out),
        .addra(rom_addr),   // input [5 : 0] addra
        .douta(rom_data)    // output [63 : 0] douta
    );
    
    vga_control_module C1(
        .vga_clk(clk_out),
        .rst_n(rst_n),
        .Ready_Sig(isReady),
        .Column_Addr_Sig(x_addr),
        .Row_Addr_Sig(y_addr),
        .rom_addr(rom_addr),
        .rom_data(rom_data),
        .Red_Sig(Red_Sig),
        .Green_Sig(Green_Sig),
        .Blue_Sig(Blue_Sig)
    );
    
    
    
    
endmodule
