`timescale 1ns / 1ps
module Elevator_FSM_tb;
    reg clk;
    reg rst;
    reg [1:0] request_floor;
    wire [1:0] current_floor;
    wire [1:0] elevator_status;
    Elevator_FSM uut (
        .clk(clk),
        .rst(rst),
        .request_floor(request_floor),
        .current_floor(current_floor),
        .elevator_status(elevator_status)
    );
    always #5 clk = ~clk; 
    initial begin
        $dumpfile("dumpfile.vcd");
    	$dumpvars(1);
        clk = 0;
        rst = 1;
        request_floor = 2'b00; // Default floor 1
        #20;
        rst = 0;
        // Test Case 1: Request Floor 2 from Floor 1
        request_floor = 2'b01;
        #100;
        // Test Case 2: Request Floor 3 from Floor 2
        request_floor = 2'b10;
        #100;
        // Test Case 3: Request Floor 1 from Floor 3
        request_floor = 2'b00;
        #100;
        // Test Case 4: Stay Idle on Floor 1
        request_floor = 2'b00;
        #50;
        // Test Case 5: Reset the system
        rst = 1;
        #20;
        rst = 0;
        $finish;
    end
    initial begin
      $monitor("Time=%d, Request=%b, Current_Floor=%b, Status=%b", $time, request_floor, current_floor, elevator_status);
    end
endmodule
