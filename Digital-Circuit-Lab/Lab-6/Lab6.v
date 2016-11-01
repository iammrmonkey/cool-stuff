`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:38:43 05/03/2012 
// Design Name: 
// Module Name:    Lab6 
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
module Lab6(iCLK, iBTN, iSW, oLED);
	input iCLK;						//clock
	input iBTN;						//reset
	input [3:0] iSW;				//iSW[0] for enable, iSW[1..3] for mode
	output reg [7:0] oLED;		//the output
	reg [31:0] counter = 0;
	reg [31:0] counter2 = 0;
	reg [7:0] signal1 = 8'b10111100;	//188 //do not consider randomizing them first
	reg [7:0] signal2 = 8'b00011000;	//24
	reg [7:0] signal3 = 8'b00100111;	//39
	reg [7:0] signal4 = 8'b10101010;	//170
	reg [1:0] start = 0;					//if a reset signal is received, then it will become 2
	reg [1:0] flag = 0;					//if it has been switched to another mode...
	reg [1:0] allow = 0;					//00, 01, 11
	
	always @ (posedge iCLK)
	begin
		if (iBTN)
		begin
			start <= 2;
			signal1[7] <= signal1[1] ^ signal1[0];
			signal1[6:0] <= signal1[7:1];
			signal2[7] <= signal2[1] ^ signal2[0];
			signal2[6:0] <= signal2[7:1];
			signal3[7] <= signal3[1] ^ signal3[0];
			signal3[6:0] <= signal3[7:1];
			signal4[7] <= signal4[1] ^ signal4[0];
			signal4[6:0] <= signal4[7:1];
		end
		else if (iSW[0] == 1) start <= 1;
	end
	
	always @ (posedge iCLK)
	begin
		if (iSW[0] == 1'b0 || iBTN == 1'b1)
		begin
			counter2 <= 0;
		end
		else if (iSW[0] == 1'b1)
		begin
			counter2 <= counter2 + 1;
		end
	end
	
	always @ (posedge iCLK)
	begin
		if (iBTN) 
		begin
			oLED <= 8'b11111111;
			flag <= 0;
			counter <= 0;
		end
		else if (start == 2)
		begin
			if (counter < 16777216) counter <= counter + 1;
			else if (counter % 16777216 == 0)
				begin
					counter <= counter + 1;
					oLED <= ~oLED;
					counter <= 0;
				end
			else oLED <= oLED;
		end
		else if (start == 1)
		begin
				case (iSW [3:1])
				3'b000:													//show the first signal
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						if (flag == 0) oLED <= signal1;
						else if (flag == 1) oLED <= signal2;
						else if (flag == 2) oLED <= signal3;
						else if (flag == 3) oLED <= signal4;
					end
					else oLED <= oLED;
				end
				3'b001:													//forward
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						if (flag == 0)
						begin
							oLED <= signal1;
							flag <= 0;
						end
						else if (flag == 1)
						begin
							oLED <= signal1;
							flag <= 0;
						end
						else if (flag == 2)
						begin
							oLED <= signal2;
							flag <= 1;
						end
						else if (flag == 3)
						begin
							oLED <= signal3;
							flag <= 2;
						end
					end
					else oLED <= oLED;
				end
				3'b010:													//rewind
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						if (flag == 0)
						begin
							oLED <= signal2;
							flag <= 1;
						end
						else if (flag == 1)
						begin
							oLED <= signal3;
							flag <= 2;
						end
						else if (flag == 2)
						begin
							oLED <= signal4;
							flag <= 3;
						end
						else if (flag == 3)
						begin
							oLED <= signal4;
							flag <= 3;
						end
					end
					else oLED <= oLED;
				end
				3'b011:													//if you are 1 or your neighbor is 1 then you will be 1
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						oLED [0] <= 					 (oLED[1] == 1) ? 1 : oLED[0];
						oLED [1] <= (oLED[0] == 1 || oLED[2] == 1) ? 1 : oLED[1];
						oLED [2] <= (oLED[1] == 1 || oLED[3] == 1) ? 1 : oLED[2];
						oLED [3] <= (oLED[2] == 1 || oLED[4] == 1) ? 1 : oLED[3];
						oLED [4] <= (oLED[3] == 1 || oLED[5] == 1) ? 1 : oLED[4];
						oLED [5] <= (oLED[4] == 1 || oLED[6] == 1) ? 1 : oLED[5];
						oLED [6] <= (oLED[5] == 1 || oLED[7] == 1) ? 1 : oLED[6];
						oLED [7] <= (oLED[6] == 1) 			   	 ? 1 : oLED[7];
					end
					else oLED <= oLED;
				end
				3'b100:													//if you are 0 or your neighbor is 0 then you will be 0
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						oLED [0] <= 0;
						oLED [1] <= (oLED[0] == 0 || oLED[2] == 0) ? 0 : oLED[1];
						oLED [2] <= (oLED[1] == 0 || oLED[3] == 0) ? 0 : oLED[2];
						oLED [3] <= (oLED[2] == 0 || oLED[4] == 0) ? 0 : oLED[3];
						oLED [4] <= (oLED[3] == 0 || oLED[5] == 0) ? 0 : oLED[4];
						oLED [5] <= (oLED[4] == 0 || oLED[6] == 0) ? 0 : oLED[5];
						oLED [6] <= (oLED[5] == 0 || oLED[7] == 0) ? 0 : oLED[6];
						oLED [7] <= 0;
					end
					else oLED <= oLED;
				end
				3'b101:													//rotate 180 degrees
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						oLED[0] <= oLED[7];
						oLED[1] <= oLED[6];
						oLED[2] <= oLED[5];
						oLED[3] <= oLED[4];
						oLED[4] <= oLED[3];
						oLED[5] <= oLED[2];
						oLED[6] <= oLED[1];
						oLED[7] <= oLED[0];
					end
					else oLED <= oLED;
				end
				3'b110:													//move left
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						oLED[0] <= oLED[7];
						oLED[1] <= oLED[0];
						oLED[2] <= oLED[1];
						oLED[3] <= oLED[2];
						oLED[4] <= oLED[3];
						oLED[5] <= oLED[4];
						oLED[6] <= oLED[5];
						oLED[7] <= oLED[6];
					end
					else oLED <= oLED;
				end
				3'b111:													//move right
				begin
					if (counter2 == 10000000)
					begin
						allow <= 0;
						oLED[0] <= oLED[1];
						oLED[1] <= oLED[2];
						oLED[2] <= oLED[3];
						oLED[3] <= oLED[4];
						oLED[4] <= oLED[5];
						oLED[5] <= oLED[6];
						oLED[6] <= oLED[7];
						oLED[7] <= oLED[0];
					end
					else oLED <= oLED;
				end
				endcase
		end
		else if (start == 0 || start == 3)
		begin
			allow <= 0;
			oLED <= 0;
		end
	end

endmodule
