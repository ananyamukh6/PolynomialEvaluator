`timescale 1ns/10ps
//`include "myGlbl.v"

/* 2-input nor gate with resource counter and time delay
 */
module my_nor(y, a, b);
  output y;
  input a, b;
  wire y;
  
  //initial begin
  //$display("hello nor\n");
  //end
  
  nor (y,a,b);

  //global_vars gv;
  //global_vars.count = global_vars.count+1;

  /* at instantiation increment the resources used */
 

  /* add 2ns inherent delay */

endmodule

/* 2-input and gate using my_nor
 */

module my_and(y, a, b);
  output y;
  input a, b;
  wire r1,r2;
  my_nor n1(r1,a,a);
  my_nor n2(r2,b,b);
  my_nor n3(y,r1,r2);
endmodule

/* 3-input and gate using my_and
 */

module my_and3(y, a, b, c);
  output y;
  input a, b, c;
  wire r1,y;
  my_and a1(r1,a,b);
  my_and a2(y,r1,c);
endmodule

/* 4-input and gate using my_and
 */

module my_and4(y, a, b, c, d);
  output y;
  input a, b, c, d;
  wire r1,r2,y;
  my_and a1(r1,a,b);
  my_and a2(r2,c,d);
  my_and a3(y,r1,r2);
  
endmodule

/* 2-input or gate using my_nor
 */

module my_or(y, a, b);
  output y;
  input a, b;
  wire y,r1;
  my_nor n1(r1,a,b);
  my_nor n2(y,r1,r1);
endmodule

/* 3-input or gate using my_or
 */

module my_or3(y, a, b, c);
  output y;
  input a, b, c;
  wire y,r1;
  my_or o1(r1,a,b);
  my_or o2(y,c,r1);

endmodule

/* 4-input or gate using my_or
 */

module my_or4(y, a, b, c, d);
  output y;
  input a, b, c, d;
  wire r1,r2,y;
  my_or o1(r1,a,b);
  my_or o2(r2,c,d);
  my_or o3(y,r1,r2);
endmodule

/* 2-input xor gate using my_nor
 */

module my_xor(y, a, b);
  output y;
  input a, b;
  wire r1,r2,r3,r4,y;
  my_nor n1(r1,a,a);
  my_nor n2(r2,b,b);
  my_nor n3(r3,a,b);
  my_nor n4(r4,r1,r2);
  my_nor n5(y,r4,r3);

endmodule

/*8 bit multiplier
*/

module mult(mult_out, sample, coeff);
input [7:0] sample, coeff;
output [15:0] mult_out;
integer i;
reg [15:0] mult_out;

always@(*) begin
//mult_out = sample*coeff;
mult_out = 0;
for (i = 0; i < 8; i = i + 1)
begin
	if (coeff[i])
		mult_out = mult_out + (sample<<i);
end
end
endmodule

module mult32(mult_out, x, coeff);
	input [31:0] x, coeff;
	output[31:0] mult_out;
	integer i;
	reg [31:0] mult_out, x_reg, c_reg;
	wire neg;
	
	//assign neg = (x[31]^coeff[31]);
	//assign mult_out[31] = 0; //neg;
	//assign mult_out[30:0] = mult_out1;
	
	always@(x or coeff) begin
/*
		if (x[31]) //negative, need to invert and add one
			assign x_reg = ~x[30:0] + 'b1;
		else
			assign x_reg = x[30:0];
		if (coeff[31])
			assign c_reg = ~coeff[30:0] + 'b1;
		else
			assign c_reg = coeff[30:0];
		 //even though these have flipped the logic will be the same.
*/		
		mult_out = coeff * x;
		$display ("x = %d, coeff = %d, mult_out = %d", x, coeff, mult_out);
		//for (i = 0; i < 31; i = i + 1)
		//	begin
		//		if (c_reg[i])
		//			mult_out1 = mult_out1 + (x<<i);
		//	end

/*
		if (neg) //if output should be neg, take two's complement
			mult_out1 = ~(mult_out1+ 'b1);
*/

	end
	
endmodule

module add32(out, a, b);
	input [31:0] a,b;
	output [31:0] out;
	reg[30:0] a_reg, b_reg, out_reg, out_reg1;
	reg neg1;
	wire neg;
	assign out = a;
	/*
	assign neg = a[31]^b[31];
	assign out[31] = neg1;
	assign out[30:0] = out_reg1;
	
	always@(*) begin
		if (a[31]) //negative, need to invert and add one
			assign a_reg = ~a[30:0] + 'b1;
		else
			assign a_reg = a[30:0];
		if (b[31])
			assign b_reg = ~b[30:0] + 'b1;
		else
			assign b_reg = b[30:0];

		if (neg) begin //if only one number is neg, subtract
			if (a_reg > b_reg)
			begin
				assign out_reg = a_reg - b_reg;
				if (a[31])	//if bigger number is neg, out is neg
				begin
					assign out_reg1 = ~(out_reg + 'b1);
					assign neg1 = 1;
				end
				else
				begin
					assign out_reg1 = out_reg;
					assign neg1 = 0;
				end
			end
			if (b_reg > a_reg) 
			begin
				assign out_reg = b_reg - a_reg;
				if (b[31]) //if bigger number is neg, out is neg
				begin
					assign out_reg1 = ~(out_reg + 'b1);
					assign neg1 = 1;
				end
				else
				begin
					assign out_reg1 = out_reg;
					assign neg1 = 0;
				end
			end
			if (b_reg == a_reg)
			begin
				assign out_reg = 31'b0;
				assign out_reg1 = out_reg;
				assign neg1 = 0;
			end
		end
		else begin	//else add them together, if both are neg, make two's complement
			out_reg = a_reg + b_reg;
			if (a[31])
			begin
				assign out_reg1 = ~(out_reg + 'b1);
				assign neg1 = 1;
			end
			else
			begin
				assign out_reg1 = out_reg;
				assign neg1 = 0;
			end
		end
	end
			
		*/
	
endmodule

module split(out, in);
input in;
output [15:0] out;

assign out[15] = in;
assign out[14] = in;
assign out[13] = in;
assign out[12] = in;
assign out[11] = in;
assign out[10] = in;
assign out[9] = in;
assign out[8] = in;
assign out[7] = in;
assign out[6] = in;
assign out[5] = in;
assign out[4] = in;
assign out[3] = in;
assign out[2] = in;
assign out[1] = in;
assign out[0] = in;

endmodule