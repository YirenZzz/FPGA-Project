/*module displayboard(clk, board_top_plot, start_page, over_page, color, x,y, writeEn);
 input clk, board_top_plot,start_page, over_page;
 
 output reg [5:0]color;
 output reg [9:0]x;
 output reg [8:0]y;
 output reg writeEn;
 
 reg [9:0] x0bt, x0bb,x0st, x0sb, x0wt, x0wb;
 reg [8:0] y0bt, y0bb,y0st, y0sb, y0wt, y0wb;
 
//draw gameboard
 wire [9:0]xbtCount, xbbCount;
 wire [8:0]ybtCount,ybbCount;
 wire [15:0]btaddress, bbaddress;
 wire [5:0]btcolor, bbcolor;
 wire done1,done2;
 btop ggg(btaddress, clk, btcolor);
 bbot gg(bbaddress, clk, bbcolor);
 draw_board b1(clk, board_top_plot, xbtCount, ybtCount, btaddress, done1);
 draw_board b2(clk, done1, xbbCount, ybbCount, bbaddress, done2);
 
 //draw startpage
 wire [9:0]xstCount, xsbCount;
 wire [8:0]ystCount,ysbCount;
 wire [15:0]staddress, sbaddress;
 wire [5:0]stcolor, sbcolor;
 wire done3,done4;
 starttop st(staddress, clk, stcolor);
 startbot sb(sbaddress, clk, sbcolor);
 draw_board s1(clk, start_page, xstCount, ystCount, staddress, done3);//enable1?
 draw_board s2(clk, done3, xsbCount, ysbCount, sbaddress, done4);
 
 //draw winpage
 wire [9:0]xwtCount, xwbCount;
 wire [8:0]ywtCount,ywbCount;
 wire [15:0]wtaddress, wbaddress;
 wire [5:0]wtcolor, wbcolor;
 wire done5,done6;
 wintop stttt(wtaddress, clk, wtcolor);
 winbot sbbbb(wbaddress, clk, wbcolor);
 draw_board w1(clk, over_page, wstCount, wstCount, wtaddress, done5);//enable2?
 draw_board w2(clk, done5, wsbCount, wsbCount, wbaddress, done6);
 
 
//buggggggg here no initial
 initial begin
   //gameboard
 	x0bt<=0;
 	y0bt<=0;
 	x0bb<=0;
 	y0bb<=9'd120;
	
	//startpage
	x0st<=0;
 	y0st<=0;
 	x0sb<=0;
 	y0sb<=9'd120;
	
	//winpage
	x0wt<=0;
 	y0wt<=0;
 	x0wb<=0;
 	y0wb<=9'd120;
	
 end

 always @ (posedge clk) begin
 //startpage
 if (start_page) begin
   if(!done3) begin
   x <= xstCount+x0st;
   y <= ystCount+y0st;
   color <= sbcolor;
   writeEn <= 1'b1;
   end
   else begin
   x <= xsbCount+x0sb;
   y <= ysbCount+y0sb;
   color <= sbcolor;
   writeEn <= 1'b1;
   end
end

//gameboard
 if (board_top_plot) begin
  if(!done1) begin
   x <= xbtCount+x0bt;
   y <= ybtCount+y0bt;
   color <= btcolor;
   writeEn <= 1'b1;
  
  end
  else begin
   x <= xbbCount+x0bb;
   y <= ybbCount+y0bb;
   color <= bbcolor;
   writeEn <= 1'b1;
  end
 end
 
 //winpage
 if (over_page) begin
  if(!done5) begin
   x <= xwtCount+x0wt;
   y <= ywtCount+y0wt;
   color <= wtcolor;
   writeEn <= 1'b1;
  
  end
  else begin
   x <= xwbCount+x0wb;
   y <= ywbCount+y0wb;
   color <= wbcolor;
   writeEn <= 1'b1;
  end
 end

 else
  writeEn <= 1'b0;
 end
endmodule
*/

