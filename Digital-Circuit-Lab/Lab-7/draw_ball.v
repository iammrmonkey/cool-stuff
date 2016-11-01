`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:22 05/15/2012 
// Design Name: 
// Module Name:    draw_ball 
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
module draw_ball (vcounter,hcounter,visible,ball_x,ball_y,VGA_R,VGA_G,VGA_B,
Radius);
    input [11:0] vcounter;
    input [10:0] hcounter;
    input visible;
    input [11:0] ball_x;
    input [10:0] ball_y;
    input [7:0] Radius;
    output reg VGA_R;
    output reg VGA_G;
    output reg VGA_B;
	 reg [30:0] a_square;
	 reg [30:0] b_square;
    always @ ( * )
    begin
			a_square <= (hcounter - ball_x) * (hcounter - ball_x);
			b_square <=  (vcounter - ball_y) * (vcounter - ball_y);
        if (visible == 1 && (a_square + b_square < Radius*Radius))
        begin
            VGA_R <= 1;
            VGA_G <= 1;
            VGA_B <= 1;
        end
        else
        begin
            VGA_R <= 0;
            VGA_G <= 0;
            VGA_B <= 0;
        end
    end

endmodule
