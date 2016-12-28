/******************************************************************************
@ddblock_begin copyright

Copyright (c) 1999-2010
Maryland DSPCAD Research Group, The University of Maryland at College Park

Permission is hereby granted, without written agreement and without
license or royalty fees, to use, copy, modify, and distribute this
software and its documentation for any purpose, provided that the above
copyright notice and the following two paragraphs appear in all copies
of this software.

IN NO EVENT SHALL THE UNIVERSITY OF MARYLAND BE LIABLE TO ANY PARTY
FOR DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES
ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF
THE UNIVERSITY OF MARYLAND HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.

THE UNIVERSITY OF MARYLAND SPECIFICALLY DISCLAIMS ANY WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE SOFTWARE
PROVIDED HEREUNDER IS ON AN "AS IS" BASIS, AND THE UNIVERSITY OF
MARYLAND HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.

@ddblock_end copyright
******************************************************************************/
`timescale 1ns/10ps

/* A mixed-clock FIFO based on the original design from
 * http://asic-soc.blogspot.com/
 */

module fifo (out_data, full, empty, in_data, r_en, w_en, r_clk, w_clk, reset);

    parameter DATA_WIDTH = 8;
    parameter CAPACITY = 8;
    parameter PTR_WIDTH = 3;

    output [DATA_WIDTH-1:0] out_data;
    output full;
    output empty;

    input [DATA_WIDTH-1:0] in_data;
    input r_en;
    input w_en;
    input r_clk;
    input w_clk;
    input reset;

    reg [DATA_WIDTH-1:0] out_data;
    reg r_next_en;
    reg w_next_en;
    reg [PTR_WIDTH-1:0] ptr_diff;
    reg signed[DATA_WIDTH-1:0] memory[CAPACITY-1:0];

    wire [PTR_WIDTH-1:0] r_ptr;
    wire [PTR_WIDTH-1:0] w_ptr;

    assign full = (ptr_diff == (CAPACITY-1));
    assign empty = (ptr_diff == 0);

    /* write data to the memory */
    always @(posedge w_clk) begin 
        if (w_en && (!full)) begin
            memory[w_ptr] <= in_data; 
	end
    end

    /* read data from the memory */
    always @(posedge r_clk or negedge reset) begin
	if (~reset)
            out_data <= 0;
	else if (r_en) begin
	    out_data <= memory[r_ptr]; 
        memory[r_ptr] <= 'bx;
        //$display("HERE1 r_ptr %d", r_ptr);
	end
	else 
	    out_data <= 0;
    end

    /* update ptr_diff */
    always @(*) begin
	if (w_ptr > r_ptr)
	    ptr_diff <= w_ptr - r_ptr;
	else if (w_ptr < r_ptr)
	    ptr_diff <= (CAPACITY - r_ptr) + w_ptr;
	else 
	    ptr_diff <= 0;
    end


    /* update read pointer */
    always @(*) begin
	if (r_en && (!empty))
	    r_next_en <= 1;
	else 
	    r_next_en <= 0;
    end

    /* update write pointer */
    always @(*) begin
        if (w_en && (!full))
	    w_next_en <= 1;
	else 
	    w_next_en <= 0;
    end

    binary_counter #(.WIDTH(PTR_WIDTH)) rbc(r_ptr, r_next_en, r_clk, reset);
    binary_counter #(.WIDTH(PTR_WIDTH)) wbc(w_ptr, w_next_en, w_clk, reset);

endmodule
