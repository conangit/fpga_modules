


module pll_module(
    clk_in,
    RST_n,
    clk_out
    );
    
    input clk_in;
    input RST_n;
    output clk_out;
    
    freqdiv #(.DIV_IN(50), .DIV_OUT(40)) F1
    (
        .clk_in(clk_in),
        .rst(RST_n),
        .clk_out(clk_out)
    );
    
endmodule

