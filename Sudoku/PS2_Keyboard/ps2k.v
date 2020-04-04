//------------------------------------------------------------------------------
// Dealing with the input data of the PS2 keyboard
//------------------------------------------------------------------------------

module ps2_input(
    input wire clk_slow,      // Slower clock for this module
    input wire clk_fast,      // Faster clock for the PS2 scanner
    input wire rst,           // Reset
    input wire ps2_clk,       // PS2 clock
    input wire ps2_data,      // PS2 data
    
    output wire key_up,       // If UP key is pressed
    output wire key_down,     // If DOWN key is pressed
    output wire key_left,     // If LEFT key is pressed
    output wire key_right,    // If RIGHT key is pressed
    output wire key_space,       // If SPACE key is pressed
    output wire key_delete,       // If DELETE key is pressed
    
    //output wire key_num0,    // If 0 key is pressed
    output wire key_num1,    // If 1 key is pressed
    output wire key_num2,    // If 2 key is pressed
    output wire key_num3,    // If 3 key is pressed
    output wire key_num4,    // If 4 key is pressed
    output wire key_num5,    // If 5 key is pressed
    output wire key_num6,    // If 6 key is pressed
    output wire key_num7,    // If 7 key is pressed
    output wire key_num8,    // If 8 key is pressed
    output wire key_num9    // If 9 key is pressed
    
    );
    
    wire [8:0] crt_data;    // Input data of the PS2 keyboard
    
    // Key state recorders
    reg [1:0] key_up_state, key_down_state, key_left_state, key_right_state, 
    			key_space_state,key_delete_state,key_num1_state,key_num2_state,
    			key_num3_state,key_num4_state,key_num5_state,key_num6_state,
    			key_num7_state, key_num8_state,key_num9_state;
    			
    // Only becomes true at the posedge of each key
    assign key_up = key_up_state[0] & ~key_up_state[1];
    assign key_down = key_down_state[0] & ~key_down_state[1];
    assign key_left = key_left_state[0] & ~key_left_state[1];
    assign key_right = key_right_state[0] & ~key_right_state[1];
    assign key_space = key_space_state[0] & ~key_space_state[1];
    assign key_delete = key_delete_state[0] & ~key_delete_state[1];
    
    //assign key_num0 = key_num0_state[0] & ~key_num0_state[1];
    assign key_num1 = key_num1_state[0] & ~key_num1_state[1];
    assign key_num2 = key_num2_state[0] & ~key_num2_state[1];
    assign key_num3 = key_num3_state[0] & ~key_num3_state[1];
    assign key_num4 = key_num4_state[0] & ~key_num4_state[1];
    assign key_num5 = key_num5_state[0] & ~key_num5_state[1];
    assign key_num6 = key_num6_state[0] & ~key_num6_state[1];
    assign key_num7 = key_num7_state[0] & ~key_num7_state[1];
    assign key_num8 = key_num8_state[0] & ~key_num8_state[1];
    assign key_num9 = key_num9_state[0] & ~key_num9_state[1];
    
    // PS2 keyboard scanner
    ps2_scan
        scanner(
            .clk(clk_fast),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .crt_data(crt_data)
        );

    
    
    always @ (posedge clk_slow or negedge rst)
        if (!rst) begin
            key_up_state <= 2'b0;
            key_down_state <= 2'b0;
            key_left_state <= 2'b0;
            key_right_state <= 2'b0;
            key_space_state <= 2'b0;
            key_delete_state <= 2'b0;//backspace
           
            key_num1_state <= 2'b0;
            key_num2_state <= 2'b0;
            key_num3_state <= 2'b0;
            key_num4_state <= 2'b0;
            key_num5_state <= 2'b0;
            key_num6_state <= 2'b0;
            key_num7_state <= 2'b0;
            key_num8_state <= 2'b0;
            key_num9_state <= 2'b0;
        end
        else begin
            // Record the key state
            key_up_state <= {key_up_state[0], crt_data == 9'h175};
            key_down_state <= {key_down_state[0], crt_data == 9'h172};
            key_left_state <= {key_left_state[0], crt_data == 9'h16b};
            key_right_state <= {key_right_state[0], crt_data == 9'h174};
            key_space_state <= {key_space_state[0], crt_data == 9'h029};
			key_delete_state <= {key_delete_state[0], crt_data == 9'h066};
            
            key_num1_state <= {key_num1_state[0], crt_data == 9'h016};
            key_num2_state <= {key_num2_state[0], crt_data == 9'h01E};
            key_num3_state <= {key_num3_state[0], crt_data == 9'h026};
            key_num4_state <= {key_num4_state[0], crt_data == 9'h025};
            key_num5_state <= {key_num5_state[0], crt_data == 9'h02E};
            key_num6_state <= {key_num6_state[0], crt_data == 9'h036};
            key_num7_state <= {key_num7_state[0], crt_data == 9'h03D};
            key_num8_state <= {key_num8_state[0], crt_data == 9'h03E};
            key_num9_state <= {key_num9_state[0], crt_data == 9'h046};
            
        end

endmodule



//------------------------------------------------------------------------------
// PS2 keyboard scanner
//------------------------------------------------------------------------------
module ps2_scan(
    input wire clk,              // Clock
    input wire rst,              // Reset
    input wire ps2_clk,          // PS2 clock
    input wire ps2_data,         // PS2 data
    
    output reg [8:0] crt_data    // Input data of the keyboard
    );
    
    reg [1:0] ps2_clk_state;    // PS2 clock recorder
    wire ps2_clk_neg;           // True at the negedge of the PS2 clock
    assign ps2_clk_neg = ~ps2_clk_state[0] & ps2_clk_state[1];
    
    // Registers for data reading
    reg [3:0] read_state;
    reg [7:0] read_data;
    
    // Registers for special signals
    reg is_f0, is_e0;
    
    // Record the PS2 clock
    always @ (posedge clk or negedge rst)
        if (!rst)
            ps2_clk_state <= 2'b0;
        else
            ps2_clk_state <= {ps2_clk_state[0], ps2_clk};
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            read_state <= 4'b0;
            read_data <= 8'b0;
            
            is_f0 <= 1'b0;
            is_e0 <= 1'b0;
            crt_data <= 9'b0;
        end
        else if (ps2_clk_neg) begin
            // Reads in the data
            if (read_state > 4'b1001)
                read_state <= 4'b0;
            else begin
                if (read_state > 4'b0 && read_state < 4'b1001)
                    read_data[read_state - 1] <= ps2_data;
                read_state <= read_state + 1'b1;
            end
        end
        else if (read_state == 4'b1010 && |read_data) begin
            if (read_data == 8'hf0)
                is_f0 <= 1'b1;
            else if (read_data == 8'he0)
                is_e0 <= 1'b1;
            else
                if (is_f0) begin
                    // A key is released
                    is_f0 <= 1'b0;
                    is_e0 <= 1'b0;
                    crt_data <= 9'b0;
                end
                else if (is_e0) begin
                    is_e0 <= 1'b0;
                    crt_data <= {1'b1, read_data};
                end
                else
                    crt_data <= {1'b0, read_data};
            
            read_data <= 8'b0;
        end
    end
    
endmodule
    


/*

module ps2_input(
    input wire clk_slow,      // Slower clock for this module
    input wire clk_fast,      // Faster clock for the PS2 scanner
    input wire rst,           // Reset
    input wire ps2_clk,       // PS2 clock
    input wire ps2_data,      // PS2 data
    
    output wire key_up,       // If UP key is pressed
    output wire key_down,     // If DOWN key is pressed
    output wire key_left,     // If LEFT key is pressed
    output wire key_right,    // If RIGHT key is pressed
    output wire key_space,       // If SPACE key is pressed
    output wire key_delete,       // If DELETE key is pressed

    output wire key_num1,    // If 1 key is pressed
    output wire key_num2,    // If 2 key is pressed
    output wire key_num3,    // If 3 key is pressed
    output wire key_num4,    // If 4 key is pressed
    output wire key_num5,    // If 5 key is pressed
    output wire key_num6,    // If 6 key is pressed
    output wire key_num7,    // If 7 key is pressed
    output wire key_num8,    // If 8 key is pressed
    output wire key_num9    // If 9 key is pressed
    
    );
    
    wire [8:0] crt_data;    // Input data of the PS2 keyboard
    
    // Key state recorders
    reg [1:0] key_up_state, key_down_state, key_left_state, key_right_state, 
    			key_space_state,key_delete_state, key_num0_state,key_num1_state,key_num2_state,
    			key_num3_state,key_num4_state,key_num5_state,key_num6_state,
    			key_num7_state, key_num8_state,key_num9_state;
    			
    // Only becomes true at the posedge of each key
    assign key_up = key_up_state[0] & ~key_up_state[1];
    assign key_down = key_down_state[0] & ~key_down_state[1];
    assign key_left = key_left_state[0] & ~key_left_state[1];
    assign key_right = key_right_state[0] & ~key_right_state[1];
    assign key_space = key_space_state[0] & ~key_space_state[1];
    assign key_delete = key_delete_state[0] & ~key_delete_state[1];

    assign key_num1 = key_num1_state[0] & ~key_num1_state[1];
    assign key_num2 = key_num2_state[0] & ~key_num2_state[1];
    assign key_num3 = key_num3_state[0] & ~key_num3_state[1];
    assign key_num4 = key_num4_state[0] & ~key_num4_state[1];
    assign key_num5 = key_num5_state[0] & ~key_num5_state[1];
    assign key_num6 = key_num6_state[0] & ~key_num6_state[1];
    assign key_num7 = key_num7_state[0] & ~key_num7_state[1];
    assign key_num8 = key_num8_state[0] & ~key_num8_state[1];
    assign key_num9 = key_num9_state[0] & ~key_num9_state[1];
    
    // PS2 keyboard scanner
    ps2_scan
        scanner(
            .clk(clk_fast),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .crt_data(crt_data)
        );

    
    
    always @ (posedge clk_slow or negedge rst)
        if (!rst) begin
            key_up_state <= 2'b0;
            key_down_state <= 2'b0;
            key_left_state <= 2'b0;
            key_right_state <= 2'b0;
            key_space_state <= 2'b0;
            key_delete_state <= 2'b0;//backspace
           
            key_num1_state <= 2'b0;
            key_num2_state <= 2'b0;
            key_num3_state <= 2'b0;
            key_num4_state <= 2'b0;
            key_num5_state <= 2'b0;
            key_num6_state <= 2'b0;
            key_num7_state <= 2'b0;
            key_num8_state <= 2'b0;
            key_num9_state <= 2'b0;
        end
        else begin
            // Record the key state
            key_up_state <= {key_up_state[0], crt_data == 9'h175};
            key_down_state <= {key_down_state[0], crt_data == 9'h172};
            key_left_state <= {key_left_state[0], crt_data == 9'h16b};
            key_right_state <= {key_right_state[0], crt_data == 9'h174};
            key_space_state <= {key_space_state[0], crt_data == 9'h029};
			key_delete_state <= {key_delete_state[0], crt_data == 9'h066};
            
            key_num1_state <= {key_num1_state[0], crt_data == 9'h016};
            key_num2_state <= {key_num2_state[0], crt_data == 9'h01E};
            key_num3_state <= {key_num3_state[0], crt_data == 9'h026};
            key_num4_state <= {key_num4_state[0], crt_data == 9'h025};
            key_num5_state <= {key_num5_state[0], crt_data == 9'h02E};
            key_num6_state <= {key_num6_state[0], crt_data == 9'h036};
            key_num7_state <= {key_num7_state[0], crt_data == 9'h03D};
            key_num8_state <= {key_num8_state[0], crt_data == 9'h03E};
            key_num9_state <= {key_num9_state[0], crt_data == 9'h046};
            
        end

endmodule



//------------------------------------------------------------------------------
// PS2 keyboard scanner
//------------------------------------------------------------------------------
module ps2_scan(
    input wire clk,              // Clock
    input wire rst,              // Reset
    input wire ps2_clk,          // PS2 clock
    input wire ps2_data,         // PS2 data
    
    output reg [8:0] crt_data    // Input data of the keyboard
    );
    
    reg [1:0] ps2_clk_state;    // PS2 clock recorder
    wire ps2_clk_neg;           // True at the negedge of the PS2 clock
    assign ps2_clk_neg = ~ps2_clk_state[0] & ps2_clk_state[1];
    
    // Registers for data reading
    reg [3:0] read_state;
    reg [7:0] read_data;
    
    // Registers for special signals
    reg is_f0, is_e0;
    
    // Record the PS2 clock
    always @ (posedge clk or negedge rst)
        if (!rst)
            ps2_clk_state <= 2'b0;
        else
            ps2_clk_state <= {ps2_clk_state[0], ps2_clk};
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            read_state <= 4'b0;
            read_data <= 8'b0;
            
            is_f0 <= 1'b0;
            is_e0 <= 1'b0;
            crt_data <= 9'b0;
        end
        else if (ps2_clk_neg) begin
            // Reads in the data
            if (read_state > 4'b1001)
                read_state <= 4'b0;
            else begin
                if (read_state > 4'b0 && read_state < 4'b1001)
                    read_data[read_state - 1] <= ps2_data;
                read_state <= read_state + 1'b1;
            end
        end
        else if (read_state == 4'b1010 && |read_data) begin
            if (read_data == 8'hf0)
                is_f0 <= 1'b1;
            else if (read_data == 8'he0)
                is_e0 <= 1'b1;
            else
                if (is_f0) begin
                    // A key is released
                    is_f0 <= 1'b0;
                    is_e0 <= 1'b0;
                    crt_data <= 9'b0;
                end
                else if (is_e0) begin
                    is_e0 <= 1'b0;
                    crt_data <= {1'b1, read_data};
                end
                else
                    crt_data <= {1'b0, read_data};
            
            read_data <= 8'b0;
        end
    end
    
endmodule
*/