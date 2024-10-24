`timescale 1ns / 1ps

module Traffic_Light_Controller(
    input clk,  // Clock input for synchronization
    input rst,  // Reset signal to reset the system
    output reg [2:0] light_M1,  // Output for main road 1 traffic light
    output reg [2:0] light_S,   // Output for side road traffic light
    output reg [2:0] light_MT,  // Output for main road turning lane light
    output reg [2:0] light_M2   // Output for main road 2 traffic light
);

// State definitions for the finite state machine (FSM)
parameter S1 = 0, S2 = 1, S3 = 2, S4 = 3, S5 = 4, S6 = 5;

// Time intervals for each state in seconds (as counters)
parameter sec7 = 7, sec5 = 5, sec2 = 2, sec3 = 3;

// Variables for counting clock cycles and storing current state
reg [3:0] count;  // Counter to control how long the lights stay in a particular state
reg [2:0] ps;     // Current state (ps: present state)

// FSM (Finite State Machine) for controlling traffic lights
always @(posedge clk or posedge rst) begin
    if (rst == 1) begin
        ps <= S1;   // On reset, go to state S1
        count <= 0; // Reset the counter
    end
    else begin
        // State transition logic based on current state and counter
        case(ps)
            S1: if (count < sec7) begin
                    ps <= S1;        // Stay in state S1 for sec7 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S2;        // Move to state S2 after sec7 seconds
                    count <= 0;      // Reset counter
                end
            S2: if (count < sec2) begin
                    ps <= S2;        // Stay in state S2 for sec2 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S3;        // Move to state S3 after sec2 seconds
                    count <= 0;
                end
            S3: if (count < sec5) begin
                    ps <= S3;        // Stay in state S3 for sec5 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S4;        // Move to state S4 after sec5 seconds
                    count <= 0;
                end
            S4: if (count < sec2) begin
                    ps <= S4;        // Stay in state S4 for sec2 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S5;        // Move to state S5 after sec2 seconds
                    count <= 0;
                end
            S5: if (count < sec3) begin
                    ps <= S5;        // Stay in state S5 for sec3 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S6;        // Move to state S6 after sec3 seconds
                    count <= 0;
                end
            S6: if (count < sec2) begin
                    ps <= S6;        // Stay in state S6 for sec2 seconds
                    count <= count + 1;
                end
                else begin
                    ps <= S1;        // Move to state S1 after sec2 seconds (cycle restarts)
                    count <= 0;
                end
            default: ps <= S1;        // Default to state S1 if any unknown state occurs
        endcase
    end
end

// Output logic to control the traffic lights based on the current state
always @(ps) begin
    case (ps)
        S1: begin
            light_M1 <= 3'b001;  // Green light for main road 1
            light_M2 <= 3'b001;  // Green light for main road 2
            light_MT <= 3'b100;  // Red light for main road turn
            light_S  <= 3'b100;  // Red light for side road
        end
        S2: begin
            light_M1 <= 3'b001;  // Green light for main road 1
            light_M2 <= 3'b010;  // Yellow light for main road 2
            light_MT <= 3'b100;  // Red light for main road turn
            light_S  <= 3'b100;  // Red light for side road
        end
        S3: begin
            light_M1 <= 3'b001;  // Green light for main road 1
            light_M2 <= 3'b100;  // Red light for main road 2
            light_MT <= 3'b001;  // Green light for main road turn
            light_S  <= 3'b100;  // Red light for side road
        end
        S4: begin
            light_M1 <= 3'b010;  // Yellow light for main road 1
            light_M2 <= 3'b100;  // Red light for main road 2
            light_MT <= 3'b010;  // Yellow light for main road turn
            light_S  <= 3'b100;  // Red light for side road
        end
        S5: begin
            light_M1 <= 3'b100;  // Red light for main road 1
            light_M2 <= 3'b100;  // Red light for main road 2
            light_MT <= 3'b100;  // Red light for main road turn
            light_S  <= 3'b001;  // Green light for side road
        end
        S6: begin
            light_M1 <= 3'b100;  // Red light for main road 1
            light_M2 <= 3'b100;  // Red light for main road 2
            light_MT <= 3'b100;  // Red light for main road turn
            light_S  <= 3'b010;  // Yellow light for side road
        end
        default: begin
            light_M1 <= 3'b000;  // All lights off (default state)
            light_M2 <= 3'b000;
            light_MT <= 3'b000;
            light_S  <= 3'b000;
        end
    endcase
end

endmodule