/*

module display_num(clk,input_num,board_top_plot, start_page, over_page, cursor_x, cursor_y,cursor_xold,cursor_yold, data_write,num_delete,earse,wrong,color, x,y, writeEn);
 input clk,wrong;
  input board_top_plot,start_page, over_page;
 input data_write;
 input num_delete;
 input earse;
 input [3:0]input_num;
 
 input [9:0] cursor_x;
 input [8:0] cursor_y;
 input [9:0] cursor_xold;
 input [8:0] cursor_yold;
 
 output reg [5:0]color;
 output reg [9:0]x;
 output reg [8:0]y;

 output reg writeEn;

 reg [9:0] x0bt, x0bb,x0st, x0sb, x0wt, x0wb;
 reg [8:0] y0bt, y0bb,y0st, y0sb, y0wt, y0wb;
 
//draw gameboard
 wire [9:0]xbtCount, xbbCount;
 wire [8:0]ybtCount,ybbCount;
 wire [15:0]btaddress, bbaddress;
 wire [5:0]btcolor, bbcolor;
 wire done1,done2;
 btop ggg(btaddress, clk, btcolor);
 bbot gg(bbaddress, clk, bbcolor);
 draw_board b1(clk, board_top_plot, xbtCount, ybtCount, btaddress, done1);
 draw_board b2(clk, done1, xbbCount, ybbCount, bbaddress, done2);
 
 //draw startpage
 wire [9:0]xstCount, xsbCount;
 wire [8:0]ystCount,ysbCount;
 wire [15:0]staddress, sbaddress;
 wire [5:0]stcolor, sbcolor;
 wire done3,done4;
 starttop st(staddress, clk, stcolor);
 startbot sb(sbaddress, clk, sbcolor);
 draw_board s1(clk, start_page, xstCount, ystCount, staddress, done3);//enable1?
 draw_board s2(clk, done3, xsbCount, ysbCount, sbaddress, done4);
 
 //draw winpage
 wire [9:0]xwtCount, xwbCount;
 wire [8:0]ywtCount,ywbCount;
 wire [15:0]wtaddress, wbaddress;
 wire [5:0]wtcolor, wbcolor;
 wire done5,done6;
 wintop stttt(wtaddress, clk, wtcolor);
 winbot sbbbb(wbaddress, clk, wbcolor);
 draw_board w1(clk, over_page, wstCount, wstCount, wtaddress, done5);//enable2?
 draw_board w2(clk, done5, wsbCount, wsbCount, wbaddress, done6);
 
 
//buggggggg here no initial
 initial begin
   //gameboard
 	x0bt<=0;
 	y0bt<=0;
 	x0bb<=0;
 	y0bb<=9'd120;
	
	//startpage
	x0st<=0;
 	y0st<=0;
 	x0sb<=0;
 	y0sb<=9'd120;
	
	//winpage
	x0wt<=0;
 	y0wt<=0;
 	x0wb<=0;
 	y0wb<=9'd120;
	
 end

 
 
 
 
 
 
 
 
 reg [9:0]num_x;
 reg [8:0]num_y;

 
 wire [4:0] xCount1,xCount2,xCount3,xCount4,xCount5,xCount6,xCount7,xCount8,xCount9,xCount0;
 wire [4:0] yCount1,yCount2,yCount3,yCount4,yCount5,yCount6,yCount7,yCount8,yCount9,yCount0;
 wire [4:0] xCounti1,xCounti2,xCounti3,xCounti4,xCounti5,xCounti6,xCounti7,xCounti8,xCounti9;
 wire [4:0] yCounti1,yCounti2,yCounti3,yCounti4,yCounti5,yCounti6,yCounti7,yCounti8,yCounti9;
 wire [4:0] xCountc1,xCountc2,xCountc3,xCountc4,xCountc5,xCountc6,xCountc7,xCountc8,xCountc9,xCountc0;
 wire [4:0] yCountc1,yCountc2,yCountc3,yCountc4,yCountc5,yCountc6,yCountc7,yCountc8,yCountc9,yCountc0;
 wire [8:0]  address1,address2,address3,address4,address5,address6,address7,address8,address9,address0;
 wire [8:0]  addressi1,addressi2,addressi3,addressi4,addressi5,addressi6,addressi7,addressi8,addressi9;
 wire [8:0]  addressc1,addressc2,addressc3,addressc4,addressc5,addressc6,addressc7,addressc8,addressc9,addressc0;
 wire [5:0] color1,color2,color3,color4,color5,color6,color7,color8,color9,color0;
 wire [5:0] colori1,colori2,colori3,colori4,colori5,colori6,colori7,colori8,colori9;
 wire [5:0] curr1_color,curr2_color,curr3_color,curr4_color,curr5_color,curr6_color,curr7_color,curr8_color,curr9_color;
 wire [9:0] done,donei,donec;
 
 initial begin
	num_x <= cursor_x+1;
	num_y <= cursor_y+1;
 end 
 
 num1 n1(address1, clk, color1);
 num2 n2(address2, clk, color2);
 num3 n3(address3, clk, color3);
 num4 n4(address4, clk, color4);
 num5 n5(address5, clk, color5);
 num6 n6(address6, clk, color6);
 num7 n7(address7, clk, color7);
 num8 n8(address8, clk, color8);
 num9 n9(address9, clk, color9);
 blk n0(address0, clk, color0);//blank box
 
 drawNum n1d(clk, data_write, xCount1, yCount1, address1, done[0]);
 drawNum n2d(clk, data_write, xCount2, yCount2, address2, done[1]);
 drawNum n3d(clk, data_write, xCount3, yCount3, address3, done[2]);
 drawNum n4d(clk, data_write, xCount4, yCount4, address4, done[3]);
 drawNum n5d(clk, data_write, xCount5, yCount5, address5, done[4]);
 drawNum n6d(clk, data_write, xCount6, yCount6, address6, done[5]);
 drawNum n7d(clk, data_write, xCount7, yCount7, address7, done[6]);
 drawNum n8d(clk, data_write, xCount8, yCount8, address8, done[7]);
 drawNum n9d(clk, data_write, xCount9, yCount9, address9, done[8]);
 drawNum n0d(clk, data_write, xCount0, yCount0, address0, done[9]);
 
 incorrect1 ni1(addressi1, clk, colori1);
 incorrect2 ni2(addressi2, clk, colori2);
 incorrect3 ni3(addressi3, clk, colori3);
 incorrect4 ni4(addressi4, clk, colori4);
 incorrect5 ni5(addressi5, clk, colori5);
 incorrect6 ni6(addressi6, clk, colori6);
 incorrect7 ni7(addressi7, clk, colori7);
 incorrect8 ni8(addressi8, clk, colori8);
 incorrect9 ni9(addressi9, clk, colori9);
 
 drawNum n1w(clk, wrong, xCounti1, yCounti1, addressi1, donei[0]);
 drawNum n2w(clk, wrong, xCounti2, yCounti2, addressi2, donei[1]);
 drawNum n3w(clk, wrong, xCounti3, yCounti3, addressi3, donei[2]);
 drawNum n4w(clk, wrong, xCounti4, yCounti4, addressi4, donei[3]);
 drawNum n5w(clk, wrong, xCounti5, yCounti5, addressi5, donei[4]);
 drawNum n6w(clk, wrong, xCounti6, yCounti6, addressi6, donei[5]);
 drawNum n7w(clk, wrong, xCounti7, yCounti7, addressi7, donei[6]);
 drawNum n8w(clk, wrong, xCounti8, yCounti8, addressi8, donei[7]);
 drawNum n9w(clk, wrong, xCounti9, yCounti9, addressi9, donei[8]);
 
 wire [4:0] xCounth1,xCounth2;
 wire [1:0] yCounth1,yCounth2;
 wire [1:0] xCountv1,xCountv2;
 wire [4:0] yCountv1,yCountv2;
 wire [5:0] colorh1,colorh2,colorv1,colorv2;
 wire [4:0] addressh1,addressh2,addressv1,addressv2;
 wire doneh1,doneh2,donev1,donev2;
 row17 h17(addressh1, clk, colorh1);
 row17 h171(addressh2, clk, colorh2);
 col19 c19(addressv1, clk, colorv1);
 col19 c191(addressv2, clk, colorv2);
 
 draw_gridh h1(clk, cursor, xCounth1, yCounth1, addressh1, doneh1); 
 draw_gridh h2(clk, doneh1, xCounth2, yCounth2, addressh2, doneh2); 
 draw_gridv v1(clk, doneh2, xCountv1, yCountv1, addressv1, donev1); 
 draw_gridv v2(clk, donev1, xCountv2, yCountv2, addressv2, donev2); 
 
 
 
 
 
 always@(posedge clk) begin
	//startpage
	if (start_page) begin
		if(!done3) begin
		x <= xstCount+x0st;
		y <= ystCount+y0st;
		color <= sbcolor;
		writeEn <= 1'b1;
		end
	else begin
		x <= xsbCount+x0sb;
		y <= ysbCount+y0sb;
		color <= sbcolor;
		writeEn <= 1'b1;
		end
	end
	else 
		writeEn <= 1'b0; 
//gameboard
 if (board_top_plot) begin
  if(!done1) begin
   x <= xbtCount+x0bt;
   y <= ybtCount+y0bt;
   color <= btcolor;
   writeEn <= 1'b1;
  
  end
  else begin
   x <= xbbCount+x0bb;
   y <= ybbCount+y0bb;
   color <= bbcolor;
   writeEn <= 1'b1;
  end
 end
 else 
    writeEn <= 1'b0; 
	
 //winpage
 if (over_page) begin
  if(!done5) begin
   x <= xwtCount+x0wt;
   y <= ywtCount+y0wt;
   color <= wtcolor;
   writeEn <= 1'b1;
  
  end
  else begin
   x <= xwbCount+x0wb;
   y <= ywbCount+y0wb;
   color <= wbcolor;
   writeEn <= 1'b1;
  end
 end
 else 
		writeEn <= 1'b0; 

	if (cursor) begin
		writeEn <= 1'b1;
		if (!doneh1)begin
			x <= xCounth1+cursor_x;//horizontal 1
			y <= yCounth1+cursor_y;
			color <= colorh1;
			end
		else if(doneh1)  begin
			x <= xCounth2+cursor_x;//horizontal 2
			y <= yCounth2+cursor_y;
			color <= colorh2;
			end
		else if(doneh2)  begin
			x <= xCountv1+cursor_x;//veritcal 1
			y <= yCountv1+cursor_y;
			color <= colorv1;
			end
		else if(donev1)  begin
			x <= xCountv2+cursor_x;//veritcal 1
			y <= yCountv2+cursor_y;
			color <= colorv2;
			end
	else 
		writeEn <= 1'b0; 
	end
	
	if (earse) begin
		writeEn <= 1'b1;
		if (!doneh1)begin
			x <= xCounth1+cursor_x;//horizontal 1
			y <= yCounth1+cursor_y;
			color <= color0;
			end
		else if(doneh1)  begin
			x <= xCounth2+cursor_x;//horizontal 2
			y <= yCounth2+cursor_y;
			color <= color0;
			end
		else if(doneh2)  begin
			x <= xCountv1+cursor_x;//veritcal 1
			y <= yCountv1+cursor_y;
			color <= color0;
			end
		else if(donev1)  begin
			x <= xCountv2+cursor_x;//veritcal 1
			y <= yCountv2+cursor_y;
			color <= color0;
			end
	else 
				writeEn <= 1'b0; 
	end
	
	if (data_write) begin
		writeEn <= 1'b1; 
			
		  if(input_num==4'd1)begin
				x<=xCount1 + num_x;
				y<=yCount1 + num_y;
					if (wrong)begin
						if (num_delete)
							color <= color0;
						else 
							color <= colori1;
						end
					else
						color <= color1;
				end
			else if(input_num==4'd2)begin
					x<=xCount2 + num_x;
				   y<=yCount2 + num_y;
				   	if (wrong)begin
						   if (num_delete)
						   	color <= 6'b111111;
						   else 
						   	color <= colori2;
						end
					else
						color <= color2;
					end
			   else if(input_num==4'd3)begin
					x<=xCount3 + num_x;
				   y<=yCount3 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori3;
					   	end
				   	else
					   	color <= color3;
					   end
		  	   else if(input_num==4'd4)begin
					x<=xCount4 + num_x;
				   y<=yCount4 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori5;
					   	end
					else
						color <= color4;
					end
			   else if(input_num==4'd5)begin
					x<=xCount5 + num_x;
				   y<=yCount5 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori5;
					   	end
					else
						color <= color5;
					end
			   else if(input_num==4'd6)begin
					x<=xCount6 + num_x;
				   y<=yCount6 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori6;
					   	end
					else
						color <= color6;
					end
			   else if(input_num==4'd7)begin
					x<=xCount7 + num_x;
				   y<=yCount7 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori7;
					   	end
					else
						color <= color7;
					end
			   else if(input_num==4'd8)begin
					x<=xCount8 + num_x;
				   y<=yCount8 + num_y;
				   	if (wrong)begin
						   if (num_delete)
							   color <= 6'b111111;
					   	else 
						   	color <= colori8;
					   	end
					else
						color <= color8;
					end
			   else if(input_num==4'd9)begin
				   x<=xCount9 + num_x;
				   y<=yCount9 + num_y;
				   if (wrong) begin
						if (num_delete)
							color <= 6'b111111;
						else 
							color <= colori9;
						end
					else
						color <= color9;
					end
		else 
		 writeEn <= 1'b0; 
			end
			
	end
 endmodule
*/
		
 /*
 
 
 
 
 always@(posedge clk)
	if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b0 )begin 
		x <= xCountc0+cursor_x;
      y <= yCountc0+cursor_y;
		color <= curr0_color;
			if (data_write) begin
				writeEn <= 1'b1; 
			   if(input_num=4'd1)begin
					if (wrong)
						color <= colori1;
					else
						color <= color1;
					end
			   else if(input_num=4'd2)begin
					if (wrong)
						color <= colori2;
					else
						color <= color2;
					end
			   else if(input_num=4'd3)begin
					if (wrong)
						color <= colori3;
					else
						color <= color3;
					end
		  	   else if(input_num=4'd4)begin
					if (wrong)
						color <= colori4;
					else
						color <= color4;
					end
			   else if(input_num=4'd5)begin
					if (wrong)
						color <= colori5;
					else
						color <= color5;
					end
			   else if(input_num=4'd6)begin
					if (wrong)
						color <= colori6;
					else
						color <= color6;
					end
			   else if(input_num=4'd7)begin
					if (wrong)
						color <= colori7;
					else
						color <= color7;
					end
			   else if(input_num=4'd8)begin
					if (wrong)
						color <= colori8;
					else
						color <= color8;
					end
			   else if(input_num=4'd9)begin
				   if (wrong)
						color <= colori9;
					else
						color <= color9;
					end
				end
			else 
				writeEn <= 1'b0; 
		end
		if(erease) begin//?
		   x <= xCountc0+cursor_x;
         y <= yCountc0+cursor_y;
	      color <= curr0_color;
			writeEn <= 1'b1;
			end
		else
		writeEn <= 1'b0; 
	end
   else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b1)begin 
		x <= xCountc1+cursor_x;
      y <= yCountc1+cursor_y;
		color <= curr1_color; 
		end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b1 && board_occu[cursor_ij]==1'b0)begin 
		x <= xCountc2+cursor_x;
      y <= yCountc2+cursor_y;
		color <= curr2_color;
		end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b1 && board_occu[cursor_ij]==1'b1)begin 
		x <= xCountc3+cursor_x;
      y <= yCountc3+cursor_y;
		color <= curr3_color;
		end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b1 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b0)begin 
		x <= xCountc4+cursor_x;
      y <= yCountc4+cursor_y;
		color <= curr4_color;
	   end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b1 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b1)begin 
		x <= xCountc5+cursor_x;
      y <= yCountc5+cursor_y;
		color <= curr5_color;
		end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b1 && board_occu[cursor_ij+9'd1]==1'b1 && board_occu[cursor_ij]==1'b0)begin 
		x <= xCountc6+cursor_x;
      y <= yCountc6+cursor_y;
		color <= curr6_color;
		end
	else if (board_occu[cursor_ij+9'd3]==1'b0 && board_occu[cursor_ij+9'd2]==1'b1 && board_occu[cursor_ij+9'd1]==1'b1 && board_occu[cursor_ij]==1'b1)begin 
		x <= xCountc7+cursor_x;
      y <= yCountc7+cursor_y;
		color <= curr7_color;
		end
	else if (board_occu[cursor_ij+9'd3]==1'b1 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b0)begin 
		x <= xCountc8+cursor_x;
      y <= yCountc8+cursor_y;
		color <= curr8_color;
	   end
	else if (board_occu[cursor_ij+9'd3]==1'b1 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b1)begin 
		x <= xCountc9+cursor_x;
      y <= yCountc9+cursor_y;
		color <= curr9_color;
		end
	
	else if(key_up)begin
		cursor_oldx <= cursor_x - ???;
	   cursor_oldy <= cursor_y - ??? ;
		if (board_occu[cursor_ij+9'd3]==1'b1 && board_occu[cursor_ij+9'd2]==1'b0 && board_occu[cursor_ij+9'd1]==1'b0 && board_occu[cursor_ij]==1'b0)begin 
		   x <= xCountc1+cursor_oldx;
         y <= yCountc1+cursor_oldy;
		   color <= curr1_color;
	      end
		end
	end	
	else if(key_down)
	else if(key_left)
	else if(key_right)
   else
      writeEn <= 1'b0;
end

*/
	
