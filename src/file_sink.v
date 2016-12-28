`timescale 1ns/10ps

`include "actor_modules.v"

/* Number of steps */
`define STEP_COUNT 3

/* Let N be the maximum number of steps to advance the one-hot 
   state in a given transition. Then the "next" input to the one-hot
   takes on values in the range {0, 1, ..., N}, which requires
   (log(N) + 1) bits. NEXT_LENGTH is thus set to (log(N) + 1).
*/
/* N = 1 since we don't "skip" steps in any transition. */
`define NEXT_LENGTH 1

module file_sink(read, in, in_empty, clock, reset, enable_firing_reset);

    /* Bit width for inputs and output */
    parameter DATA_WIDTH = 8;

    /* Output file descriptor */
    parameter OUT_FILE = "";

    /* Read control for input FIFO */
    output read; 

    /* File sink input */

    input [DATA_WIDTH - 1 : 0] in;

    /* FIFO empty indicator. */
    input in_empty;

    /* Clock */
    input clock;

    /* system reset */
    input reset;

     /* Actor firing reset (0: reset by main controller, 1: self-timed) */
    input enable_firing_reset;

    /**************************************************************************
     Wires
    **************************************************************************/

    /* Current step (one hot) */
    wire [`STEP_COUNT - 1 : 0] state;

    /**************************************************************************
     Registers
    **************************************************************************/

    /* Next state "offset". The one-hot is advanced by shifting
       left by this many positions. Use next = 0 to stay in the current
       state.
    */
    reg [`NEXT_LENGTH - 1 : 0] next;

    /* Input to the FSM that reset the FSM to be in the initial state. */
    reg reset_new_firing;

    /* Parallel signal sent to both input FIFOs */
    reg read;

    /* Data ready to be read */
    //reg data_ready;
	
	integer output_count;
	reg write;

    /**************************************************************************
     Continuous assignments (Verilog dataflow modeling) 
    **************************************************************************/

    assign data_available = (~in_empty);

    integer file;

    initial begin
        file = $fopen(OUT_FILE, "w"); 
		read = 0; output_count = 0; write = 0;
    end

	always @(*) begin
		if (~reset && enable_firing_reset) begin
			read = 0;
			$fclose(file);
			file = $fopen(OUT_FILE, "w");
		end
		else begin
			//$display("XX %d %d %d %d %d %d %d", in, write, output_count, reset, enable_firing_reset, read, data_available);
			if (~read && write && output_count > 0) begin
				if (^in === 1'bX) begin
				//$fwrite(file, "%b\n", in);
				end
				else begin
				$fwrite(file, "%b\n", in);
				//$display("WRITING TO FILE: %d. write = %d, output_count = %d", in, write, output_count);
				end
			end
			
			if (data_available) begin
				read = 1;
			end
		end
	end
	
	always @(posedge clock or negedge reset) begin
		if (~reset && enable_firing_reset) begin
			output_count <= 0; write <= 0;
		end
		else begin
			read <= 0;
			if (data_available) begin
				output_count <= output_count + 1; write <= 1; 
			end
			else begin
				write <= 0;
			end
		end
	end

endmodule

