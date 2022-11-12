`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/11 10:38:58
// Design Name: 
// Module Name: mul
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


module mul(
    input [63:0] src1,
    input [63:0] src2,
    
    input [1:0] mul_signed,  // bit 0 induce the src1 signed  1 is signed
    output [63:0] re_hi,
    output [63:0] re_lo
    );
    

    wire src1_abs_flag;
    wire src2_abs_flag;

    assign src1_abs_flag = src1[63] && mul_signed[0];
    assign src2_abs_flag = src2[63] && mul_signed[1];

    wire [63:0] src1_mul; 
    wire [63:0] src2_mul;

    assign src1_mul = src1_abs_flag   ? ~src1 + 1 : src1;
    assign src2_mul = src2_abs_flag   ? ~src2 + 1 : src2;

//    wire [127:0] result_abs;
//    assign  result_abs = src1_mul * src2_mul;
    wire  [127:0] booth [63:0];

    genvar i;
    generate
    for(i=0;i<64;i=i+1) begin
        assign booth[i] = {64'd0,(src1_mul[i] ? src2_mul : 64'd0)} << i ;
    end
    endgenerate

    // add like tree

    wire [127:0] tree_32 [31:0];
    generate
    for(i=0;i<64;i=i+2) begin
    assign tree_32[i>>1] = booth[i] + booth[i+1]  ;
    end
    endgenerate
       
    wire [127:0] tree_16 [15:0];
    generate
    for(i=0;i<32;i=i+2) begin
    assign tree_16[i>>1] = tree_32[i] + tree_32[i+1]  ;
    end
    endgenerate
    
    wire [127:0] tree_8 [7:0];
    generate
    for(i=0;i<16;i=i+2) begin
    assign tree_8[i>>1] = tree_16[i] + tree_16[i+1]  ;
    end
    endgenerate
   
    wire [127:0] tree_4 [3:0];
    generate
    for(i=0;i<8;i=i+2) begin
    assign tree_4[i>>1] = tree_8[i] + tree_8[i+1]  ;
    end
    endgenerate
    
     wire [127:0] result_abs;
    assign result_abs = tree_4[0] + tree_4[1] +tree_4[2] + tree_4[3];


     wire signed_flag ;
     assign signed_flag = (src1_abs_flag ^ src2_abs_flag) && (mul_signed ==2'b11);


     wire [127:0] result;
     assign result = signed_flag ? ~result_abs +1 : result_abs; 

    assign re_hi = result[127:64];
    assign re_lo = result[63:0] ;
endmodule
