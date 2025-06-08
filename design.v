module Elevator_FSM (input clk,input rst,input [1:0] request_floor,   // Requested floor (00: Floor 1, 01: Floor 2, 10: Floor 3)
    output reg [1:0] current_floor, // Current floor (00: Floor 1, 01: Floor 2, 10: Floor 3)
    output reg [1:0] elevator_status // Status (00: Idle, 01: Moving Up, 10: Moving Down)
);
    typedef enum reg [2:0] {
        IDLE = 3'b000,
        FLOOR1 = 3'b001,
        FLOOR2 = 3'b010,
        FLOOR3 = 3'b011,
        MOVING_UP = 3'b100,
        MOVING_DOWN = 3'b101
    } state_t;
    state_t current_state, next_state;
    always @(posedge clk or posedge rst) begin // State transition logic
        if (rst) begin
            current_state <= FLOOR1;  // Initialize to Floor 1
            current_floor <= 2'b00;  // Start at Floor 1
            elevator_status <= 2'b00; // Start as Idle
        end else begin
            current_state <= next_state;
        end
    end
    always @(*) begin// Next-state logic and output logic
        next_state = current_state; // Default outputs
        elevator_status = 2'b00; // Default to Idle
        case (current_state)
            FLOOR1: begin
                current_floor = 2'b00; // Elevator is at Floor 1
                if (request_floor == 2'b01) begin
                    next_state = MOVING_UP;
                    elevator_status = 2'b01; // Moving Up
                end else if (request_floor == 2'b10) begin
                    next_state = MOVING_UP;
                    elevator_status = 2'b01; // Moving Up
                end
            end
            FLOOR2: begin
                current_floor = 2'b01; // Elevator is at Floor 2
                if (request_floor == 2'b00) begin
                    next_state = MOVING_DOWN;
                    elevator_status = 2'b10; // Moving Down
                end else if (request_floor == 2'b10) begin
                    next_state = MOVING_UP;
                    elevator_status = 2'b01; // Moving Up
                end
            end
            FLOOR3: begin
                current_floor = 2'b10; // Elevator is at Floor 3
                if (request_floor == 2'b01) begin
                    next_state = MOVING_DOWN;
                    elevator_status = 2'b10; // Moving Down
                end else if (request_floor == 2'b00) begin
                    next_state = MOVING_DOWN;
                    elevator_status = 2'b10; // Moving Down
                end
            end
            MOVING_UP: begin
                elevator_status = 2'b01; // Moving Up
                if (current_floor < request_floor) begin
                    current_floor = current_floor + 1'b1; // Move Up
                end else begin
                    if (current_floor == 2'b01) next_state = FLOOR2;
                    else if (current_floor == 2'b10) next_state = FLOOR3;
                end
            end
            MOVING_DOWN: begin
                elevator_status = 2'b10; // Moving Down
                if (current_floor > request_floor) begin
                    current_floor = current_floor - 1'b1; // Move Down
                end else begin
                    if (current_floor == 2'b00) next_state = FLOOR1;
                    else if (current_floor == 2'b01) next_state = FLOOR2;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
endmodule
