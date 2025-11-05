//
// === NEW traffic_fsm.v (Sets Red Time) ===
//
module traffic_fsm(
    input wire clk,
    input wire reset,
    input wire tick,
    input wire set_mode,
    input wire inc_A,
    input wire dec_A,
    input wire inc_B,
    input wire dec_B,
    output reg [2:0] A_light,
    output reg [2:0] B_light,
    output reg [3:0] counter_A,
    output reg [3:0] counter_B,
    // These outputs are now DERIVED from the red time
    output reg [3:0] green_time_A,
    output reg [3:0] green_time_B
);

// --- Fixed Colors (to match XDC) ---
localparam RED    = 3'b100;
localparam YELLOW = 3'b110;
localparam GREEN  = 3'b010;
// ------------------------------------

localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
reg [1:0] state;

// --- Use your new default times ---
localparam Y_TIME = 4'd2; // Yellow time is 2
localparam G_TIME_DEFAULT = 4'd3; // Green time default is 3
localparam R_TIME_DEFAULT = 4'd5; // Red time default is 5 (3+2)

// Registers for set mode
reg inc_A_prev, dec_A_prev, inc_B_prev, dec_B_prev;

// --- Renamed Registers ---
// We now store the RED time settings
reg [3:0] red_time_A; // This is the time A is RED
reg [3:0] red_time_B; // This is the time B is RED
reg [3:0] red_time_temp_A;
reg [3:0] red_time_temp_B;
// -------------------------


always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= S0;
        
        // --- Initialize with Red Time defaults ---
        red_time_A <= R_TIME_DEFAULT;
        red_time_temp_A <= R_TIME_DEFAULT;
        red_time_B <= R_TIME_DEFAULT;
        red_time_temp_B <= R_TIME_DEFAULT;

        // Derive and store initial green times
        green_time_A <= R_TIME_DEFAULT - Y_TIME; // 5 - 2 = 3
        green_time_B <= R_TIME_DEFAULT - Y_TIME; // 5 - 2 = 3
        
        // --- Set initial counter values ---
        counter_A <= G_TIME_DEFAULT; // A starts Green (3s)
        counter_B <= R_TIME_DEFAULT; // B starts Red (5s)
        
        inc_A_prev <= 1'b0; dec_A_prev <= 1'b0;
        inc_B_prev <= 1'b0; dec_B_prev <= 1'b0;
    end else begin
        // Store previous button state for edge detection
        inc_A_prev <= inc_A; dec_A_prev <= dec_A;
        inc_B_prev <= inc_B; dec_B_prev <= dec_B;
        
        if (set_mode) begin
            // --- New Set Mode Logic (Modifies RED time) ---
            
            // Control Time A (LED 4 / 7-seg-0)
            if (inc_A && !inc_A_prev && (red_time_temp_A < 4'd15)) 
                red_time_temp_A <= red_time_temp_A + 1;
            // Min red time must be > Y_TIME + 1 (min green=1)
            if (dec_A && !dec_A_prev && (red_time_temp_A > (Y_TIME + 1))) 
                red_time_temp_A <= red_time_temp_A - 1;
                
            // Control Time B (LED 5 / 7-seg-1)
            if (inc_B && !inc_B_prev && (red_time_temp_B < 4'd15)) 
                red_time_temp_B <= red_time_temp_B + 1;
            if (dec_B && !dec_B_prev && (red_time_temp_B > (Y_TIME + 1)))
                red_time_temp_B <= red_time_temp_B - 1;

            // Display current RED time settings
            counter_A <= red_time_temp_A;
            counter_B <= red_time_temp_B;

        end else begin
            // --- Running Mode ---
            
            // Apply new times when exiting set mode
            if (red_time_A != red_time_temp_A || red_time_B != red_time_temp_B) begin
                 red_time_A <= red_time_temp_A;
                 red_time_B <= red_time_temp_B;

                 // **Derive and store the new green times**
                 green_time_A <= red_time_temp_B - Y_TIME;
                 green_time_B <= red_time_temp_A - Y_TIME;

                 // Reset state machine with new times
                 state <= S0; 
                 counter_A <= red_time_temp_B - Y_TIME; // New Green A
                 counter_B <= red_time_temp_B;         // New Red B
            end

            if (tick) begin // No pause logic
                
                // Count both counters down
                if (counter_A > 4'd0) 
                    counter_A <= counter_A - 1;
                if (counter_B > 4'd0)
                    counter_B <= counter_B - 1;

                // State transition logic
                if (counter_A == 4'd1 || counter_B == 4'd1) begin 
                    case (state)
                        S0: begin // A=Green, B=Red
                                state <= S1;
                                counter_A <= Y_TIME; // Load A with Yellow
                           end
                        S1: begin // A=Yellow, B=Red
                                state <= S2;
                                counter_A <= red_time_A; // Load A with Red
                                counter_B <= green_time_B; // Load B with Green
                           end
                        S2: begin // A=Red, B=Green
                                state <= S3;
                                counter_B <= Y_TIME; // Load B with Yellow
                           end
                        S3: begin // A=Red, B=Yellow
                                state <= S0;
                                counter_B <= red_time_B; // Load B with Red
                                counter_A <= green_time_A; // Load A with Green
                           end
                    endcase
                end
            end
        end
    end
end

// Combinational logic for lights is unchanged
always @(*) begin
    case (state)
        S0: begin A_light = GREEN;  B_light = RED; end
        S1: begin A_light = YELLOW; B_light = RED; end
        S2: begin A_light = RED;    B_light = GREEN; end
        S3: begin A_light = RED;    B_light = YELLOW; end
        default: begin A_light = RED; B_light = RED; end
    endcase
end
endmodule