`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:16:26 05/15/2012 
// Design Name: 
// Module Name:    PS2_control 
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
module PS2_Control (iCLK_50, PS2_CLK, PS2_DATA, reset, oLED, Radius);
    input iCLK_50;
    input PS2_CLK;
    input PS2_DATA;
    input reset;
    output reg [7:0] Radius = 8'b00110010;
    output reg [7:0] oLED = 8'b00000000;
	 reg a;
	 reg b;
	 reg [7:0] c = 0;
	 reg [0:21] data;	
	 //reg flag = 0;
	 
	 //read
	 always @ ( posedge iCLK_50 )
	 begin
		a <= b;
		b <= PS2_CLK;
		if (b == 0 && a == 1)
		begin
			 data[0] <= data[1];
			 data[1] <= data[2];
			 data[2] <= data[3];
			 data[3] <= data[4];
			 data[4] <= data[5];
			 data[5] <= data[6];
			 data[6] <= data[7];
			 data[7] <= data[8];
			 data[8] <= data[9];
			 data[9] <= data[10];
			 data[10] <= data[11];
			 data[11] <= data[12];
			 data[12] <= data[13];
			 data[13] <= data[14];
			 data[14] <= data[15];
			 data[15] <= data[16];
			 data[16] <= data[17];
			 data[17] <= data[18];
			 data[18] <= data[19];
			 data[19] <= data[20];
			 data[20] <= data[21];
			 data[21] <= PS2_DATA;
		end
		else
		begin
			 data <= data;
	   end
	 end
	 
	 always @ ( posedge iCLK_50 )
	 begin
		  if (data[0:10] == 11'b00000111111)
		  begin
        case (data)
            22'b0000011111100110100001: oLED <= 1;
            22'b0000011111100111100011: oLED <= 2;
            22'b0000011111100110010001: oLED <= 3;
            22'b0000011111101010010001: oLED <= 4;
            22'b0000011111100111010011: oLED <= 5;
            22'b0000011111100110110011: oLED <= 6;
            22'b0000011111101011110001: oLED <= 7;
            22'b0000011111100111110001: oLED <= 8;
            22'b0000011111100110001001: oLED <= 9;
            22'b0000011111101010001001: oLED <= 0;
            default: oLED <= oLED;
        endcase
		  end
		  else oLED <= oLED;
	  end
	 
	 always @ (posedge iCLK_50)
	 begin
			if (reset == 1) Radius <= 50;
			else if (reset == 0)
			begin
				if (data == 22'b0000011111100101101011)
				begin
					Radius <= c;
				end
				else
				begin
					Radius <= Radius;
				end
			end
	 end
	 
	 always @ (posedge iCLK_50)
	 begin
			if (reset == 1) c <= 50;
			else
			begin
				if (data [0:10] == 11'b00000111111) 
				begin
					case (data)
						22'b0000011111100110100001: begin c <= 20; end
						22'b0000011111100111100011: begin c <= 40; end
						22'b0000011111100110010001: begin c <= 60; end
						22'b0000011111101010010001: begin c <= 80; end
						22'b0000011111100111010011: begin c <= 100; end
						22'b0000011111100110110011: begin c <= 120; end
						22'b0000011111101011110001: begin c <= 140; end
						22'b0000011111100111110001: begin c <= 160; end
						22'b0000011111100110001001: begin c <= 180; end
						default: begin c <= c; end	//enter
					endcase
				end
				else
				begin
					 c <= c;
				end
			end
	 end
	 
endmodule 
