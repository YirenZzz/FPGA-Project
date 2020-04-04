module draww (clk, enable, xCount, yCount, address, done); 
 	/* Draws out invader and sends appropriate (x,y) position of each pixel*/ 
 
 	input clk, enable; 
 	output reg [5:0]xCount; 
 	output reg [5:0]yCount; 
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
 		if (xCount < 6'd46) 
 				xCount <= xCount +1; 
 		else if (xCount==6'd46) begin 
 			if (yCount<6'd51) begin 
 				xCount<=0; 
 				yCount<=yCount+1; 
 				end 
 			else if (yCount==6'd51) done<=1; 
 			end 
 		address <= address+12'b1; 
 		end 
 	else begin  
 		done <= 0;  
 		address <= 2; 
		xCount = 0; 
 		yCount = 0; 
 		end 
 	end 

 endmodule 
