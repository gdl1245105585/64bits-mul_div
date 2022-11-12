`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/12 14:32:58
// Design Name: 
// Module Name: div_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module div_tb(

    );
    reg clk;
    reg rst;
    initial begin 
        clk <= 1'd0;
        rst <= 1'd1;
        #15 rst <= 1'd0;
    end
    always #10 begin
        clk = ~clk ;
    end
    
    reg [63:0] div_data;
    reg [63:0] dived_data;
    reg signed [63:0] ref_div_ans;
    reg [3:0] div_verify_state;
    reg div_ready;

    reg  [63:0] ref_rem_ans;
    wire [127:0] result;
    wire div_valid;
    reg sign;
    always @(posedge clk) begin
        if(rst) begin
            div_verify_state <= 4'd0;
            div_ready <= 1'd0;
            div_data <= 64'd0;
            dived_data <= 64'd0;
            ref_div_ans <= 64'd0;
            ref_rem_ans <= 64'd0;
            sign <= 1'd0;
        end
        else if(div_verify_state == 4'd0) begin
            div_data <= {$random,$random};
            dived_data <= {$random}%10;
            div_ready <= 1'd1;
            
            div_verify_state <= 4'd1;
            sign <= {$random}%2;
        end
        else if(div_verify_state == 4'd1) begin
            div_ready <= 1'd0;
            div_verify_state <= 4'd2;
            if(sign) begin
                ref_div_ans <= $signed(div_data) / $signed(dived_data);
                ref_rem_ans <= $signed(div_data) % $signed(dived_data);
            end
            else begin
                ref_div_ans <= div_data / dived_data;
                ref_rem_ans <= div_data % dived_data;
            end
        end
        else if(div_verify_state == 4'd2) begin
            if(div_valid) begin
                div_verify_state <= 4'd3;
            end
        end
        else if(div_verify_state == 4'd3) begin
            if( ref_div_ans != result[63:0]) begin
                $display("div: %x     dived: %x    sign: %x   ans: %x    ref: %x",div_data,dived_data,sign,result[63:0],ref_div_ans);
            end
            if( ref_rem_ans != result[127:64]) begin
                $display("div: %x     dived: %x    sign: %x   ans: %x    ref: %x",div_data,dived_data,sign,result[127:64],ref_rem_ans);
            end
            div_verify_state <= 4'd0;
        end
    end
    
    
    
    div div
    (
        .clk(clk),
        .rst(rst),
        
        .sign(sign),
        .div_data(div_data),
        .dived_data(dived_data),
        .div_ready(div_ready),

        .div_valid(div_valid),
        .result_hi(result[127:64]),
        .result_lo(result[63:0])
    );
    
    
endmodule
