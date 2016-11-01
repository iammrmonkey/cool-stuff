`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:46:33 05/08/2011 
// Design Name: 
// Module Name:    Lab7-test1
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
module Lab7test1(
	 input iCLK_50,
    input [3:0] iSW,
    input ROT_A,
    input ROT_B,
    output reg oVGA_R,
    output reg oVGA_G,
    output reg oVGA_B,
    output oHS,
    output oVS,
    output [7:0] oLED
    );
reg CLK_25;
wire reset;
wire [11:0]hcounter;
wire [10:0]vcounter;
reg [7:0] led_buf;

assign oLED=led_buf;

assign reset = iSW[3];
// generate a 25Mhz clock
always @(posedge iCLK_50)
	if(iCLK_50)
	CLK_25=~CLK_25;

VGA_control vga_c(.CLK(CLK_25),.reset(reset),.vcounter(vcounter),.hcounter(hcounter),.visible(visible),.oHS(oHS),.oVS(oVS));

always @(*)
begin
	if(visible) begin //hcounter 0~639 and vcounter 0~479
		case ({iSW[1],iSW[0]})
		2'b00:
		begin 
			oVGA_R=hcounter[7];
			oVGA_G=hcounter[8];
			oVGA_B=hcounter[9];
		end
		2'b01:
		begin 
			oVGA_R=vcounter[6];
			oVGA_G=vcounter[7];
			oVGA_B=vcounter[8];
		end
		2'b10:
		begin 
			oVGA_R=hcounter[5];
			oVGA_G=vcounter[5];
			oVGA_B=1'b0;
		end
		2'b11:
		begin 
			oVGA_R=hcounter[5] ~^ vcounter[5];//xor
			oVGA_G=1'b0;
			oVGA_B=hcounter[5] ~^ vcounter[5];//xor

		end
		default:
		begin 
			oVGA_R=oVGA_R;
			oVGA_G=oVGA_G;
			oVGA_B=oVGA_B;
		end
		endcase 
	end else begin
		oVGA_R=1'b0;
		oVGA_G=1'b0;
		oVGA_B=1'b0;
	end
end
endmodule