//endmodule	 
		 
 /*
 curr1 cr1(addressc1,clk,curr1_color);
 curr2 cr2(addressc2,clk,curr2_color);
 curr3 cr3(addressc3,clk,curr3_color);
 curr4 cr4(addressc4,clk,curr4_color);
 curr5 cr5(addressc5,clk,curr5_color);
 curr6 cr6(addressc6,clk,curr6_color);
 curr7 cr7(addressc7,clk,curr7_color);
 curr8 cr8(addressc8,clk,curr8_color);
 curr9 cr9(addressc9,clk,curr9_color);
 currblk cr0(addressc0,clk,curr0_color);
 
 drawNum n1c(clk, data_write, xCountc1, yCountc1, addressc1, donec[0]);
 drawNum n2c(clk, data_write, xCountc2, yCountc2, addressc2, donec[1]);
 drawNum n3c(clk, data_write, xCountc3, yCountc3, addressc3, donec[2]);
 drawNum n4c(clk, data_write, xCountc4, yCountc4, addressc4, donec[3]);
 drawNum n5c(clk, data_write, xCountc5, yCountc5, addressc5, donec[4]);
 drawNum n6c(clk, data_write, xCountc6, yCountc6, addressc6, donec[5)];
 drawNum n7c(clk, data_write, xCountc7, yCountc7, addressc7, donec[6]);
 drawNum n8c(clk, data_write, xCountc8, yCountc8, addressc8, donec[7]);
 drawNum n9c(clk, data_write, xCountc9, yCountc9, addressc9, donec[8]);
 drawNum n0c(clk, data_write, xCountc0, yCountc0, addressc0, donec[9]);
 */
		 
		 
	/*	 
	4'd2:begin
	     if (data_write) begin
            x <= xCount3+cursor_x;
            y <= yCount3+cursor_y;
            color <= color3;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti3+cursor_x;
            y <= yCounti3+cursor_y;
            color <= colori3;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd3:begin
	     if (data_write) begin
            x <= xCount4+cursor_x;
            y <= yCount4+cursor_y;
            color <= color4;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti4+cursor_x;
            y <= yCounti4+cursor_y;
            color <= colori4;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd4:begin
	     if (enable) begin
            x <= xCount5+cursor_x;
            y <= yCount5+cursor_y;
            color <= color5;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti5+cursor_x;
            y <= yCounti5+cursor_y;
            color <= colori5;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd5:begin
	     if (enable) begin
            x <= xCount6+cursor_x;
            y <= yCount6+cursor_y;
            color <= color6;
            writeEn <= 1'b1; 
	     end
		 
		 else if(wrong) begin
		    x <= xCounti6+cursor_x;
            y <= yCounti6+cursor_y;
            color <= colori6;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd6:begin
	     if (data_write) begin
            x <= xCount7+cursor_x;
            y <= yCount7+cursor_y;
            color <= color7;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti7+cursor_x;
            y <= yCounti7+cursor_y;
            color <= colori7;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd7:begin
	     if (data_write) begin
            x <= xCount8+cursor_x;
            y <= yCount8+cursor_y;
            color <= color8;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti8+cursor_x;
            y <= yCounti8+cursor_y;
            color <= colori8;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	4'd8:begin
	     if (data_write) begin
            x <= xCount9+cursor_x;
            y <= yCount9+cursor_y;
            color <= color9;
            writeEn <= 1'b1; 
	     end
		 else if(wrong) begin
		    x <= xCounti9+cursor_x;
            y <= yCounti9+cursor_y;
            color <= colori9;
            writeEn <= 1'b1; 
		end
		 else
            writeEn <= 1'b0;
         end
	endcase
end
//8

 

*/



