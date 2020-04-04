module draw_gridhor (clk, enable, xCount, yCount, address, done); 
//17x1
	input clk, enable;
	output 	reg [4:0]xCount;
	output 	reg [1:0]yCount;
	output reg [4:0]address;
	output reg done;
	
	initial begin
	xCount = 0;
	yCount = 0;
	address = 2;
	end	
	
	always @ (posedge clk)
	begin
	if (enable) begin
		if (xCount < 5'd16)
		         xCount <= xCount +1;
		else if (xCount==5'd16) begin
			if (yCount<2'd0) begin
				//xCount<=0;
				yCount<=yCount+1;
			end
			else if (yCount==2'd0) done<=1; 
		end
		address <= address+5'b1;
		end
	    else begin 
		done <= 0; 
		xCount = 0;
		yCount = 0;
		address <= 2;
		end
	end
endmodule 


 	 

module draw_gridver (clk, enable, xCount, yCount, address, done); 
//1x19
	input clk, enable;
	output 	reg [1:0]xCount;
	output 	reg [4:0]yCount;
	output reg [4:0]address;
	output reg done;
	
	initial begin
	xCount = 0;
	yCount = 0;
	address = 2;
	end	
	
	always @ (posedge clk)
	begin
	if (enable) begin
		if (xCount < 2'd0)
		         xCount <= xCount +1;
			
		else if (xCount==2'd0) begin
			if (yCount<5'd18) begin
			//	xCount<=0;
				yCount<=yCount+1;
			end
			else if (yCount==5'd18) done<=1; 
		end
		address <= address+5'b1;
		end
	    else begin 
		done <= 0; 
		xCount = 0;
		yCount = 0;
		address <= 2;
		end
	end
endmodule 