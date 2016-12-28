-------------------------------------------------------------------------------
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

@author "Scotty Kenney and Ananya Mukherjee"
-------------------------------------------------------------------------------

A complex test of all functionality combined. 
STP loads 3x^2 + 2x + 1 into SA = 0.
EVP calculates CV's in 0 with x = 7. ==> Yields 162
RST occurs removing SA = 0
STP loads x^4 + 2x^3 + 3x^2 + 4 + 1 into SA = 6.
EVP calculates CV's in 6 with x = 7. ==> Yields 3935
EVB calculates CV"s in 6 with -1, 5, 0, 3, 1, 2, 4 ==> -1, 1211, 1, 223, 11, 65, 569
