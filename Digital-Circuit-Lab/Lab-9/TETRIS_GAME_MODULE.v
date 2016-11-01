//############################################################################
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//   (C) Copyright Laboratory System Integration and Silicon Implementation
//   All Right Reserved
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   2012 DLAB Course
//   Lab08      : PING_PONG_GAME
//   Author     : Szu-Chi, Chung (phonchi@si2lab.org) (v1.0)
//                
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//   File Name   : PING_PONG.v
//   Module Name : PING_PONG
//   Release version : v1.0 (Release Date: May-2012)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################

module TETRIS_GAME_MODULE
   (
    input wire iCLK_50, reset,
	input wire [3:0] iBTN,
	output wire oHS, oVS,
    output wire  oVGA_R,
    output wire  oVGA_G,
    output wire  oVGA_B
   );

   // signal declaration
   wire [9:0] pixel_x, pixel_y;
   wire video_on, pixel_tick;
   wire text_on, graph_on;
   reg [2:0] rgb_reg;
   reg [2:0] rgb_next;
   wire [2:0] graph_rgb, text_rgb;
   
   // vga sync circuit provided
   vga_sync vsync_unit
      (.clk(iCLK_50), .reset(reset), .oHS(oHS), .oVS(oVS),
       .visible(video_on), .p_tick(pixel_tick),
       .pixel_x(pixel_x), .pixel_y(pixel_y));
   controll_text text_unit
      (.clk(iCLK_50),
       .pix_x(pixel_x), .pix_y(pixel_y),
       .text_on(text_on), .text_rgb(text_rgb));
   //implementing on this module
   tetris_controll game_unit
      (.clk(iCLK_50), .reset(reset), .btn(iBTN),
       .pix_x(pixel_x),.pix_y(pixel_y),
	   .graph_on(graph_on),.graph_rgb(graph_rgb));
  
   // rgb buffer
   always @(posedge iCLK_50) begin
      if (pixel_tick)
         rgb_reg <= rgb_next;
	  else
		 rgb_reg <= rgb_reg;
	end
	always @*
      if (~video_on)
         rgb_next = 3'b000; 
      else
         if (text_on)
            rgb_next = text_rgb;
         else if (graph_on)  // display graph
           rgb_next = graph_rgb;
         else
           rgb_next = 3'b111; // background
   // output
   assign {oVGA_R, oVGA_G, oVGA_B} = rgb_reg;

endmodule
