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
//   File Name   : controll_text.v
//   Module Name : controll_text
//   Release version : v1.0 (Release Date: May-2012)
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//############################################################################
module controll_text
   (
    input wire clk, 
    input wire [9:0] pix_x, pix_y,
    output wire  text_on,
    output reg [2:0] text_rgb
   );

   // signal declaration
   wire [10:0] rom_addr;
   reg [6:0] char_addr, char_addr_s;
   reg [3:0] row_addr;
   wire [3:0] row_addr_s;
   reg [2:0] bit_addr;
   wire [2:0] bit_addr_s;
   wire [7:0] font_word;
   wire font_bit, score_on;

   // instantiate font ROM
   font_rom font_unit
      (.clk(clk), .addr(rom_addr), .data(font_word));
   assign score_on = (pix_y[9:5]==0) && (pix_x[9:4]<16);
   assign row_addr_s = pix_y[4:1];
   assign bit_addr_s = pix_x[3:1];
   always @*
      case (pix_x[7:4])
         4'h0: char_addr_s = 7'h50; // P
         4'h1: char_addr_s = 7'h49; // I
         4'h2: char_addr_s = 7'h4e; // N
         4'h3: char_addr_s = 7'h47; // G
         4'h4: char_addr_s = 7'h00; // 
         4'h5: char_addr_s = 7'h00; // 
          4'h6: char_addr_s = 7'h00;
          4'h7: char_addr_s = 7'h00; 
          4'h8: char_addr_s = 7'h50; //P
          4'h9: char_addr_s = 7'h4f; //O
          4'ha: char_addr_s = 7'h4e; // N
          4'hb: char_addr_s = 7'h47; // G
          4'hc: char_addr_s = 7'h00; // 
          4'hd: char_addr_s = 7'h00; // 
          4'he: char_addr_s = 7'h00; // 
          4'hf: char_addr_s = 7'h00;
      endcase
 
   //-------------------------------------------
   // mux for font ROM addresses and rgb
   //-------------------------------------------
   always @*
   begin
      text_rgb = 3'b111;  // background
      if (score_on)
         begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if (font_bit)
               text_rgb = 3'b000;
         end
      else 
         begin
            char_addr = 0;
            row_addr = 0;
            bit_addr =0;
            if (font_bit)
               text_rgb = 3'b000;
         end
   end

   assign text_on = {score_on};
   //-------------------------------------------
   // font rom interface
   //-------------------------------------------
   assign rom_addr = {char_addr, row_addr};
   assign font_bit = font_word[~bit_addr];

endmodule
