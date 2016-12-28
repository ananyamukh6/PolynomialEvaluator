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
N AN "AS IS" BASIS, AND THE UNIVERSITY OF
MARYLAND HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES,
ENHANCEMENTS, OR MODIFICATIONS.

@ddblock_end copyright
******************************************************************************/

`timescale 1ns/10ps

module testbench;

    reg signed[15:0] x;
    reg signed[15:0] coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0;
    wire [31:0] sum;


	evaluator eval1(sum, x, coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0);
	
    initial begin
        $monitor("%d,  x: %d, coef0: %d, coef1 :%d, coef2 : %d, coef3 : %d, sum: %d",
            $time, x, coeff0, coeff1, coeff2, coeff3, sum);
    #300 $finish;
	end

   initial begin		 
       #150
	   x = 16'b1111111111111110; coeff0 = 16'b1111111111111111; coeff1 = 16'd1; coeff2 = 16'd1; coeff3 = 0; coeff4 = 0; coeff5 = 0; coeff6 = 0; coeff7 = 0; coeff8 = 0; coeff9 = 0; coeff10 = 0;
        #150
		x = 16'd1;
		#150
		$finish;
    end
endmodule

