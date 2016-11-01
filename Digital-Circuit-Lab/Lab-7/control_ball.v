`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:15:55 05/15/2012 
// Design Name: 
// Module Name:    control_ball 
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
module control_ball (CLK, reset, rotary_event, rotary_right, ball_x, ball_y);
    input CLK;
    input reset;
    input rotary_event;
    input rotary_right;
    output reg [11:0] ball_x = 50;
    output reg [10:0] ball_y = 240;

    always @ (posedge CLK)
    begin
        if (rotary_event == 1 && rotary_right == 0)         //if it wants to t
        begin
            if (ball_x <= 590) ball_x <= ball_x + 5;            //640 - 50 = 590
            else ball_x <= ball_x;
        end
        else if (rotary_event == 1 && rotary_right == 1)    //if it wants to t
        begin
            if (ball_x >= 50) ball_x <= ball_x - 5;         //0 + 50 = 50
            else ball_x <= ball_x;
        end
        else
        begin
            ball_x <= ball_x;
        end
    end

endmodule 