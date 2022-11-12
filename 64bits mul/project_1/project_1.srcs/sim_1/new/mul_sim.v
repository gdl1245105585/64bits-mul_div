`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/11 10:37:05
// Design Name: 
// Module Name: mul_sim
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


module mul_sim(

    );
    reg [1:0]sign;
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] c;
    wire signed [127:0] mul_ref_s;
    wire [127:0] mul_ref_ns;
    wire [127:0] mul_ref_sn;
    assign mul_ref_s = $signed(a)  * $signed(b) ;
    assign mul_ref_ns = a  * b ;
    assign mul_ref_sn = $signed(a) *b;
    mul mul
    (
        .src1(a),
        .src2(b),
        .mul_signed(sign),
        
        
        .re_hi(c[127:64]),
        .re_lo(c[63:0])
    );
    always #10 begin
//    a <=64'h1;
//    b <= 64'hffffffffffffffff;
        a <= {$random,$random};
        b <= {$random,$random};
        sign <= {$random} %4;
        
        if(mul_ref_sn != mul_ref_ns)
        begin
            $display("not equal");
        end
        
        
//       // sign <= 2'b01;
//        case(sign) 
//            2'b00 : begin
//                if( mul_ref_ns !=c) begin
//                $display("not signed mul not signed");
//                $display("a : %x",a);
//                $display("b : %x",b);
//                $display("c : %x",c);
//                $display("ref : %x\n",mul_ref_ns);
//                end
//            end 
//            2'b11 : begin
//                if( mul_ref_s != c) begin
//                $display(" signed mul  signed");
//                $display("a : %x",a);
//                $display("b : %x",b);
//                $display("c : %x",c);
//                $display("ref : %x\n",mul_ref_s);
//                end
//            end
//            2'b01 : begin
//                if( mul_ref_sn != c) begin
//                $display(" not signed mul  signed");
//                $display("a : %x",a);
//                $display("b : %x",b);
//                $display("c : %x",c);
//                $display("ref : %x\n",mul_ref_sn);
//                end
//            end
//        endcase
    end
endmodule
