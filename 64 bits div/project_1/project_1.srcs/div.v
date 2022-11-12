`define DIV_FREE 0
`define DIV_ON 1
`define DIV_END 2
`timescale 1ns / 1ps

module div(
    input clk,
    input rst,

    input sign,
    input [63:0] div_data,
    input [63:0] dived_data,
    input div_ready,

    output div_valid,
    output [63:0] result_hi,
    output [63:0] result_lo

);
reg [127:0] remain_data;
reg [63:0] src1;
reg [63:0] src2; 
reg [2:0] div_state;
reg [63:0] result;
reg [6:0] result_index;
wire [64:0] sub_data;

wire [63:0] div_data_abs;
wire [63:0] dived_data_abs;

wire div_sign_flag;
wire dived_sign_flag;

assign div_sign_flag =  sign & div_data[63];
assign dived_sign_flag = sign &  dived_data[63];

assign div_data_abs = div_sign_flag ? ~div_data+1 : div_data;
assign dived_data_abs = dived_sign_flag ? ~dived_data+1 :dived_data;


assign sub_data = remain_data[result_index+7'd64-:65] - {1'b0,src2};
assign div_valid = div_state == `DIV_END;
always @(posedge clk) begin
    if(rst) begin
        src1 <= 64'd0;
        src2 <= 64'd0;
        remain_data <= 128'd0;
        div_state <= 3'd0;
        result_index <= 7'd0;
        result <= 64'd0;
    end
    else if(div_state == `DIV_FREE) begin
        if(div_ready) begin
            src1 <= div_data_abs;
            src2 <= dived_data_abs;
            div_state <= 3'd1;
            result_index <= 7'd63;
            remain_data <= {64'd0,div_data_abs};
        end
    end
    else if(div_state == `DIV_ON) begin
        remain_data[result_index+7'd64-:65] <= sub_data[64] ? remain_data[result_index+7'd64-:65] : sub_data;
        result[result_index] <= ~sub_data[64];
        result_index <= result_index - 7'd1;
        if(result_index == 7'd0) begin
            div_state  <= `DIV_END;
        end
    end
    else if(div_state == `DIV_END) begin
        div_state  <= `DIV_FREE;
    end
end
assign result_hi = div_sign_flag ? ~remain_data[63:0] + 1: remain_data[63:0];
assign result_lo = dived_sign_flag ^ div_sign_flag ?~result +1 :  result ;
endmodule