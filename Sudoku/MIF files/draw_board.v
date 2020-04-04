module draw_board (clk, enable, xCount, yCount, address, done); 
 	/* Draws out invader and sends appropriate (x,y) position of each pixel*/ 
 
 	input clk, enable; 
 	output reg [9:0]xCount; 
 	output reg [8:0]yCount; 
	output reg [15:0]address;
// 	output reg [11:0]address; 
 	output reg done; 
 	 
 	initial begin 
 	xCount = 0; 
 	yCount = 0; 
 	address = 2; 
 	end	 
 	 
 	always @ (posedge clk) 
 	begin 
 	if (enable) begin 
 		if (xCount < 10'd319) 
 				xCount <= xCount +1; 
 		else if (xCount==10'd319) begin 
 			if (yCount<9'd119) begin 
 				//xCount<=0; 
 				yCount<=yCount+1; 
 				end 
 			else if (yCount==9'd119) done<=1; 
 			end 
 		address <= address+16'b1; 
 		end 
 	else begin  
 		done <= 0;  
 		address <= 2; 
		xCount = 0; 
 		yCount = 0; 
 		end 
 	end 

 endmodule 
 
 
 
