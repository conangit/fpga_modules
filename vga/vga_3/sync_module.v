/* 
 * 800*600@60   40.0MHz
 * 128    88    800    40   1056
 * 4      23    600    1    628
 */


module sync_module (
    CLK,
    RST_n,
    VSYNC_Sig,
    HSYNC_Sig,
    Ready_Sig,
    Column_Addr_Sig,
    Row_Addr_Sig
    );
    
    input CLK;
    input RST_n;
    output VSYNC_Sig;
    output HSYNC_Sig;
    output Ready_Sig;
    output [10:0] Column_Addr_Sig;
    output [10:0] Row_Addr_Sig;
    
    // 列像素
    reg [10:0] Count_H;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            Count_H <= 11'd0;
        else if(Count_H == 11'd1056)
            Count_H <= 11'd0;
        else
            Count_H <= Count_H + 1'b1;
    end
    
    // 行像素
    reg [10:0] Count_V;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            Count_V <= 11'd0;
        else if (Count_V == 11'd628)
            Count_V <= 11'd0;
        else if (Count_H == 11'd1056)
            Count_V <= Count_V + 1'b1;
    end
    
    // 有效区域
    reg isReady;
    
    always @(posedge CLK or negedge RST_n) begin
        if (!RST_n)
            isReady <= 1'b0;
        else if ((11'd216 < Count_H && Count_H < 11'd1017) && (11'd27 < Count_V && Count_V < 11'd628))
            isReady <= 1'b1;
        else
            isReady <= 1'b0;
    end
    
    assign HSYNC_Sig = (Count_H <= 11'd128) ? 1'b0 : 1'b1;
    assign VSYNC_Sig = (Count_V <= 11'd4) ? 1'b0 : 1'b1;
    assign Ready_Sig = isReady;
    
    // 当前的x和y地址
    assign Column_Addr_Sig = isReady ? Count_H - 11'd217 : 11'd0;
    assign Row_Addr_Sig = isReady ? Count_V - 11'd28 : 11'd0;
    
endmodule

