`timescale 1ns / 1ps

module Traffic_Light_Controller_TB;
    // Declare input signals (reg type) for the testbench
    reg clk, rst; 
    
    // Declare output signals (wire type) to monitor the state of the traffic lights
    wire [2:0] light_M1;   // Traffic light state for Main road 1
    wire [2:0] light_S;    // Traffic light state for Side road
    wire [2:0] light_MT;   // Traffic light state for Main road turning lane
    wire [2:0] light_M2;   // Traffic light state for Main road 2

    // Instantiate the Traffic Light Controller module (Device Under Test - DUT)
    Traffic_Light_Controller dut (
        .clk(clk), 
        .rst(rst), 
        .light_M1(light_M1), 
        .light_S(light_S), 
        .light_M2(light_M2), 
        .light_MT(light_MT)
    );

    // Initial block to generate clock signal
    initial begin
        clk = 1'b0;  // Initialize clock to 0
        
        // Dump file and variables for waveform analysis (for use with tools like GTKWave)
        $dumpfile("Traffic_Light_Controller_TB.vcd");  // Create dump file
        $dumpvars(0, Traffic_Light_Controller_TB);     // Dump all variables for waveform
        
        // Clock toggles every 0.5 seconds (500 million time units)
        forever #(1000000000 / 2) clk = ~clk;  // 1-second clock period
    end

    // Initial block to control reset and run the simulation
    initial begin
        rst = 0;           // Start with reset low (inactive)
        
        #1000000000;       // Wait for 1 second (1 billion time units)
        rst = 1;           // Activate reset (set high)
        
        #1000000000;       // Keep reset high for 1 second
        rst = 0;           // Deactivate reset (set low)
        
        // Run simulation for 10 seconds (10 billion time units)
        #(10000000000);    // Simulation time = 10 seconds
        
        $finish;           // End the simulation
    end

endmodule