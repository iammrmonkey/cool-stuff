`timescale 1 ns/1 ps
//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2012 DLAB Course
//   Lab08      : PING_PONG_GAME
//   Author     : 
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : controll_ball.v
//   Module Name : controll_ball
//   Release version : v1.0 (Release Date: May-2012)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module tetris_controll
   (
    input wire clk, 
	 input wire reset,
    input wire [3:0] btn,						//switches on the board 3->reset 2->start
    input wire [9:0] pix_x, pix_y,
	 output wire graph_on,
    output reg [2:0] graph_rgb
   );
	
	reg fall_chk = 0;
	reg left_chk = 0;
	reg rhgt_chk = 0;
	reg rot_chk = 0;
	reg [2:0] block_sel = 3'b001;
	reg [27:0] counter = 0;
	reg [24:0] counter2 = 0;
	reg [9:0] yellow_x [3:0];					//line
	reg [9:0] yellow_y [3:0];
	reg [9:0] purple_x [3:0];					//square
	reg [9:0] purple_y [3:0];
	reg [9:0] cyan_x [3:0];						//lambda
	reg [9:0] cyan_y [3:0];
	reg [7:0] default_x = 200;
	reg [7:0] default_y = 70;
	reg cyan_rot = 0;								//cyan_rotate
	assign graph_on = 1;
	reg lock = 0;
	reg [2:0] rec [639:0][479:0];
	
	always @ (posedge clk)
	begin
		if (pix_x > 80 && pix_x < 320 && pix_y > 30 && pix_y < 470)
		begin
			if ( (pix_x > 80 && pix_x < 100 || pix_x > 300 && pix_x < 320) && pix_y > 30 && pix_y < 470 
			     ||  pix_x > 80 && pix_x < 320 && (pix_y > 30 && pix_y < 50 || pix_y > 450 && pix_y < 470)) 
			begin
				graph_rgb <= 3'b001;		//blue
			end
			else if((pix_x > yellow_x[0] && pix_x < yellow_x[0]+20) &&
					  (pix_y > yellow_y[0] && pix_y < yellow_y[0]+20) ||
					  (pix_x > yellow_x[1] && pix_x < yellow_x[1]+20) &&
					  (pix_y > yellow_y[1] && pix_y < yellow_y[1]+20) ||
					  (pix_x > yellow_x[2] && pix_x < yellow_x[2]+20) &&
					  (pix_y > yellow_y[2] && pix_y < yellow_y[2]+20) ||
					  (pix_x > yellow_x[3] && pix_x < yellow_x[3]+20) &&
					  (pix_y > yellow_y[3] && pix_y < yellow_y[3]+20) )
			begin
				graph_rgb <= 3'b110;		//yellow
			end
			else if ((pix_x > purple_x[0] && pix_x < purple_x[0]+20) &&
					   (pix_y > purple_y[0] && pix_y < purple_y[0]+20) ||
					   (pix_x > purple_x[1] && pix_x < purple_x[1]+20) &&
					   (pix_y > purple_y[1] && pix_y < purple_y[1]+20) ||
					   (pix_x > purple_x[2] && pix_x < purple_x[2]+20) &&
					   (pix_y > purple_y[2] && pix_y < purple_y[2]+20) ||
					   (pix_x > purple_x[3] && pix_x < purple_x[3]+20) &&
					   (pix_y > purple_y[3] && pix_y < purple_y[3]+20) )
			begin
				graph_rgb <= 3'b101;		//purple
			end
			else if ((pix_x > cyan_x[0] && pix_x < cyan_x[0]+20) &&
					   (pix_y > cyan_y[0] && pix_y < cyan_y[0]+20) ||
					   (pix_x > cyan_x[1] && pix_x < cyan_x[1]+20) &&
					   (pix_y > cyan_y[1] && pix_y < cyan_y[1]+20) ||
					   (pix_x > cyan_x[2] && pix_x < cyan_x[2]+20) &&
					   (pix_y > cyan_y[2] && pix_y < cyan_y[2]+20) ||
					   (pix_x > cyan_x[3] && pix_x < cyan_x[3]+20) &&
					   (pix_y > cyan_y[3] && pix_y < cyan_y[3]+20) )
			begin
				graph_rgb <= 3'b011;		//cyan
			end
			else
			begin
				graph_rgb <= 3'b111;		//white
			end
		end
		else
		begin
			graph_rgb <= 3'b000;			//black
		end
	end
	
	always @ (posedge clk)
	begin
		if (reset == 1) 
		begin
			default_x <= 200;
			default_y <= 70;
		end
		else
		begin
			default_x <= default_x;
			default_y <= default_y;
		end
	end
	
	always @ (posedge clk)			//ctrl the counter
	begin
		if (reset == 1) counter <= 0;
		else if (counter == 50000000) counter <= 0;
		else counter <= counter + 1;
	end
	
	always @ (posedge clk)			//ctrl the second counter
	begin
		if (reset == 1) counter2 <= 50;
		else if (counter2 == 10000000) counter2 <= 0;
		else counter2 <= counter2 + 1;
	end
	
	always @ (posedge clk) 			//clock for the blocks
	begin
		//yellow
		if (block_sel == 3'b000 || block_sel == 3'b001)
		begin
			purple_x[0] <= 0;
			purple_y[0] <= 0;
			purple_x[1] <= 0;
			purple_y[1] <= 0;
			purple_x[2] <= 0;
			purple_y[2] <= 0;
			purple_x[3] <= 0;
			purple_y[3] <= 0;
			
			cyan_rot <= 0;
			cyan_x[0] <= 0;
			cyan_y[0] <= 0;
			cyan_x[1] <= 0;
			cyan_y[1] <= 0;
			cyan_x[2] <= 0;
			cyan_y[2] <= 0;
			cyan_x[3] <= 0;
			cyan_y[3] <= 0;
			
			if ((yellow_y[0] == 430 || yellow_y[1] == 430 || yellow_y[2] == 430 || yellow_y[3] == 430) && counter == 10000000)
			begin
				block_sel <= 3'b011;
				yellow_x[0] <= default_x-20;
				yellow_y[0] <= default_y;
				yellow_x[1] <= default_x;
				yellow_y[1] <= default_y;
				yellow_x[2] <= default_x+20;
				yellow_y[2] <= default_y;
				yellow_x[3] <= default_x+40;
				yellow_y[3] <= default_y;
			end
			else if (reset == 1 || block_sel == 2'b01)
			begin
				block_sel <= 3'b000;
				yellow_x[0] <= default_x - 20;
				yellow_y[0] <= default_y;
				yellow_x[1] <= default_x;
				yellow_y[1] <= default_y;
				yellow_x[2] <= default_x + 20;
				yellow_y[2] <= default_y;
				yellow_x[3] <= default_x + 40;
				yellow_y[3] <= default_y;
			end
			else if (reset == 0)
			begin
				if (counter == 10000000)
				begin					
					yellow_x[0] <= yellow_x[0];
					yellow_y[0] <= yellow_y[0]+20;
					yellow_x[1] <= yellow_x[1];
					yellow_y[1] <= yellow_y[1]+20;
					yellow_x[2] <= yellow_x[2];
					yellow_y[2] <= yellow_y[2]+20;
					yellow_x[3] <= yellow_x[3];
					yellow_y[3] <= yellow_y[3]+20;
				end
				else
					if (btn[0] == 1 && counter2 == 50000) 			//up
					begin
						//vertical
						if (yellow_x[0] == yellow_x[1] && yellow_x[1] == yellow_x[2] && yellow_x[2] == yellow_x[3])
						begin
							if (yellow_x[0] < 141 || yellow_x[3] > 239)
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
							else
							begin
								yellow_x[0] <= yellow_x[1]-20;
								yellow_y[0] <= yellow_y[1];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[1]+20;
								yellow_y[2] <= yellow_y[1];
								yellow_x[3] <= yellow_x[1]+40;
								yellow_y[3] <= yellow_y[1];
							end
						end
						//horizontal
						else if ((yellow_y[0] == yellow_y[1] && yellow_y[1] == yellow_y[2] && yellow_y[2] == yellow_y[3]) && counter2 == 50000)
						begin
							if (yellow_y[0] > 409 || yellow_y[3] < 91)
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
							else
							begin
								yellow_x[0] <= yellow_x[1];
								yellow_y[0] <= yellow_y[1]+20;
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[1];
								yellow_y[2] <= yellow_y[1]-20;
								yellow_x[3] <= yellow_x[1];
								yellow_y[3] <= yellow_y[1]-40;
							end
						end
						//other circumstances
						else
						begin
							yellow_x[0] <= yellow_x[0];
							yellow_y[0] <= yellow_y[0];
							yellow_x[1] <= yellow_x[1];
							yellow_y[1] <= yellow_y[1];
							yellow_x[2] <= yellow_x[2];
							yellow_y[2] <= yellow_y[2];
							yellow_x[3] <= yellow_x[3];
							yellow_y[3] <= yellow_y[3];
						end
					end
					else if (btn[1] == 1 && counter2 == 50000)	//right
					begin
						if (yellow_x[0] > 279 || yellow_x[1] > 279 || yellow_x[2] > 279 || yellow_x[3] > 279)
						begin
							yellow_x[0] <= yellow_x[0];
							yellow_y[0] <= yellow_y[0];
							yellow_x[1] <= yellow_x[1];
							yellow_y[1] <= yellow_y[1];
							yellow_x[2] <= yellow_x[2];
							yellow_y[2] <= yellow_y[2];
							yellow_x[3] <= yellow_x[3];
							yellow_y[3] <= yellow_y[3];
						end
						else
						begin
							if (counter2 == 50000)
							begin
								yellow_x[0] <= yellow_x[0]+20;
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1]+20;
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2]+20;
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3]+20;
								yellow_y[3] <= yellow_y[3];
							end
							else
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
						end
					end
					else if (btn[2] == 1 && counter2 == 50000)	//down
					begin
						if (yellow_y[0] > 309 || yellow_y[1] > 309 || yellow_y[2] > 309 || yellow_y[3] > 309)
						begin
							if (yellow_y[0] == yellow_y[1] && yellow_y[2] == yellow_y[1] && yellow_y[2] == yellow_y[3])
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= 430;
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= 430;
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= 430;
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= 430;
							end
							else if (yellow_x[0] == yellow_x[1] && yellow_x[2] == yellow_x[1] && yellow_x[2] == yellow_x[3])
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= 430;
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= 410;
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= 390;
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= 370;
							end
							else
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
						end
						else
						begin
							if (counter2 == 50000)
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0]+120;
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1]+120;
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2]+120;
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3]+120;
							end
							else
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
						end
					end
					else if (btn[3] == 1 && counter2 == 50000)	//left
					begin
						if (yellow_x[0] < 119 || yellow_x[1] < 119 || yellow_x[2] < 119 || yellow_x[3] < 119)
						begin
							yellow_x[0] <= yellow_x[0];
							yellow_y[0] <= yellow_y[0];
							yellow_x[1] <= yellow_x[1];
							yellow_y[1] <= yellow_y[1];
							yellow_x[2] <= yellow_x[2];
							yellow_y[2] <= yellow_y[2];
							yellow_x[3] <= yellow_x[3];
							yellow_y[3] <= yellow_y[3];
						end
						else
						begin
							if (counter2 == 50000)
							begin
								yellow_x[0] <= yellow_x[0]-20;
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1]-20;
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2]-20;
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3]-20;
								yellow_y[3] <= yellow_y[3];
							end
							else
							begin
								yellow_x[0] <= yellow_x[0];
								yellow_y[0] <= yellow_y[0];
								yellow_x[1] <= yellow_x[1];
								yellow_y[1] <= yellow_y[1];
								yellow_x[2] <= yellow_x[2];
								yellow_y[2] <= yellow_y[2];
								yellow_x[3] <= yellow_x[3];
								yellow_y[3] <= yellow_y[3];
							end
						end
					end
					else
					begin
						yellow_x[0] <= yellow_x[0];
						yellow_y[0] <= yellow_y[0];
						yellow_x[1] <= yellow_x[1];
						yellow_y[1] <= yellow_y[1];
						yellow_x[2] <= yellow_x[2];
						yellow_y[2] <= yellow_y[2];
						yellow_x[3] <= yellow_x[3];
						yellow_y[3] <= yellow_y[3];
					end
				end
			end
			
			//purple
			else if (block_sel == 3'b011 || block_sel == 3'b010)
			begin
				yellow_x[0] <= 0;
				yellow_y[0] <= 0;
				yellow_x[1] <= 0;
				yellow_y[1] <= 0;
				yellow_x[2] <= 0;
				yellow_y[2] <= 0;
				yellow_x[3] <= 0;
				yellow_y[3] <= 0;
				
				cyan_rot <= 0;
				cyan_x[0] <= 0;
				cyan_y[0] <= 0;
				cyan_x[1] <= 0;
				cyan_y[1] <= 0;
				cyan_x[2] <= 0;
				cyan_y[2] <= 0;
				cyan_x[3] <= 0;
				cyan_y[3] <= 0;
				
				if ((purple_y[0] == 430 || purple_y[1] == 430 || purple_y[2] == 430 || purple_y[3] == 430) && counter == 10000000)
				begin
					block_sel <= 3'b101;
					purple_x[0] <= default_x;
					purple_y[0] <= default_y;
					purple_x[1] <= default_x+20;
					purple_y[1] <= default_y;
					purple_x[2] <= default_x;
					purple_y[2] <= default_y+20;
					purple_x[3] <= default_x+20;
					purple_y[3] <= default_y+20;
				end
				else if (reset == 1 || block_sel == 3'b011)
				begin
					block_sel <= 3'b010;
					purple_x[0] <= default_x;
					purple_y[0] <= default_y;
					purple_x[1] <= default_x+20;
					purple_y[1] <= default_y;
					purple_x[2] <= default_x;
					purple_y[2] <= default_y+20;
					purple_x[3] <= default_x+20;
					purple_y[3] <= default_y+20;
				end
				else if (reset == 0)
				begin
					if (counter == 10000000)
					begin					
						purple_x[0] <= purple_x[0];
						purple_y[0] <= purple_y[0]+20;
						purple_x[1] <= purple_x[1];
						purple_y[1] <= purple_y[1]+20;
						purple_x[2] <= purple_x[2];
						purple_y[2] <= purple_y[2]+20;
						purple_x[3] <= purple_x[3];
						purple_y[3] <= purple_y[3]+20;
					end
					else
						if (btn[0] == 1 && counter2 == 50000) 			//up (not affected)
						begin
							purple_x[0] <= purple_x[0];
							purple_y[0] <= purple_y[0];
							purple_x[1] <= purple_x[1];
							purple_y[1] <= purple_y[1];
							purple_x[2] <= purple_x[2];
							purple_y[2] <= purple_y[2];
							purple_x[3] <= purple_x[3];
							purple_y[3] <= purple_y[3];
						end
						else if (btn[1] == 1 && counter2 == 50000)	//right
						begin
							if (purple_x[0] > 279 || purple_x[1] > 279 || purple_x[2] > 279 || purple_x[3] > 279)
							begin
								purple_x[0] <= purple_x[0];
								purple_y[0] <= purple_y[0];
								purple_x[1] <= purple_x[1];
								purple_y[1] <= purple_y[1];
								purple_x[2] <= purple_x[2];
								purple_y[2] <= purple_y[2];
								purple_x[3] <= purple_x[3];
								purple_y[3] <= purple_y[3];
							end
							else
							begin
								if (counter2 == 50000)
								begin
									purple_x[0] <= purple_x[0]+20;
									purple_y[0] <= purple_y[0];
									purple_x[1] <= purple_x[1]+20;
									purple_y[1] <= purple_y[1];
									purple_x[2] <= purple_x[2]+20;
									purple_y[2] <= purple_y[2];
									purple_x[3] <= purple_x[3]+20;
									purple_y[3] <= purple_y[3];
								end
								else
								begin
									purple_x[0] <= purple_x[0];
									purple_y[0] <= purple_y[0];
									purple_x[1] <= purple_x[1];
									purple_y[1] <= purple_y[1];
									purple_x[2] <= purple_x[2];
									purple_y[2] <= purple_y[2];
									purple_x[3] <= purple_x[3];
									purple_y[3] <= purple_y[3];
								end
							end
						end
						else if (btn[2] == 1 && counter2 == 50000)	//down
						begin
							if (purple_y[0] > 309 || purple_y[1] > 309 || purple_y[2] > 309 || purple_y[3] > 309)
							begin
								purple_x[0] <= purple_x[0];
								purple_y[0] <= 410;
								purple_x[1] <= purple_x[1];
								purple_y[1] <= 410;
								purple_x[2] <= purple_x[2];
								purple_y[2] <= 430;
								purple_x[3] <= purple_x[3];
								purple_y[3] <= 430;		
							end
							else
							begin
								if (counter2 == 50000)
								begin
									purple_x[0] <= purple_x[0];
									purple_y[0] <= purple_y[0]+120;
									purple_x[1] <= purple_x[1];
									purple_y[1] <= purple_y[1]+120;
									purple_x[2] <= purple_x[2];
									purple_y[2] <= purple_y[2]+120;
									purple_x[3] <= purple_x[3];
									purple_y[3] <= purple_y[3]+120;
								end
								else
								begin
									purple_x[0] <= purple_x[0];
									purple_y[0] <= purple_y[0];
									purple_x[1] <= purple_x[1];
									purple_y[1] <= purple_y[1];
									purple_x[2] <= purple_x[2];
									purple_y[2] <= purple_y[2];
									purple_x[3] <= purple_x[3];
									purple_y[3] <= purple_y[3];
								end
							end
						end
						else if (btn[3] == 1 && counter2 == 50000)	//left
						begin
							if (purple_x[0] < 119 || purple_x[1] < 119 || purple_x[2] < 119 || purple_x[3] < 119)
							begin
								purple_x[0] <= purple_x[0];
								purple_y[0] <= purple_y[0];
								purple_x[1] <= purple_x[1];
								purple_y[1] <= purple_y[1];
								purple_x[2] <= purple_x[2];
								purple_y[2] <= purple_y[2];
								purple_x[3] <= purple_x[3];
								purple_y[3] <= purple_y[3];
							end
							else
							begin
								if (counter2 == 50000)
								begin
									purple_x[0] <= purple_x[0]-20;
									purple_y[0] <= purple_y[0];
									purple_x[1] <= purple_x[1]-20;
									purple_y[1] <= purple_y[1];
									purple_x[2] <= purple_x[2]-20;
									purple_y[2] <= purple_y[2];
									purple_x[3] <= purple_x[3]-20;
									purple_y[3] <= purple_y[3];
								end
								else
								begin
									purple_x[0] <= purple_x[0];
									purple_y[0] <= purple_y[0];
									purple_x[1] <= purple_x[1];
									purple_y[1] <= purple_y[1];
									purple_x[2] <= purple_x[2];
									purple_y[2] <= purple_y[2];
									purple_x[3] <= purple_x[3];
									purple_y[3] <= purple_y[3];
								end
							end
						end
						else
						begin
							purple_x[0] <= purple_x[0];
							purple_y[0] <= purple_y[0];
							purple_x[1] <= purple_x[1];
							purple_y[1] <= purple_y[1];
							purple_x[2] <= purple_x[2];
							purple_y[2] <= purple_y[2];
							purple_x[3] <= purple_x[3];
							purple_y[3] <= purple_y[3];
						end
				end			
			end
			
			//cyan
			else if (block_sel == 3'b100 || block_sel == 3'b101 || block_sel == 3'b110 || block_sel == 3'b111)
			begin
				yellow_x[0] <= 0;
				yellow_y[0] <= 0;
				yellow_x[1] <= 0;
				yellow_y[1] <= 0;
				yellow_x[2] <= 0;
				yellow_y[2] <= 0;
				yellow_x[3] <= 0;
				yellow_y[3] <= 0;
				
				purple_x[0] <= 0;
				purple_y[0] <= 0;
				purple_x[1] <= 0;
				purple_y[1] <= 0;
				purple_x[2] <= 0;
				purple_y[2] <= 0;
				purple_x[3] <= 0;
				purple_y[3] <= 0;
				
				if ((cyan_y[0] == 430 || cyan_y[1] == 430 || cyan_y[2] == 430 || cyan_y[3] == 430) && counter == 10000000)
				begin
					block_sel <= 3'b001;
					cyan_x[0] <= default_x;
					cyan_y[0] <= default_y;
					cyan_x[1] <= default_x-20;
					cyan_y[1] <= default_y+20;
					cyan_x[2] <= default_x;
					cyan_y[2] <= default_y+20;
					cyan_x[3] <= default_x+20;
					cyan_y[3] <= default_y+20;
				end
				else if (reset == 1 || block_sel == 3'b101)
				begin
					block_sel <= 3'b100;
					cyan_x[0] <= default_x;
					cyan_y[0] <= default_y;
					cyan_x[1] <= default_x-20;
					cyan_y[1] <= default_y+20;
					cyan_x[2] <= default_x;
					cyan_y[2] <= default_y+20;
					cyan_x[3] <= default_x+20;
					cyan_y[3] <= default_y+20;
				end
				else if (reset == 0)
				begin
					if (counter == 10000000)
					begin					
						cyan_x[0] <= cyan_x[0];
						cyan_y[0] <= cyan_y[0]+20;
						cyan_x[1] <= cyan_x[1];
						cyan_y[1] <= cyan_y[1]+20;
						cyan_x[2] <= cyan_x[2];
						cyan_y[2] <= cyan_y[2]+20;
						cyan_x[3] <= cyan_x[3];
						cyan_y[3] <= cyan_y[3]+20;
					end
					else
						if (btn[0] == 1 && counter2 == 50000) 			//up
						begin
							if (cyan_x[0] < 119 || cyan_x[1] < 119 || cyan_x[2] < 119 || cyan_x[3] < 119 ||
								 cyan_x[0] > 261 || cyan_x[1] > 261 || cyan_x[2] > 261 || cyan_x[3] > 261 ||
								 cyan_y[0] < 89 || cyan_y[1] < 89 || cyan_y[2] < 89 || cyan_y[3] < 89 ||
								 cyan_y[0] > 411 || cyan_y[1] > 411 || cyan_y[2] > 411 || cyan_y[3] > 411)
							begin
								cyan_x[0] <= cyan_x[0];
								cyan_y[0] <= cyan_y[0];
								cyan_x[1] <= cyan_x[1];
								cyan_y[1] <= cyan_y[1];
								cyan_x[2] <= cyan_x[2];
								cyan_y[2] <= cyan_y[2];
								cyan_x[3] <= cyan_x[3];
								cyan_y[3] <= cyan_y[3];
							end
							else
							begin
								cyan_x[0] <= cyan_x[0];
								cyan_y[0] <= cyan_y[0];
								cyan_x[1] <= (cyan_rot == 0) ? (cyan_x[0]*2 - cyan_x[1]) : (cyan_x[1]);
								cyan_y[1] <= (cyan_rot == 0) ? (cyan_y[1]) : (cyan_y[0]*2 - cyan_y[1]);
								if (cyan_x[2] == cyan_x[0] && cyan_y[2] > cyan_y[0]) begin cyan_x[2] <= cyan_x[2] + 20; cyan_y[2] <= cyan_y[2] - 20; end
								else if (cyan_x[2] == cyan_x[0] && cyan_y[2] < cyan_y[0]) begin cyan_x[2] <= cyan_x[2] - 20; cyan_y[2] <= cyan_y[2] + 20; end
								else if (cyan_x[2] > cyan_x[0]) begin cyan_x[2] <= cyan_x[2] - 20; cyan_y[2] <= cyan_y[2] - 20; end
								else if (cyan_x[2] < cyan_x[0]) begin cyan_x[2] <= cyan_x[2] + 20; cyan_y[2] <= cyan_y[2] + 20; end
								else begin cyan_x[2] <= cyan_x[2]; cyan_y[2] <= cyan_y[2]; end
								cyan_x[3] <= (cyan_rot == 0) ? (cyan_x[3]) : (cyan_x[0]*2 - cyan_x[3]);
								cyan_y[3] <= (cyan_rot == 0) ? (cyan_y[0]*2 - cyan_y[3]) : (cyan_y[3]);
								cyan_rot <= ~ cyan_rot;
							end
						end
						else if (btn[1] == 1 && counter2 == 50000)	//right
						begin
							if (cyan_x[0] > 279 || cyan_x[1] > 279 || cyan_x[2] > 279 || cyan_x[3] > 279)
							begin
								cyan_x[0] <= cyan_x[0];
								cyan_y[0] <= cyan_y[0];
								cyan_x[1] <= cyan_x[1];
								cyan_y[1] <= cyan_y[1];
								cyan_x[2] <= cyan_x[2];
								cyan_y[2] <= cyan_y[2];
								cyan_x[3] <= cyan_x[3];
								cyan_y[3] <= cyan_y[3];
							end
							else
							begin
								if (counter2 == 50000)
								begin
									cyan_x[0] <= cyan_x[0]+20;
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1]+20;
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2]+20;
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3]+20;
									cyan_y[3] <= cyan_y[3];
								end
								else
								begin
									cyan_x[0] <= cyan_x[0];
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1];
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2];
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3];
									cyan_y[3] <= cyan_y[3];
								end
							end
						end
						else if (btn[2] == 1 && counter2 == 50000)	//down
						begin
							if (cyan_y[0] > 309 || cyan_y[1] > 309 || cyan_y[2] > 309 || cyan_y[3] > 309)
							begin
								if (cyan_y[0] < 429 && cyan_y[1] < 429 && cyan_y[2] < 429 && cyan_y[3] < 429)
								begin
									if (cyan_y[0] > cyan_y[2]) //head is downward
									begin
										cyan_y[0] <= 430;
										cyan_y[1] <= 410; cyan_y[2] <= 410; cyan_y[3] <= 410;
										cyan_x[0] <= cyan_x[0]; cyan_x[1] <= cyan_x[1]; cyan_x[2] <= cyan_x[2]; cyan_x[3] <= cyan_x[3];
									end
									else if (cyan_y[0] == cyan_y[2])
									begin
										cyan_y[0] <= 410;
										cyan_y[2] <= 410;
										if (cyan_y[1] > cyan_y[3]) begin cyan_y[1] <= 430; cyan_y[3] <= 390; end
										else begin cyan_y[1] <= 390; cyan_y[3] <= 430; end
									end
									else								//head is upward
									begin
										cyan_y[0] <= 410;
										cyan_y[1] <= 430; cyan_y[2] <= 430; cyan_y[3] <= 430;
										cyan_x[0] <= cyan_x[0]; cyan_x[1] <= cyan_x[1]; cyan_x[2] <= cyan_x[2]; cyan_x[3] <= cyan_x[3];
									end
								end
								else
								begin
									cyan_x[0] <= cyan_x[0];
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1];
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2];
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3];
									cyan_y[3] <= cyan_y[3];
								end
							end
							else
							begin
								if (counter2 == 50000)
								begin
									cyan_x[0] <= cyan_x[0];
									cyan_y[0] <= cyan_y[0]+120;
									cyan_x[1] <= cyan_x[1];
									cyan_y[1] <= cyan_y[1]+120;
									cyan_x[2] <= cyan_x[2];
									cyan_y[2] <= cyan_y[2]+120;
									cyan_x[3] <= cyan_x[3];
									cyan_y[3] <= cyan_y[3]+120;
								end
								else
								begin
									cyan_x[0] <= cyan_x[0];
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1];
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2];
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3];
									cyan_y[3] <= cyan_y[3];
								end
							end
						end
						else if (btn[3] == 1 && counter2 == 50000)	//left
						begin
							if (cyan_x[0] < 119 || cyan_x[1] < 119 || cyan_x[2] < 119 || cyan_x[3] < 119)
							begin
								cyan_x[0] <= cyan_x[0];
								cyan_y[0] <= cyan_y[0];
								cyan_x[1] <= cyan_x[1];
								cyan_y[1] <= cyan_y[1];
								cyan_x[2] <= cyan_x[2];
								cyan_y[2] <= cyan_y[2];
								cyan_x[3] <= cyan_x[3];
								cyan_y[3] <= cyan_y[3];
							end
							else
							begin
								if (counter2 == 50000)
								begin
									cyan_x[0] <= cyan_x[0]-20;
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1]-20;
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2]-20;
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3]-20;
									cyan_y[3] <= cyan_y[3];
								end
								else
								begin
									cyan_x[0] <= cyan_x[0];
									cyan_y[0] <= cyan_y[0];
									cyan_x[1] <= cyan_x[1];
									cyan_y[1] <= cyan_y[1];
									cyan_x[2] <= cyan_x[2];
									cyan_y[2] <= cyan_y[2];
									cyan_x[3] <= cyan_x[3];
									cyan_y[3] <= cyan_y[3];
								end
							end
						end
						else
						begin
							cyan_x[0] <= cyan_x[0];
							cyan_y[0] <= cyan_y[0];
							cyan_x[1] <= cyan_x[1];
							cyan_y[1] <= cyan_y[1];
							cyan_x[2] <= cyan_x[2];
							cyan_y[2] <= cyan_y[2];
							cyan_x[3] <= cyan_x[3];
							cyan_y[3] <= cyan_y[3];
						end
					end
			end
			
			//all of the situations are discussed.
	end
	
/*	
	always @ (posedge clk)
	begin
		if (reset == 1)
		begin
			rec [451] <= 1;rec [452] <= 1;rec [453] <= 1;rec [454] <= 1;rec [455] <= 1;
			rec [456] <= 1;rec [457] <= 1;rec [458] <= 1;rec [459] <= 1;rec [460] <= 1;
			rec [461] <= 1;rec [462] <= 1;rec [463] <= 1;rec [464] <= 1;rec [465] <= 1;
			rec [466] <= 1;rec [467] <= 1;rec [468] <= 1;rec [469] <= 1;rec [470] <= 1;
			rec [471] <= 1;rec [472] <= 1;rec [473] <= 1;rec [474] <= 1;rec [475] <= 1;
			rec [476] <= 1;rec [477] <= 1;rec [478] <= 1;rec [479] <= 1;rec [480] <= 1;
			rec [481] <= 1;rec [482] <= 1;rec [483] <= 1;rec [484] <= 1;rec [485] <= 1;
			rec [486] <= 1;rec [487] <= 1;rec [488] <= 1;rec [489] <= 1;rec [490] <= 1;
			rec [491] <= 1;rec [492] <= 1;rec [493] <= 1;rec [494] <= 1;rec [495] <= 1;
			rec [496] <= 1;rec [497] <= 1;rec [498] <= 1;rec [499] <= 1;rec [500] <= 1;
			rec [501] <= 1;rec [502] <= 1;rec [503] <= 1;rec [504] <= 1;rec [505] <= 1;
			rec [506] <= 1;rec [507] <= 1;rec [508] <= 1;rec [509] <= 1;rec [510] <= 1;
			rec [511] <= 1;rec [512] <= 1;rec [513] <= 1;rec [514] <= 1;rec [515] <= 1;
			rec [516] <= 1;rec [517] <= 1;rec [518] <= 1;rec [519] <= 1;rec [520] <= 1;
			rec [521] <= 1;rec [522] <= 1;rec [523] <= 1;rec [524] <= 1;rec [525] <= 1;
			rec [526] <= 1;rec [527] <= 1;rec [528] <= 1;rec [529] <= 1;rec [530] <= 1;
			rec [531] <= 1;rec [532] <= 1;rec [533] <= 1;rec [534] <= 1;rec [535] <= 1;
			rec [536] <= 1;rec [537] <= 1;rec [538] <= 1;rec [539] <= 1;rec [540] <= 1;
			rec [541] <= 1;rec [542] <= 1;rec [543] <= 1;rec [544] <= 1;rec [545] <= 1;
			rec [546] <= 1;rec [547] <= 1;rec [548] <= 1;rec [549] <= 1;rec [550] <= 1;
			rec [551] <= 1;rec [552] <= 1;rec [553] <= 1;rec [554] <= 1;rec [555] <= 1;
			rec [556] <= 1;rec [557] <= 1;rec [558] <= 1;rec [559] <= 1;rec [560] <= 1;
			rec [561] <= 1;rec [562] <= 1;rec [563] <= 1;rec [564] <= 1;rec [565] <= 1;
			rec [566] <= 1;rec [567] <= 1;rec [568] <= 1;rec [569] <= 1;rec [570] <= 1;
			rec [571] <= 1;rec [572] <= 1;rec [573] <= 1;rec [574] <= 1;rec [575] <= 1;
			rec [576] <= 1;rec [577] <= 1;rec [578] <= 1;rec [579] <= 1;rec [580] <= 1;
			rec [581] <= 1;rec [582] <= 1;rec [583] <= 1;rec [584] <= 1;rec [585] <= 1;
			rec [586] <= 1;rec [587] <= 1;rec [588] <= 1;rec [589] <= 1;rec [590] <= 1;
			rec [591] <= 1;rec [592] <= 1;rec [593] <= 1;rec [594] <= 1;rec [595] <= 1;
			rec [596] <= 1;rec [597] <= 1;rec [598] <= 1;rec [599] <= 1;rec [600] <= 1;
			rec [601] <= 1;rec [602] <= 1;rec [603] <= 1;rec [604] <= 1;rec [605] <= 1;
			rec [606] <= 1;rec [607] <= 1;rec [608] <= 1;rec [609] <= 1;rec [610] <= 1;
			rec [611] <= 1;rec [612] <= 1;rec [613] <= 1;rec [614] <= 1;rec [615] <= 1;
			rec [616] <= 1;rec [617] <= 1;rec [618] <= 1;rec [619] <= 1;rec [620] <= 1;
			rec [621] <= 1;rec [622] <= 1;rec [623] <= 1;rec [624] <= 1;rec [625] <= 1;
			rec [626] <= 1;rec [627] <= 1;rec [628] <= 1;rec [629] <= 1;rec [630] <= 1;
			rec [631] <= 1;rec [632] <= 1;rec [633] <= 1;rec [634] <= 1;rec [635] <= 1;
			rec [636] <= 1;rec [637] <= 1;rec [638] <= 1;rec [639] <= 1;
		end
		else
		begin
			//if there is something
		end
	end
*/	
	always @ (posedge clk) //lock
	begin
		if (rec[yellow_x[0]][yellow_y[0]+30]!=0 || rec[yellow_x[1]][yellow_y[1]+30]!=0 ||
		    rec[yellow_x[2]][yellow_y[2]+30]!=0 || rec[yellow_x[3]][yellow_y[3]+30]!=0 ||
			 rec[purple_x[0]][purple_y[0]+30]!=0 || rec[purple_x[1]][purple_y[1]+30]!=0 ||
		    rec[purple_x[2]][purple_y[2]+30]!=0 || rec[purple_x[3]][purple_y[3]+30]!=0 ||
			 rec[cyan_x[0]][cyan_y[0]+30]!=0 || rec[cyan_x[1]][cyan_y[1]+30]!=0 ||
		    rec[cyan_x[2]][cyan_y[2]+30]!=0 || rec[cyan_x[3]][cyan_y[3]+30]!=0)
		begin
			lock <= 1;
		end
		else
		begin
			lock <= 0;
		end
	end
	
endmodule
