module drawNum(clk, enable, xCount, yCount, address, done);
//18x18
//num1 to num9
	input clk, enable;
	output 	reg [4:0]xCount;
	output 	reg [4:0]yCount;
	output reg [8:0]address;
	output reg done;
	
	initial begin
	xCount = 0;
	yCount = 0;
	address = 2;
	end	
	
	always @ (posedge clk)
	begin
	if (enable) begin
		if (xCount < 5'd17)
		         xCount <= xCount +1;
				if (yCount == 5'd17) done<=1;
		else if (xCount==5'd17) begin
			if (yCount<5'd17) begin
				//xCount<=0;
				yCount<=yCount+1;
			end
		end
		address <= address+11'b1;
		end
	    else begin 
		done <= 0; 
		xCount = 0;
		yCount = 0;
		address = 2;
		end
	end
endmodule 
