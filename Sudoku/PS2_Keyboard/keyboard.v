module keyboard(CLOCK_50, PS2_CLK, PS2_DAT, reset, up, down, 
				left, right, space, backspace,num1, num2, num3, num4,
				num5, num6, num7, num8, num9);
				
		
	
			
	input CLOCK_50;
	input reset;
	
	inout PS2_CLK;
	inout PS2_DAT;
	
	output reg up, down, left, right, space,backspace, num1, num2, num3, num4,
				num5, num6, num7, num8, num9;

	wire		[7:0]	ps2_key_data;
	wire				ps2_key_pressed;
	
	//regs
	reg [7:0] ps2_key_data_1, ps2_key_data_2, ps2_key_data_3;
	
	//dataflow
	always @(posedge CLOCK_50) begin	
		if (!reset) begin
			ps2_key_data_1 <= 8'b0;
			ps2_key_data_2 <= 8'b0;
			ps2_key_data_3 <= 8'b0;
		end
		else if (ps2_key_pressed) begin
			ps2_key_data_1 <= ps2_key_data_2;
			ps2_key_data_2 <= ps2_key_data_3;
			ps2_key_data_3 <= ps2_key_data;
		end
	end
	
	//up
	always @(posedge CLOCK_50) begin
		if (!reset)
			up <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h75)
			up <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h75)
			up <= 1'b0;
	end
	
	//down
	always @(posedge CLOCK_50) begin
		if (!reset) 
			down <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h72)
			down <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h72)
			down <= 1'b0;
	end
	
	//left
	always @(posedge CLOCK_50) begin
		if (!reset)
			left <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h6B)
			left <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h6B)
			left <= 1'b0;
	end
	
	//right
	always @(posedge CLOCK_50) begin
		if (!reset)
			right <= 1'b0;
		else if (ps2_key_data_2 == 8'hE0 && ps2_key_data_3 == 8'h74)
			right <= 1'b1;
		else if (ps2_key_data_1 == 8'hE0 && ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h74)
			right <= 1'b0;
	end
	
	//space
	always @(posedge CLOCK_50) begin
		if (!reset) 
			space <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h29)
			space <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h29)
			space <= 1'b0;
	end
	
	//backspace
	always @(posedge CLOCK_50) begin
		if (!reset) 
			backspace <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h66)
			backspace <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 == 8'h66)
			backspace <= 1'b0;
	end
	
	//num1
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num1 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h16)
			num1 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h16)
			num1 <= 1'b0;
	end
	
	//num2
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num2 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h1E)
			num2 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h1E)
			num2 <= 1'b0;
	end
	
	//num3
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num3 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h26)
			num3 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h26)
			num3 <= 1'b0;
	end
	
	//num4
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num4 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h25)
			num4 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h25)
			num4 <= 1'b0;
	end
	
	//num5
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num5 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h2E)
			num5 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h2E)
			num5 <= 1'b0;
	end
	
	//num6
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num6 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h36)
			num6 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h36)
			num6 <= 1'b0;
	end
	
	//num7
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num7 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h3D)
			num7 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h3D)
			num7 <= 1'b0;
	end
	
	//num8
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num8 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h3E)
			num8 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h3E)
			num8 <= 1'b0;
	end
	
	//num9
	always @(posedge CLOCK_50) begin
		if (!reset) 
			num9 <= 1'b0;
		else if (ps2_key_data_2 != 8'hF0 && ps2_key_data_3 == 8'h46)
			num9 <= 1'b1;
		else if (ps2_key_data_2 == 8'hF0 && ps2_key_data_3 ==  8'h46)
			num9 <= 1'b0;
	end
	
	PS2_Controller PS2 (
		// Inputs
		.CLOCK_50			(CLOCK_50),
		.reset				(reset),
		// Bidirectionals
		.PS2_CLK			(PS2_CLK),
		.PS2_DAT			(PS2_DAT),
		// Outputs
		.received_data		(ps2_key_data),
		.received_data_en	(ps2_key_pressed)
	);
	
endmodule
