
`timescale 1ns/10ps

`include "actor_modules.v"

/* Common actor steps */
`define ACTOR_RESET 4'b0001

/* Number of steps */
`define STEP_COUNT 4

/* Let N be the maximum number of steps to advance the one-hot 
   state in a given transition. Then the "next" input to the one-hot
   takes on values in the range {0, 1, ..., N}, which requires
   (log(N) + 1) bits. NEXT_LENGTH is thus set to (log(N) + 1).
*/
`define NEXT_LENGTH 2

/* Steps that are specific to this actor */

`define FILE_SOURCE_VALUE_READ  4'b0010
`define FILE_SOURCE_FIRING_DONE 4'b0100
`define FILE_SOURCE_INACTIVE    4'b1000

module file_source(out, write, out_full, clock, reset, enable_firing_reset);


    /* Bit width for inputs and output */
    parameter DATA_WIDTH = 8;

    /* Input file descriptor */
    parameter IN_FILE = "";


    /* File source output */
    output [DATA_WIDTH - 1 : 0] out;

    /* Write control for output FIFO */
    output write; 

    /* FIFO full indicator. */
    input out_full;

    /* Clock */
    input clock;

    /* System reset */
    input reset;
	
	input enable_firing_reset;
	
	reg [DATA_WIDTH - 1 : 0] out;
	reg write;
	reg [DATA_WIDTH - 1 : 0]  value;
	reg done_reading_file;
	integer output_count, file, status;

	assign output_ready = (~out_full);
  
	initial begin
        file = $fopen(IN_FILE, "r");
		output_count = 0;
		done_reading_file = 0;
    end
	
	always @(*) begin
		//$display("HERE x  feof %d output_ready %d output_count %d  ..  done_reading_file %d", $feof(file), output_ready, output_count, done_reading_file);
		if (~reset && enable_firing_reset) begin
			done_reading_file = 0;
		end
		else begin
			if (output_ready && output_count>=0) begin  //adding output_count to keep it in sensitivity list
				//$display("HERE feof %d  ~$feof(file) %d", $feof(file), $feof(file)==0);
				if ($feof(file)==0) begin  //note: since feof(file) yields an integer, dont operate it using ~feof (bitwise not). use logical operators instead 
					status = $fscanf(file, "%b", value);
					//$display("Reading from file ", value);
					done_reading_file = 0;
				end
				else begin
					done_reading_file = 1;
				end
			end
		end
	end
	
	always @(posedge clock or negedge reset) begin
		if (~reset && enable_firing_reset) begin
            write <= 0;
			$fclose(file);
			file = $fopen(IN_FILE, "r");
        end
		else begin
			if (~done_reading_file) begin
				if (output_ready) begin
					//$display("in clk block: value %d", value);
					out <= value; write <= 1; output_count <= output_count + 1; //output count changes, causing always(*) to reevaluate and read in a new value
				end
				else begin
					write <= 0;
				end
			end
			else begin
				write <= 0;
			end
		end
	end
	
  
endmodule

