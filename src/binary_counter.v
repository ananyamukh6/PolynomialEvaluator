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

/* A binary counter with 4-bit as the default setting.
 */

module binary_counter (out, en, clk, reset);
    /**************************************************************************
     Parameters
    **************************************************************************/

    /* Counter width */
    parameter WIDTH = 4;

    /**************************************************************************
     Ports
    **************************************************************************/

    /* Counter output */
    output [WIDTH-1:0] out;

    /* Counter enable */
    input en;    

    /* Reset */
    input reset;

    /* Clock */
    input clk;

    /**************************************************************************
     Registers
    **************************************************************************/

    /* Counter registers */
    reg [WIDTH-1:0] out;

	/* Behavioral modeling: this describes the behavior of this up binary
	   counter.  The counter will count, when the positive edge of clock and en
	   signal is on, from 0 up to 2^WDITH - 1. When the counter value past the
	   max value, it will be counted from 0 again, which makes it as modulo
	   behavior. 
	 */
    always @(posedge clk or negedge reset) begin
        if (~reset)
            out <= 0;
	else if (en)
            out <= out + 1;
    end    
endmodule

