`timescale 1ns / 1ps

module car_parking( 
    input clock_in, rst_in,
    input Front_Sensor, Back_Sensor, 
    input [1:0] pass_1, pass_2,
    output wire G_LED, R_LED,
    output reg [6:0] HEX_1, HEX_2
);

// Define states using parameter
parameter IDLE = 3'b000, 
          WAIT_PASSWORD = 3'b001, 
          WRONG_PASS = 3'b010, 
          RIGHT_PASS = 3'b011, 
          STOP = 3'b100;

// Registers for current and next state, wait counter, and LED control
reg [2:0] PS, NS;
reg [31:0] cnt_wait;
reg red_tmp, green_tmp;

// Next State Logic
always @(posedge clock_in or negedge rst_in) begin
    if (~rst_in)
        PS <= IDLE;    // Reset to IDLE state
    else
        PS <= NS;      // Move to next state
end

// Wait counter (used in WAIT_PASSWORD state)
always @(posedge clock_in or negedge rst_in) begin
    if (~rst_in)
        cnt_wait <= 0;
    else if (PS == WAIT_PASSWORD)
        cnt_wait <= cnt_wait + 1;
    else
        cnt_wait <= 0;
end

// State Transition Logic
always @(*) begin
    case (PS)
        IDLE: begin
            if (Front_Sensor == 1)
                NS = WAIT_PASSWORD;
            else
                NS = IDLE;
        end
        
        WAIT_PASSWORD: begin
            if (cnt_wait <= 3)
                NS = WAIT_PASSWORD;
            else if ((pass_1 == 2'b01) && (pass_2 == 2'b10))
                NS = RIGHT_PASS;
            else
                NS = WRONG_PASS;
        end
        
        WRONG_PASS: begin
            if ((pass_1 == 2'b01) && (pass_2 == 2'b10))
                NS = RIGHT_PASS;
            else
                NS = WRONG_PASS;
        end
        
        RIGHT_PASS: begin
            if (Front_Sensor == 1 && Back_Sensor == 1)
                NS = STOP;
            else if (Back_Sensor == 1)
                NS = IDLE;
            else
                NS = RIGHT_PASS;
        end
        
        STOP: begin
            if ((pass_1 == 2'b01) && (pass_2 == 2'b10))
                NS = RIGHT_PASS;
            else
                NS = STOP;
        end
        
        default: NS = IDLE;  // Default to IDLE state
    endcase
end

// LED control and 7-segment display logic
always @(posedge clock_in) begin
    case (PS)
        IDLE: begin
            green_tmp = 1'b0;
            red_tmp = 1'b0;
            HEX_1 = 7'b1111111; // Display off (all segments off)
            HEX_2 = 7'b1111111; // Display off (all segments off)
        end
        
        WAIT_PASSWORD: begin
            green_tmp = 1'b0;
            red_tmp = 1'b1;
            HEX_1 = 7'b000_0110; // Display 'E': 'E' indicates an "Enter" or error state, requesting user input.
            HEX_2 = 7'b010_1011; // Display 'n': 'n' can indicate "Enter now", signaling the user to input the password.
        end
        
        WRONG_PASS: begin
            green_tmp = 1'b0;
            red_tmp = ~red_tmp;  // Blink red LED: Indicates incorrect password attempt.
            HEX_1 = 7'b000_0110; // Display 'E': 'E' for "Error" (Incorrect password).
            HEX_2 = 7'b000_0110; // Display 'E': 'E' for "Error" (Incorrect password).
        end
        
        RIGHT_PASS: begin
            green_tmp = ~green_tmp;  // Blink green LED: Indicates correct password.
            red_tmp = 1'b0;
            HEX_1 = 7'b000_0010; // Display '6': Indicating success with an arbitrary number ('6' is often used as a success symbol in systems).
            HEX_2 = 7'b100_0000; // Display '0': Used with '6' to form "60", possibly indicating time or successful entry.
        end
        
        STOP: begin
            green_tmp = 1'b0;
            red_tmp = ~red_tmp;  // Blink red LED: Indicates the vehicle must stop (system is in STOP state).
            HEX_1 = 7'b001_0010; // Display '5': Can indicate that the car should stop or park.
            HEX_2 = 7'b000_1100; // Display 'P': 'P' stands for "Park", signaling the user to stop the vehicle.
        end
    endcase
end

// Assign LED outputs
assign R_LED = red_tmp;
assign G_LED = green_tmp;

endmodule