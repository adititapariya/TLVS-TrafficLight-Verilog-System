`timescale 1ns / 1ps

module Traffic_Light_Controller(
    input clk,  // Clock input for synchronization
    output reg [2:0] light_M1,  // Output for main road 1 traffic light
    output reg [2:0] light_S,   // Output for side road traffic light
    output reg [2:0] light_MT,  // Output for main road turning lane light
    output reg [2:0] light_M2   // Output for main road 2 traffic light
);

// State definitions for the finite state machine (FSM)
parameter S1 = 0, S2 = 1, S3 = 2, S4 = 3, S5 = 4, S6 = 5;

// Timing parameters for 50 MHz clock
    parameter sec7 = 50_000_000 * 7;  // 7 seconds
    parameter sec5 = 50_000_000 * 5;  // 5 seconds
    parameter sec2 = 50_000_000 * 2;  // 2 seconds
    parameter sec3 = 50_000_000 * 3;  // 3 seconds

    // Registers
    reg [31:0] count;  // Counter (32-bit to handle large values)
    reg [2:0] ps;      // Current state (ps: present state)

// FSM (Finite State Machine) for controlling traffic lights
always @(posedge clk) begin
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
        endcase
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
    endcase
end

endmodule