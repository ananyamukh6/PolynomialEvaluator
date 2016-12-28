`timescale 1ns/10ps

/* Step transition controller. This is a one hot state machine
   with STEP_COUNT bits used to store the state. Each state
   corresponds to a unique bit in the state storage. The next
   inputs gives the number of bits to "left_shift" the state.
   Thus next = N means that we want to "skip" N-1 states, and next = 0
   means that we stay in the same state. This state machine is positive
   edge triggered on the given clock. 

   The reset signal provides an active-low, synchronous reset to the
   state that has the 1 value in the least significant bit position
   of the state storage.
*/
module actor_controller(state, next, clock, reset); 
    parameter STEP_COUNT = 1;
    parameter NEXT_LENGTH = 1;

    output [STEP_COUNT - 1 : 0] state;

    input [NEXT_LENGTH - 1 : 0] next;
    input clock;
    input reset;

    reg [STEP_COUNT - 1 : 0] state;

    always @(posedge clock or negedge reset) begin
        if (~reset) begin
            state <= 1;
        end
        else begin
            state <= state << next;
        end
    end
endmodule
