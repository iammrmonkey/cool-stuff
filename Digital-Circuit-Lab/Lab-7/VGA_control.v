`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:08:17 05/06/2011 
// Design Name: 
// Module Name:    VGA_control 
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
module VGA_control(
    input CLK,
    input reset,
    output reg [10:0] vcounter,
    output reg [11:0] hcounter,
    output reg visible,
    output reg oHS,
    output reg oVS
    );
	always@(posedge CLK or posedge reset)
	begin
		if(reset) begin
			hcounter<=0;
			vcounter<=0;
		end else begin
			hcounter<=hcounter+1;
			if(hcounter==11'd800)//800
				begin
				hcounter<=0;
				vcounter<=vcounter+1;
				end
			if(vcounter==10'd525)//525
				begin
				vcounter<=0;
				end
		end
	end

	always@(posedge CLK or posedge reset)
	begin
		if(reset) begin
			visible<=0;
			oHS<=0;
			oVS<=0;
		end else begin
			//visible
			if(hcounter>=11'd0 & hcounter < 11'd640 & vcounter >= 10'd0 &vcounter < 10'd480 )// visible=1 ,when (hcounter 0~639 and vcounter 0~479)
				visible <=1;
			else
				visible<=0;
			//oHS
			if(hcounter >= 11'd656 & hcounter < 11'd752)// oHS =0,when hcounter 656~751 ( Sync pulse 96 cycles)
				oHS<=0;
			else
				oHS<=1;
			//oVS
			if(vcounter >= 10'd490 & vcounter < 10'd492)// oVS =0,when vcounter 490~491 ( Sync pulse 2 cycles)
				oVS<=0;
			else
				oVS<=1;		
		end
		
	end
	
endmodule
