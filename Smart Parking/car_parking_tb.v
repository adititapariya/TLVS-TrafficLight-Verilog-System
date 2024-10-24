`timescale 1ns / 1ps

module car_parking_tb;

  // Inputs
  reg clock_in;
  reg rst_in;
  reg Front_Sensor;
  reg Back_Sensor;
  reg [1:0] pass_1;
  reg [1:0] pass_2;

  // Outputs
  wire G_LED;
  wire R_LED;
  wire [6:0] HEX_1;
  wire [6:0] HEX_2;

  // Instantiate the Unit Under Test (UUT)
  car_parking uut (
    .clock_in(clock_in), 
    .rst_in(rst_in), 
    .Front_Sensor(Front_Sensor), 
    .Back_Sensor(Back_Sensor), 
    .pass_1(pass_1), 
    .pass_2(pass_2), 
    .G_LED(G_LED), 
    .R_LED(R_LED), 
    .HEX_1(HEX_1), 
    .HEX_2(HEX_2)
  );

  // Clock generation: toggle clock_in every 10 time units
  initial begin
    clock_in = 0;
    forever #10 clock_in = ~clock_in;  // Toggle clock every 10 ns
  end

  // Dump waveform file for simulation analysis
  initial begin
    $dumpfile("car_parking_tb.vcd");  // Create dump file for waveform viewing
    $dumpvars(0, car_parking_tb);     // Dump all variables from the testbench for waveform
  end

  // Test stimulus
  initial begin
    // Initialize Inputs
    rst_in = 0;
    Front_Sensor = 0;
    Back_Sensor = 0;
    pass_1 = 0;
    pass_2 = 0;

    // Wait 100 ns for global reset to finish
    #100;
    rst_in = 1;   // Release reset
    #20;

    // Test Case 1: Car approaches the parking (Front Sensor triggered)
    Front_Sensor = 1;
    #1000;

    // Test Case 2: Input correct passcodes
    Front_Sensor = 0;
    pass_1 = 2'b01;  // Correct password part 1
    pass_2 = 2'b10;  // Correct password part 2
    #2000;

    // Test Case 3: Car starts parking (Back Sensor triggered)
    Back_Sensor = 1;
    #100;

    // Test Case 4: Car tries to exit the parking
    Front_Sensor = 1;
    #1000;

    // Test Case 5: Incorrect password attempt 1
    Back_Sensor = 0;
    Front_Sensor = 1;
    pass_1 = 2'b11;  // Incorrect password part 1
    pass_2 = 2'b00;  // Incorrect password part 2
    #2000;

    // Test Case 6: Incorrect password attempt 2 (Both wrong)
    pass_1 = 2'b10;  // Another incorrect combination
    pass_2 = 2'b01;
    #2000;

    // Test Case 7: Correct password after wrong attempts
    pass_1 = 2'b01;  // Correct password part 1
    pass_2 = 2'b10;  // Correct password part 2
    #2000;

    // Test Case 8: Front and Back sensors triggered (Car enters, parks, and leaves)
    Front_Sensor = 1;
    #1000;
    Back_Sensor = 1;  // Car parks
    #100;
    Back_Sensor = 0;  // Car starts leaving
    #500;
    Front_Sensor = 0;  // Car leaves
    #1000;

    // Test Case 9: Reset test
    rst_in = 0;  // Simulate system reset
    #50;
    rst_in = 1;  // System resumes
    Front_Sensor = 1;
    pass_1 = 2'b01;
    pass_2 = 2'b10;
    #1000;

    // End simulation
    $finish;
  end

endmodule