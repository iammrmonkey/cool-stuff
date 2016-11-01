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
module controll_ball
   (
    input wire clk, reset,
    input wire [1:0] btn,
    input wire [9:0] pix_x, pix_y,
	 output wire graph_on,
    output reg [2:0] graph_rgb
   );

	reg limit;
	reg [3:0] Radius;
	reg move_left;
	reg move_right;
	reg move_up;
	reg move_down;
	reg [9:0] ball_x;
	reg [9:0] ball_y;
	reg [27:0] counter1;
	reg [27:0] counter2;
	reg [21:0] x1;
	reg [21:0] x2;
	reg [21:0] y1;
	reg [21:0] y2;
	reg [21:0] r;
	reg [9:0] pad_y;
	reg [9:0] pad_x;
	reg [9:0] pad_width;
	reg dead;
	reg [3:0] thickness;
   wire gra_on;
	
	assign gra_on = ~((pix_y[9:5]==0) && (pix_x[9:4]<16));
   assign graph_on = gra_on;
	
	always @ (posedge clk)
	begin
		if (reset)		//initialize
		begin
			move_left <= 0;
			move_right <= 1;
			move_up <= 0;
			move_down <= 1;
			Radius <= 8;
			ball_x <= 320;
			ball_y <= 240;
			counter1 <= 0;
			counter2 <= 0;
			pad_y <= 200;
			pad_x <= 615;
			pad_width <= 40;
			dead <= 0;
			thickness <= 5;
		end
		else
		begin
			if (dead == 1)				//dead => back to normal
			begin
				ball_x <= 320;
				ball_y <= 240;
				pad_y <= 200;
				dead <= 0;
			end
			else
			begin
				//this is just a counter
				//control pad
				if (counter2 == 200000)
				begin
                counter2 <= 0;
                if ((btn == 1) && ((pad_y - pad_width) > 0)) pad_y <= pad_y - 1;
                else if((btn == 2) && ((pad_y + pad_width) < 480)) pad_y <= pad_y + 1;
                else pad_y <= pad_y;
            end
            else counter2 <= counter2 + 1;
			
				//x
            if((ball_x - Radius) == 30)				//we set the wall at x = 30
				begin
                move_left <= 0;
                move_right <= 1;
            end
            else if((ball_x + Radius) == pad_x)		//if the ball hits the pad
				begin
                if((ball_y < (pad_y + pad_width + Radius)) && (ball_y > (pad_y - pad_width - Radius)))
					 begin
                    move_left <= 1;
                    move_right <= 0;
                end
                else
					 begin
                    move_left <= move_left;
                    move_right <= move_right;
                end
            end
            else if((ball_x + Radius) == 640)
				begin
                dead <= 1;
            end
            else
				begin
                move_left <= move_left;
                move_right <= move_right;
            end

            //y
            if((ball_y - Radius) <= 0)
				begin
					 move_up <= 0;
                move_down <= 1;
            end
            else if((ball_y + Radius) >= 480)
				begin
					 move_up <= 1;
                move_down <= 0;
            end
            else
				begin
                move_up <= move_up;
                move_down <= move_down;
            end
				
				if(counter1 == 250000)
				begin
                ball_x <= ball_x - move_left + move_right;
                ball_y <= ball_y - move_up + move_down;
                counter1 <= 0;
            end
            else counter1 <= counter1 + 1;


            if (pix_x >= ball_x) x1 <= pix_x - ball_x;
            else x1 <= ball_x - pix_x;

            if (pix_y >= ball_y) y1 <= pix_y - ball_y;
            else y1 <= ball_y - pix_y;
				
				//show
            x2 <= x1 * x1;
            y2 <= y1 * y1;
            r <= Radius * Radius;
            if ((pix_x > 25) && (pix_x < 30 )) graph_rgb <= 3'b001;				//the color of wall = blue
            else if (x2 + y2 < r) graph_rgb <= 3'b010;								//x * x + y * y < r * r => green (the color of ball)
            else if((pix_x > pad_x) && (pix_x < (pad_x + thickness)) && (pix_y < (pad_y + pad_width)) && (pix_y > (pad_y - pad_width))) graph_rgb <= 3'b100; //pad
            else graph_rgb <= 3'b111;
				
			end
		end
	end

endmodule
