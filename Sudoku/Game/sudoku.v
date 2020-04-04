module finaltest(CLOCK_50, SW,KEY, PS2_CLK, PS2_DAT, 
		VGA_HS,VGA_VS, VGA_BLANK_N,VGA_SYNC_N, VGA_R,VGA_G,VGA_B,VGA_CLK);

	input CLOCK_50;
	input [9:0]SW;
	input [3:0]KEY;
	
	inout PS2_CLK;
	inout PS2_DAT;
	
	
	output VGA_HS;
	output VGA_VS;
	output VGA_BLANK_N;				//	VGA BLANK
	output VGA_SYNC_N;				//	VGA SYNC	
	output [7:0] VGA_R;                // VGA red component
   output [7:0] VGA_G;               // VGA green component
  	output [7:0] VGA_B; 
	output VGA_CLK;
	
	wire resetn;
	assign resetn=SW[0];
	
	wire key_up; 
	wire key_down;
	wire key_left;
	wire key_right;

	wire key_space;
	//assign key_space=SW[8];
	wire key_delete;

	wire key_num1;
	wire key_num2;
	wire key_num3;
	wire key_num4;
	wire key_num5;
	wire key_num6;
	wire key_num7;
	wire key_num8;
	wire key_num9;
	wire [323:0] board_occu;
	wire isCorrect;
	
	
	keyboard happer(CLOCK_50, PS2_CLK, PS2_DAT, resetn, key_up, key_down, 
				key_left, key_right,key_space, key_delete,key_num1, key_num2, key_num3, key_num4,
				key_num5, key_num6, key_num7, key_num8, key_num9);
	
	
	reg [3:0] cursor_i;
	reg [3:0] cursor_j; 
	reg [8:0] cursor_ij;
	reg [9:0] cursor_x;
	reg [8:0] cursor_y;
	reg [9:0] cursor_xold;
	reg [8:0] cursor_yold;
	reg erase;
	reg isEmpty;
	reg gameover;
	reg [7:0]put_count;
	
	
	reg [3:0]input_num;
	reg writeEn;
	reg [9:0] x;
	reg [8:0] y;
	reg [5:0]color;
	wire clkout;
	frameCounter co(CLOCK_50,clkout);
	
	/*
	vga_adapter VGA(
		.resetn(resetn),
		.clock(CLOCK_50),
		.colour(color),
		.x(x),
		.y(y),
		.plot(writeEn),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B),
		.VGA_HS(VGA_HS),
		.VGA_VS(VGA_VS),
		.VGA_BLANK(VGA_BLANK_N),
		.VGA_SYNC(VGA_SYNC_N),
		.VGA_CLK(VGA_CLK));
	defparam VGA.RESOLUTION = "320x240";
	defparam VGA.MONOCHROME = "FALSE";
	defparam VGA.BITS_PER_COLOUR_CHANNEL = 2;
	defparam VGA.BACKGROUND_IMAGE ="test.mif";
	*/
	
	//reg [9:0] x0bt, x0bb,x0st, x0sb, x0wt, x0wb;
	//reg [8:0] y0bt, y0bb,y0st, y0sb, y0wt, y0wb;
 
	//draw gameboard
	wire [9:0]board_top_x, board_bot_x;
	wire [8:0]board_top_y,board_bot_y;
	wire [15:0]bTopaddress, bBotaddress;
	wire [5:0]colourboardtop, colourboardbot;
	wire boardTopDone, boardBotDone;
	reg boardTopEn,boardBotEn;
	
	//roms for board
	btop topback(bTopaddress, CLOCK_50, colourboardtop);
	bbot botback(bBotaddress, CLOCK_50, colourboardbot);
	
	//draw board(t/b)
	draw_board b1(CLOCK_50, boardTopEn, board_top_x, board_top_y, bTopaddress, boardTopDone);
	draw_board b2(CLOCK_50, boardBotEn, board_bot_x, board_bot_y, bBotaddress, boardBotDone);
	
	
	//0000000000000000000000000000000000
	//draw startpage
	wire [9:0]start_top_x, start_bot_x;
	wire [8:0]start_top_y,start_bot_y;
	wire [15:0]staddress, sbaddress;
	wire [5:0]start_top_color,start_bot_color;
	wire startTopDone, startBotDone;
	reg startTopEn,startBotEn;
	
	//roms for start page
	starttop st(staddress, CLOCK_50, start_top_color);
	startbot sb(sbaddress, CLOCK_50, start_bot_color);
	
	//draw start page(t/b)
	draw_board s1(CLOCK_50, startTopEn, start_top_x, start_top_y, staddress, startTopDone);//enable1?
	draw_board s2(CLOCK_50, startBotEn, start_bot_x, start_bot_y, sbaddress, startBotDone);
	//0000000000000000000000000000000000000
	
	
	//--------------------draw winpage--------------------
	wire [9:0]x_gameover1, x_gameover2;
	wire [8:0]y_gameover1, y_gameover2;
	wire [15:0]wtaddress, wbaddress;
	wire [5:0]colourgameover1, colourgameover2;
	wire gameover_top_done,gameover_bot_done;
	reg gameover1En, gameover2En;
	
	//rom
	wintop stttt(wtaddress, CLOCK_50, colourgameover1);
	winbot sbbbb(wbaddress, CLOCK_50, colourgameover2);
	
	//draw
	draw_board w1(CLOCK_50, gameover1En, x_gameover1, y_gameover1, wtaddress, gameover_top_done);
	draw_board w2(CLOCK_50, gameover2En, x_gameover2, y_gameover2, wbaddress, gameover_bot_done);
	

	//------------draw cursor--------------------
	wire [4:0] xCounth1,xCounth2;
	wire [1:0] yCounth1,yCounth2;
	wire [1:0] xCountv1,xCountv2;
	wire [4:0] yCountv1,yCountv2;
	wire [4:0] addressh1,addressh2,addressv1,addressv2;
	wire [5:0] colourcursorh1,colourcursorv1,colourcursorh2,colourcursorv2;
	wire cursorH1Done,cursorV1Done,cursorH2Done,cursorV2Done;
	reg cursorH1En, cursorV1En, cursorH2En,cursorV2En;
	
	//rom
	row17 h17(addressh1, CLOCK_50, colourcursorh1);
	row17 h171(addressh2, CLOCK_50, colourcursorh2);
	col19 c19(addressv1, CLOCK_50, colourcursorv1);
	col19 c191(addressv2, CLOCK_50, colourcursorv2);
	
	//draw
	draw_gridhor h1(CLOCK_50, cursorH1En, xCounth1, yCounth1, addressh1, cursorH1Done); 
	draw_gridhor h2(CLOCK_50, cursorH2En, xCounth2, yCounth2, addressh2, cursorH2Done); 
	draw_gridver v1(CLOCK_50, cursorV1En, xCountv1, yCountv1, addressv1, cursorV1Done); 
	draw_gridver v2(CLOCK_50, cursorV2En, xCountv2, yCountv2, addressv2, cursorV2Done); 
	
	
	
	
	
	//------------draw erase cursor--------------------
	wire [4:0] x_erase_Counth1,x_erase_Counth2;
	wire [1:0] y_erase_Counth1,y_erase_Counth2;
	wire [1:0] x_erase_Countv1,x_erase_Countv2;
	wire [4:0] y_erase_Countv1,y_erase_Countv2;
	wire [5:0] colour_erase_cursorh1,colour_erase_cursorv1,colour_erase_cursorh2,colour_erase_cursorv2;
	wire [4:0] address_erase_h1,address_erase_h2,address_erase_v1,address_erase_v2;
	wire cursor_erase_H1Done,cursor_erase_V1Done,cursor_erase_H2Done,cursor_erase_V2Done;
	reg cursor_erase_H1En, cursor_erase_V1En, cursor_erase_H2En,cursor_erase_V2En;
	
	//rom
	//row17 h17(address_erase_h1, CLOCK_50, colour_erase_cursorh1);
	//row17 h171(address_erase_h2, CLOCK_50, colour_erase_cursorv1);
	//col19 c19(address_erase_v1, CLOCK_50, colour_erase_cursorh2);
	//col19 c191(address_erase_v2, CLOCK_50, colour_erase_cursorv2);
	
	//draw
	draw_gridhor _erase_h1(CLOCK_50, cursor_erase_H1En, x_erase_Counth1, y_erase_Counth1, address_erase_h1, cursor_erase_H1Done); 
	draw_gridhor _erase_h2(CLOCK_50, cursor_erase_H2En, x_erase_Counth2, y_erase_Counth2, address_erase_h2, cursor_erase_H2Done); 
	draw_gridver _erase_v1(CLOCK_50, cursor_erase_V1En, x_erase_Countv1, y_erase_Countv1, address_erase_v1, cursor_erase_V1Done); 
	draw_gridver _erase_v2(CLOCK_50, cursor_erase_V2En, x_erase_Countv2, y_erase_Countv2, address_erase_v2, cursor_erase_V2Done); 
	
	
	//------------draw normal num 1-9--------------------
	wire [8:0] num_address;
	wire [5:0] num1_color,num2_color,num3_color;
	wire [5:0] num4_color,num5_color,num6_color;
	wire [5:0] num7_color,num8_color,num9_color;
	wire [4:0] xCountNum, yCountNum;
	wire numDone;
	reg numEn;
	
	//rom
	num1 n1(num_address, CLOCK_50, num1_color);
	num2 n2(num_address, CLOCK_50, num2_color);
	num3 n3(num_address, CLOCK_50, num3_color);
	num4 n4(num_address, CLOCK_50, num4_color);
	num5 n5(num_address, CLOCK_50, num5_color);
	num6 n6(num_address, CLOCK_50, num6_color);
	num7 n7(num_address, CLOCK_50, num7_color);
	num8 n8(num_address, CLOCK_50, num8_color);
	num9 n9(num_address, CLOCK_50, num9_color);
	
	//draw
	drawNum numd(CLOCK_50, numEn, xCountNum, yCountNum, num_address, numDone);
	
	
	//------------draw incorrect red num 1-9--------------------
	wire [8:0] num_address_incorrect;
	wire [5:0] num1_color_incorrect, num2_color_incorrect, num3_color_incorrect;
	wire [5:0] num4_color_incorrect, num5_color_incorrect, num6_color_incorrect;
	wire [5:0] num7_color_incorrect, num8_color_incorrect, num9_color_incorrect;
	
	wire [4:0] xCountNum_incorrect, yCountNum_incorrect;
	wire inCorrectNumDone;
	reg inCorrect;
	
	//rom
	incorrect1 wrong1(num_address_incorrect, CLOCK_50, num1_color_incorrect);
	incorrect2 wrong2(num_address_incorrect, CLOCK_50, num2_color_incorrect);
	incorrect3 wrong3(num_address_incorrect, CLOCK_50, num3_color_incorrect);
	incorrect4 wrong4(num_address_incorrect, CLOCK_50, num4_color_incorrect);
	incorrect5 wrong5(num_address_incorrect, CLOCK_50, num5_color_incorrect);
	incorrect6 wrong6(num_address_incorrect, CLOCK_50, num6_color_incorrect);
	incorrect7 wrong7(num_address_incorrect, CLOCK_50, num7_color_incorrect);
	incorrect8 wrong8(num_address_incorrect, CLOCK_50, num8_color_incorrect);
	incorrect9 wrong9(num_address_incorrect, CLOCK_50, num9_color_incorrect);
	
	//draw
	//drawNum numd(CLOCK_50, inCorrect, xCountNum_incorrect, yCountNum_incorrect, num_address_incorrect, inCorrectNumDone);
	
	
	reg [9:0]top_x0, bot_x0;
	reg [8:0]top_y0, bot_y0;
	
	initial begin
		top_x0<=0;
		top_y0<=0;
		bot_x0<=0;
		bot_y0<=9'd120;
		
		/*&x0_cursorh1=0;;
		y0_cursorh1=0;
		
		x0_cursorv1=0;
		y0_cursorv1=0;
		
		x0_cursorh2=0;
		y0_cursorh2=0;
		
		x0_cursorv2=0;
		y0_cursorv2=0;
		
		
		x0_cursor_erase_h1=0;
		y0_cursor_erase_h1=0;
		
		x0_cursor_erase_v1=0;
		y0_cursor_erase_v1=0;
		
		x0_cursor_erase_h2=0;
		y0_cursor_erase_h2=0;
		
		x0_cursor_erase_v2=0;
		y0_cursor_erase_v2=0;
		
		x0CountNum=10'd106;
		y0CountNum=9'd118;
		
		*/
		
	end
	
	reg [5:0] next_Draw, current_Draw;
	
	parameter RESET=5'd0,
	           DISPLAY_START_TOP=5'd1,
			     DISPLAY_START_BOT=5'd2,
			     S_BACKGROUND_BOT=5'd3,
			     DISPLAY_BOARD_TOP=5'd4,
			     DISPLAY_BOARD_BOT=5'd5,
			     DISPLAY_CURSOR_H1=5'd6,
			     DISPLAY_CURSOR_V1=5'd7,
			     DISPLAY_CURSOR_H2=5'd8,
			     DISPLAY_CURSOR_V2=5'd9,
			     ERASE_CURSOR_H1=5'd10,
			     ERASE_CURSOR_V1=5'd11,
			     ERASE_CURSOR_H2=5'd12,
			     ERASE_CURSOR_V2=5'd13,
			     DISPLAY_NUM=5'd14,
			     GAMEOVER_TOP=5'd15,
			     GAMEOVER_BOT=5'd16;
	
	
		
	always@(*)
	begin
	case(current_Draw)
		RESET:	begin
							next_Draw <=DISPLAY_START_TOP;
					end
		
		DISPLAY_START_TOP:begin
						 if (startTopEn) begin
							if (startTopDone) begin
								next_Draw <= DISPLAY_START_BOT;
							end
							else next_Draw <= DISPLAY_START_TOP;
							end
						end
		DISPLAY_START_BOT:	begin
						 if (startBotEn) begin
							if (startBotDone) begin
								if(key_space)
									next_Draw <= DISPLAY_BOARD_TOP;
							end
							else next_Draw <= DISPLAY_START_BOT;
							end
						end				
					
		DISPLAY_BOARD_TOP:	begin
						 if (boardTopEn) begin
							if (boardTopDone) begin
								next_Draw <= DISPLAY_BOARD_BOT;
							end
							else next_Draw <= DISPLAY_BOARD_TOP;
							end
						end
		DISPLAY_BOARD_BOT:	begin
						 if (boardBotEn) begin
							if (boardBotDone) begin
								next_Draw <= DISPLAY_CURSOR_H1;
							end
							else next_Draw <= DISPLAY_BOARD_BOT;
							end
						end				
						
		DISPLAY_CURSOR_H1: begin
						if (cursorH1En) begin
							if (cursorH1Done) begin
								next_Draw <= DISPLAY_CURSOR_V1;
							end
						else next_Draw <= DISPLAY_CURSOR_H1;
						end
					end
					
		DISPLAY_CURSOR_V1: begin
						if (cursorV1En) begin
							if (cursorV1Done) begin
								next_Draw <= DISPLAY_CURSOR_H2;
							end
						else next_Draw <= DISPLAY_CURSOR_V1;
						end
					end
		
		DISPLAY_CURSOR_H2: begin
						if (cursorH2En) begin
							if (cursorH2Done) begin
								next_Draw <= DISPLAY_CURSOR_V2;
							end
						else next_Draw <= DISPLAY_CURSOR_H2;
						end
					end
		
		DISPLAY_CURSOR_V2: begin
						if (cursorV2En) begin
							if (cursorV2Done) begin	
								if(erase)	
									next_Draw <= ERASE_CURSOR_H1;
								else if(isEmpty)
									next_Draw <= DISPLAY_NUM;
								else 
									next_Draw <= DISPLAY_CURSOR_V2;
							end
						else next_Draw <= DISPLAY_CURSOR_V2;
						end
					end
		ERASE_CURSOR_H1: begin
						if (cursor_erase_H1En) begin
							if (cursor_erase_H1Done) begin
								next_Draw <= ERASE_CURSOR_V1;
							end
						else next_Draw <= ERASE_CURSOR_H1;
						end
					end
		ERASE_CURSOR_V1: begin
						if (cursor_erase_V1En) begin
							if (cursor_erase_V1Done) begin
								next_Draw <= ERASE_CURSOR_H2;
							end
						else next_Draw <= ERASE_CURSOR_V1;
						end
					end
		ERASE_CURSOR_H2: begin
						if (cursor_erase_H2En) begin
							if (cursor_erase_H2Done) begin
								next_Draw <= ERASE_CURSOR_V2;
							end
						else next_Draw <= ERASE_CURSOR_H2;
						end
					end
		ERASE_CURSOR_V2: begin
						if (cursor_erase_V2En) begin
							if (cursor_erase_V1Done) begin
								
								next_Draw <= DISPLAY_CURSOR_H1;
							end
						else next_Draw <= ERASE_CURSOR_V2;
						end
					end				
		
		
		DISPLAY_NUM: begin
						if (numEn) begin
							if (numDone) begin
								if(gameover)
									next_Draw <= GAMEOVER_TOP;
								else
									next_Draw <= DISPLAY_CURSOR_H1;
							end
						else next_Draw <= DISPLAY_NUM;
						end
					end			
		
		
		GAMEOVER_TOP:	begin
						if (gameover1En) begin
							if (gameover_top_done) begin
								next_Draw <= GAMEOVER_BOT;
								end
							else next_Draw <= GAMEOVER_TOP;
							end
						end
		GAMEOVER_BOT:	begin
						if (gameover2En) begin
							if (gameover_bot_done) begin
								if(key_space)
									next_Draw <= RESET;
								end
							else next_Draw <= GAMEOVER_BOT;
							end
						end
		default: next_Draw<=RESET;
		endcase
	end
	
	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_START_TOP) begin
			startTopEn <= 1;
			end
		else startTopEn <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_START_BOT) begin
			startBotEn <= 1;
			end
		else startBotEn <= 0;
	end
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_BOARD_TOP) begin
			boardTopEn <= 1;
			end
		else boardTopEn <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_BOARD_BOT) begin
			boardBotEn <= 1;
			end
		else boardBotEn <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_CURSOR_H1) begin
			cursorH1En <= 1;
			end
		else cursorH1En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_CURSOR_V1) begin
			cursorV1En <= 1;
			end
		else cursorV1En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_CURSOR_H2) begin
			cursorH2En <= 1;
			end
		else cursorH2En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_CURSOR_V2) begin
			cursorV2En <= 1;
			end
		else cursorV2En <= 0;
	end	

	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==ERASE_CURSOR_H1) begin
			cursor_erase_H1En <= 1;
			end
		else cursor_erase_H1En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==ERASE_CURSOR_V1) begin
			cursor_erase_V1En <= 1;
			end
		else cursor_erase_V1En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==ERASE_CURSOR_H2) begin
			cursor_erase_H2En <= 1;
			end
		else cursor_erase_H2En <= 0;
	end	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==ERASE_CURSOR_V2) begin
			cursor_erase_V2En <= 1;
			end
		else cursor_erase_V2En <= 0;
	end	
	
	
	
	
	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==DISPLAY_NUM) begin
			numEn <= 1;
			end
		else numEn <= 0;
	end	
	
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==GAMEOVER_TOP) begin
			gameover1En <= 1;
			end
		else gameover1En <= 0;
	end
	
	always @ (posedge CLOCK_50)
	begin
		if (current_Draw==GAMEOVER_BOT) begin
			gameover2En <= 1;
			end
		else gameover2En <= 0;
	end
	
	
	always @ (posedge CLOCK_50 or negedge resetn)		// Shifting states
	begin
		if (resetn==0)
			current_Draw <= RESET;
		else 
			current_Draw <= next_Draw;
	end
	
	reg startin;
	
	always @ (posedge CLOCK_50)				
	begin
		if (current_Draw == DISPLAY_START_TOP) begin
			if (startTopEn) begin
				x <= top_x0+ start_top_x;
				y <= top_y0+ start_top_y;
				color <= start_top_color;
				writeEn <= startTopEn;
			end
		end
		
		else if (current_Draw == DISPLAY_START_BOT) begin
			if (startBotEn) begin
				x <= bot_x0+ start_bot_x;
				y <= bot_y0+start_bot_y;
				color <= start_bot_color;
				writeEn <= startBotEn;
				startin<=1'b1;
			end
		end
		
		 
		
		
		
		else if (current_Draw == DISPLAY_BOARD_TOP) begin
			if (boardTopEn) begin
				x <= top_x0+ board_top_x;
				y <= top_y0+board_top_y;
				color <= colourboardtop;
				writeEn <= boardTopEn;
			end
		end
		
		else if (current_Draw == DISPLAY_BOARD_BOT) begin
			if (boardBotEn) begin
				x <= bot_x0+ board_bot_x;
				y <= bot_y0+board_bot_y;
				color <= colourboardbot;
				writeEn <= boardBotEn;
			end
		end
		
		else if (current_Draw == DISPLAY_CURSOR_H1) begin
			if (cursorH1En) begin
				x <= cursor_x+xCounth1;
				y <= cursor_y+yCounth1;
				color <= colourcursorh1;
				writeEn <= cursorH1En;
			end
		end
		
		else if (current_Draw == DISPLAY_CURSOR_H2) begin
			if (cursorH2En) begin
				x <= cursor_x+xCounth2;
				y <= cursor_y+yCounth2;
				color <= colourcursorh2;
				writeEn <= cursorH2En;
			end
		end
		
		else if (current_Draw == DISPLAY_CURSOR_V1) begin
			if (cursorV1En) begin
				x <= cursor_x+xCountv1;
				y <= cursor_y+yCountv1;
				color <= colourcursorv1;
				writeEn <= cursorV1En;
			end
		end
		
		else if (current_Draw == DISPLAY_CURSOR_V2) begin
			if (cursorV2En) begin
				x <= cursor_x+xCountv2;
				y <= cursor_y+yCountv2;
				color <= colourcursorv2;
				writeEn <= cursorV2En;
				begin
				if (input_num!=0 && board_occu[cursor_ij]==1'b0) 
					isEmpty=1'b1;
				else
					isEmpty=1'b0;
				end
			end
		end 
		
		//
		else if (current_Draw == ERASE_CURSOR_H1) begin
			if (cursor_erase_H1En) begin
				x <= cursor_xold+x_erase_Counth1;
				y <= cursor_yold+y_erase_Counth1;
				color <= 6'b000000;
				writeEn <= cursor_erase_H1En;
			end
		end
		
		else if (current_Draw == ERASE_CURSOR_H2) begin
			if (cursor_erase_H2En) begin
				x <= cursor_xold+x_erase_Counth2;
				y <= cursor_yold+y_erase_Counth2;
				color <= 6'b000000;
				writeEn <= cursor_erase_H2En;
			end
		end
		
		else if (current_Draw == ERASE_CURSOR_V1) begin
			if (cursorV2En) begin
				x <= cursor_xold+x_erase_Countv1;
				y <= cursor_yold+y_erase_Countv1;
				color <= 6'b000000;
				writeEn <= cursor_erase_V1En;
			end
		end
		
		else if (current_Draw == ERASE_CURSOR_V2) begin
			if (cursorV2En) begin
				x <= cursor_xold+x_erase_Countv2;
				y <= cursor_yold+y_erase_Countv2;
				color <= 6'b000000;
				writeEn <= cursor_erase_V2En;
			end
		end
		//
		
		
		
		else if (current_Draw==DISPLAY_NUM) begin
			if(numEn) begin
				x<=cursor_x+xCountNum;
				y<=cursor_y+yCountNum;
				if(input_num==4'd1)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num1_color_incorrect;
							
						end
					else
						color <= num1_color;
						//color <= 6'b000111;
				end
				else if(input_num==4'd2)begin
				   if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num2_color_incorrect;
							
						end
					else
						color <= num2_color;
				end
			   else if(input_num==4'd3)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num3_color_incorrect;
							
						end
					else
						color <= num3_color;
				end
		  	   else if(input_num==4'd4)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num4_color_incorrect;
							
						end
					else
						color <= num4_color;
				end
			   else if(input_num==4'd5)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num5_color_incorrect;
							
						end
					else
						color <= num5_color;
				end
			   else if(input_num==4'd6)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num6_color_incorrect;
							
						end
					else
						color <= num6_color;
				end
			   else if(input_num==4'd7)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num7_color_incorrect;
							
						end
					else
						color <= num7_color;
				end
			   else if(input_num==4'd8)begin
					if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num8_color_incorrect;
							
						end
					else
						color <= num8_color;
				end
			   else if(input_num==4'd9)begin
				  if (!isCorrect)begin
						if (key_delete)
							color <= 6'b111111;
						else 
							color <= num9_color_incorrect;
							
						end
					else
						color <= num9_color;
				end
				writeEn <= numEn;
			end
		end
		
		
		else if (current_Draw == GAMEOVER_TOP) begin
			if (gameover1En) begin
				x <= top_x0+x_gameover1;
				y <= top_y0+y_gameover1;
				color <= colourgameover1;
				writeEn <= gameover1En;
			end
		end
		
		else if (current_Draw == GAMEOVER_BOT) begin
			if (gameover2En) begin
				x <= top_x0+x_gameover2;
				y <= top_y0+y_gameover2;
				color <= colourgameover2;
				writeEn <= gameover2En;
			end
		end

		else writeEn <=0;
	end
	
	
	
	
	//count nums
	always @ (posedge CLOCK_50)
	begin
		if (isCorrect) 
			put_count=put_count+1;
		else put_count <= put_count;
	end
	

	
	//check incorrect
	checker check(clkout, resetn, input_num, cursor_i,cursor_j, isCorrect);
	
	//check num delete
	
	
	always @ (posedge CLOCK_50)
	begin
		if (put_count == 8'd81 - 8'd35) 
			gameover <= 1;
		else gameover <= 0;
	end

	//Datapath
	
	
	always@(*)
	begin
	
		if (resetn==0)begin
			cursor_i = 4'd4;
        cursor_j = 4'd4;
		  cursor_ij=9'd160;
		  cursor_x= 10'd106;
		  cursor_y= 9'd118;
		  cursor_xold = 10'd106;
			cursor_yold = 9'd118;
		 erase=1'b0;
		 
		end
		
		else begin
		
			if (cursorV2Done) begin
				if(key_up && cursor_i >0)begin
					erase=1'b1;
					cursor_i = cursor_i - 4'b1;
					cursor_ij= cursor_ij - 8'd36;
					cursor_x= cursor_x;
					cursor_y= cursor_y - 9'd21;
					cursor_xold = cursor_x;
					cursor_yold = cursor_y;
				end	
				else if (key_down && cursor_i < 4'd8) begin
					erase=1'b1;
					cursor_i = cursor_i + 1'b1;
					cursor_ij= cursor_ij + 8'd36;
						
					cursor_x= cursor_x;
					cursor_y= cursor_y + 9'd21;
					cursor_xold = cursor_x;
					cursor_yold = cursor_y;
				end			
				else if (key_left && cursor_j >0) begin
					erase=1'b1;
					cursor_j = cursor_j - 4'b1;
						  cursor_ij= cursor_ij - 8'd16;
						  cursor_x= cursor_x- 10'd21;
						  cursor_y= cursor_y;
						  cursor_xold = cursor_x;
							cursor_yold = cursor_y;
				end
				else if (key_right && cursor_j < 4'd8) begin
			erase=1'b1;
         cursor_j = cursor_j + 4'b1;
			cursor_ij= cursor_ij + 8'd16;
			cursor_x= cursor_x+ 10'd21;
			cursor_y= cursor_y;
			cursor_xold = cursor_x;
			cursor_yold = cursor_y;
				end
				else
					erase=1'b0;
		end
		else begin
			erase=1'b0;
			cursor_i = cursor_i;
			cursor_j = cursor_j;
			cursor_ij= cursor_ij;
			cursor_x= cursor_x;
			cursor_y= cursor_y;
			cursor_xold = cursor_xold;
			cursor_yold = cursor_yold;
		end
	end
	end
	
	
	
	always@(*)
	begin
	if (cursorV2Done) begin
		if(key_num1)
			input_num=4'd1;
		else if (key_num2) 
			input_num=4'd2;
		else if (key_num3) 
			input_num=4'd3;
		else if (key_num4) 
			input_num=4'd4;
		else if (key_num5) 
			input_num=4'd5;
		else if (key_num6) 
			input_num=4'd6;
		else if (key_num7) 
			input_num=4'd7;
		else if (key_num8) 
			input_num=4'd8;
		else if (key_num9) 
			input_num=4'd9;
		else
			input_num=4'd0;
	end
	else
		input_num=4'd0;
	end
	
	
	

	sudoku_datapath path(CLOCK_50,resetn, isEmpty,cursor_ij, input_num,board_occu);
	
endmodule		

module frameCounter(clkin,clkout);
	input clkin;
	output reg clkout = 0;
	reg [26:0] counter = 0;
	always @(posedge clkin)
	begin
		if (counter == 0)
		begin
			counter <= (50000000/5-1);
			clkout <= 1;
		end
		else 
		begin
			counter <= counter -1;
			clkout <= 0;
		end
	end
endmodule 




module checker(clk, clr, input_num, input_row, input_col, isCorrect);
	input clk;
	input clr;
	input [3:0]input_num;
	input [3:0]input_row;
	input [3:0]input_col;
	output reg isCorrect;
	wire [3:0]template_grid[8:0][8:0];
	
	assign template_grid[0][0] = 4'd9;
	assign template_grid[0][1] = 4'd8;
	assign template_grid[0][2] = 4'd7;
	assign template_grid[0][3] = 4'd6;
	assign template_grid[0][4] = 4'd2;
	assign template_grid[0][5] = 4'd5;
	assign template_grid[0][6] = 4'd4;
	assign template_grid[0][7] = 4'd3;
	assign template_grid[0][8] = 4'd1;
	assign template_grid[1][0] = 4'd3;
	assign template_grid[1][1] = 4'd1;
	assign template_grid[1][2] = 4'd5;
	assign template_grid[1][3] = 4'd4;
	assign template_grid[1][4] = 4'd9;
	assign template_grid[1][5] = 4'd7;
	assign template_grid[1][6] = 4'd6;
	assign template_grid[1][7] = 4'd2;
	assign template_grid[1][8] = 4'd8;
	assign template_grid[2][0] = 4'd2;
	assign template_grid[2][1] = 4'd4;
	assign template_grid[2][2] = 4'd6;
	assign template_grid[2][3] = 4'd1;
	assign template_grid[2][4] = 4'd3;
	assign template_grid[2][5] = 4'd8;
	assign template_grid[2][6] = 4'd5;
	assign template_grid[2][7] = 4'd9;
	assign template_grid[2][8] = 4'd7;
	assign template_grid[3][0] = 4'd5;
	assign template_grid[3][1] = 4'd3;
	assign template_grid[3][2] = 4'd9;
	assign template_grid[3][3] = 4'd2;
	assign template_grid[3][4] = 4'd8;
	assign template_grid[3][5] = 4'd1;
	assign template_grid[3][6] = 4'd7;
	assign template_grid[3][7] = 4'd4;
	assign template_grid[3][8] = 4'd6;
	assign template_grid[4][0] = 4'd6;
	assign template_grid[4][1] = 4'd7;
	assign template_grid[4][2] = 4'd1;
	assign template_grid[4][3] = 4'd3;
	assign template_grid[4][4] = 4'd4;
	assign template_grid[4][5] = 4'd9;
	assign template_grid[4][6] = 4'd8;
	assign template_grid[4][7] = 4'd5;//
	assign template_grid[4][8] = 4'd2;
	assign template_grid[5][0] = 4'd4;
	assign template_grid[5][1] = 4'd2;
	assign template_grid[5][2] = 4'd8;
	assign template_grid[5][3] = 4'd5;
	assign template_grid[5][4] = 4'd7;
	assign template_grid[5][5] = 4'd6;
	assign template_grid[5][6] = 4'd3;
	assign template_grid[5][7] = 4'd1;
	assign template_grid[5][8] = 4'd9;
	assign template_grid[6][0] = 4'd7;
	assign template_grid[6][1] = 4'd5;
	assign template_grid[6][2] = 4'd3;
	assign template_grid[6][3] = 4'd9;
	assign template_grid[6][4] = 4'd6;
	assign template_grid[6][5] = 4'd2;
	assign template_grid[6][6] = 4'd1;
	assign template_grid[6][7] = 4'd8;
	assign template_grid[6][8] = 4'd4;
	assign template_grid[7][0] = 4'd8;
	assign template_grid[7][1] = 4'd9;//////
	assign template_grid[7][2] = 4'd4;
	assign template_grid[7][3] = 4'd7;
	assign template_grid[7][4] = 4'd1;
	assign template_grid[7][5] = 4'd3;
	assign template_grid[7][6] = 4'd2;
	assign template_grid[7][7] = 4'd6;
	assign template_grid[7][8] = 4'd5;
	assign template_grid[8][0] = 4'd1;
	assign template_grid[8][1] = 4'd6;
	assign template_grid[8][2] = 4'd2;
	assign template_grid[8][3] = 4'd8;
	assign template_grid[8][4] = 4'd5;
	assign template_grid[8][5] = 4'd4;
	assign template_grid[8][6] = 4'd9;
	assign template_grid[8][7] = 4'd7;
	assign template_grid[8][8] = 4'd3;
	
	//input [3:0]input_grid[8:0][8:0];
	
	//template answer(template_grid);
	
	always@(posedge clk) begin
    	if (!clr) begin
        	isCorrect = 0;
        end
        else if(input_num==template_grid[input_row][input_col])
        	isCorrect = 1'b1;
	end
endmodule       


module sudoku_datapath(clk,rst,write,write_ij, write_num,board_out);
   input clk;
   input rst;
   //input clear;
   input write; //enable-write signal
   
   input [8:0] write_ij;
   input [3:0] write_num;
   //input easy_mode;
   //input medium_mode;
   //input hard_mode;
   output [323:0] board_out ;		//row info for logic
   reg [323:0] board_occu;
   
    
    
    always @ (negedge clk or negedge rst) begin
        if (!rst ) begin
        	
            board_occu[3:0] <= 4'd9;
			 	board_occu[7:4] <= 4'd0;
			 	board_occu[11:8] <= 4'd0;
			 	board_occu[15:12] <= 4'd0;
			 	board_occu[19:16] <= 4'd2;
				board_occu[23:20] <= 4'd0;
			 	board_occu[27:24] <= 4'd4;
			 	board_occu[31:28] <= 4'd0;
			 	board_occu[35:32] <= 4'd1;
			 
				board_occu[39:36] <= 4'd0;
			 	board_occu[43:40] <= 4'd0;
				board_occu[47:44] <= 4'd5;
			 	board_occu[51:48] <= 4'd0;
			 	board_occu[55:52] <= 4'd9;
			 	board_occu[59:56] <= 4'd0;
			 	board_occu[63:60] <= 4'd0;
			 	board_occu[67:64] <= 4'd2;
			 	board_occu[71:68] <= 4'd0;
			 
				board_occu[75:72] <= 4'd0;
			 	board_occu[79:76] <= 4'd4;
			 	board_occu[83:80] <= 4'd0;
			 	board_occu[87:84] <= 4'd1;
			 	board_occu[91:88] <= 4'd0;
			 	board_occu[95:92] <= 4'd0;
			 	board_occu[99:96] <= 4'd0;
			 	board_occu[103:100] <= 4'd9;
			 	board_occu[107:104] <= 4'd7;
			 
			 	board_occu[111:108] <= 4'd5;
			 	board_occu[115:112] <= 4'd0;
			 	board_occu[119:116] <= 4'd0;
			 	board_occu[123:120] <= 4'd0;
			 	board_occu[127:124] <= 4'd0;
				board_occu[131:128] <= 4'd1;
			 	board_occu[135:132] <= 4'd0;
			 	board_occu[139:136] <= 4'd0;
			 	board_occu[143:140] <= 4'd0;
			 
			 	board_occu[147:144] <= 4'd0;
			 	board_occu[151:148] <= 4'd0;
			 	board_occu[155:152] <= 4'd0;
			 	board_occu[159:156] <= 4'd0;
			 	board_occu[163:160] <= 4'd0;
			 	board_occu[167:164] <= 4'd0;
			 	board_occu[171:168] <= 4'd0;
			 	board_occu[175:172] <= 4'd0;
			 	board_occu[179:176] <= 4'd2;
			 
			 	board_occu[183:180] <= 4'd4;
			 	board_occu[187:184] <= 4'd0;
			 	board_occu[191:188] <= 4'd0;
			 	board_occu[195:192] <= 4'd5;
			 	board_occu[199:196] <= 4'd7;
			 	board_occu[203:200] <= 4'd0;
			 	board_occu[207:204] <= 4'd3;
			 	board_occu[211:208] <= 4'd0;
			 	board_occu[215:212] <= 4'd9;
			 
			 	board_occu[219:216] <= 4'd0;
			 	board_occu[223:220] <= 4'd5;
			 	board_occu[227:224] <= 4'd3;
			 	board_occu[231:228] <= 4'd0;
			 	board_occu[235:232] <= 4'd0;
			 	board_occu[239:236] <= 4'd2;
			 	board_occu[243:240] <= 4'd1;
			 	board_occu[247:244] <= 4'd8;
			 	board_occu[251:248] <= 4'd0;
			 
			 	board_occu[255:252] <= 4'd0;
			 	board_occu[259:256] <= 4'd0;
			 	board_occu[263:260] <= 4'd0;
			 	board_occu[267:264] <= 4'd0;
			 	board_occu[271:268] <= 4'd0;
			 	board_occu[275:272] <= 4'd0;
			 	board_occu[279:276] <= 4'd0;
			 	board_occu[283:280] <= 4'd0;
			 	board_occu[287:284] <= 4'd0;
			 
			 	board_occu[291:288] <= 4'd0;
			 	board_occu[295:292] <= 4'd0;
			 	board_occu[299:296] <= 4'd2;
			 	board_occu[303:300] <= 4'd8;
			 	board_occu[307:304] <= 4'd0;
			 	board_occu[311:308] <= 4'd0;
			 	board_occu[315:312] <= 4'd0;
			 	board_occu[319:316] <= 4'd0;
			 	board_occu[323:320] <= 4'd3;
			end
		
        else if (write)
            //board_default[write_i][write_j] <= write_num;
				board_occu[write_ij] <= write_num[0];
				board_occu[write_ij+9'd1] <= write_num[1];
				board_occu[write_ij+9'd2] <= write_num[2];
				board_occu[write_ij+9'd3] <= write_num[3];
				
    end
	 assign board_out=board_occu[323:0];
endmodule

