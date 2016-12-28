module evaluator(sum, x, coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0);
	output[31:0] sum;
	input[15:0] x;
	input[15:0] coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0;
	reg signed[15:0] x_reg;
	reg signed[15:0] c10, c9, c8, c7, c6, c5, c4 ,c3, c2, c1, c0;
	reg [31:0] final_v, store;
	
	//assign sum = (coeff10*(x**10))+(coeff9*(x**9))+(coeff8*(x**8))+(coeff7*(x**7))+(coeff6*(x**6))+(coeff5*(x**5))+(coeff4*(x**4))+(coeff3*(x**3))+(coeff2*(x**2))+(coeff1*x)+coeff0;
	//assign sum = (c10*(x_reg**10))+(c9*(x_reg**9))+(c8*(x_reg**8))+(c7*(x_reg**7))+(c6*(x_reg**6))+(c5*(x_reg**5))+(c4*(x_reg**4))+(c3*(x_reg**3))+(c2*(x_reg**2))+(c1*(x_reg))+c0;
	assign sum = final_v;
always@(*) begin
	store = 0;
	/*
	if (x[15])begin
		x_reg[14:0]=~x[14:0] + 'b1;
		x_reg[15] = 1;
	end
	else
		x_reg = x;
	
	if (coeff10[15])begin
		c10[14:0] = ~coeff10[14:0] + 'b1;
		c10[15] = 1;
		store = 
	end
	else
		c10 = coeff10;
	if (coeff9[15])begin
		c9[14:0] = ~coeff9[14:0] + 'b1;
		c9[15] = 1;
	end
	else
		c9 = coeff9;
	if (coeff8[15])begin
		c8[14:0] = ~coeff8[14:0] + 'b1;
		c8[15] = 1;
	end
	else
		c8 = coeff8;
	if (coeff7[15])begin
		c7[14:0] = ~coeff7[14:0] + 'b1;
		c7[15] = 1;
	end
	else
		c7 = coeff7;
	if (coeff6[15])begin
		c6[14:0] = ~coeff6[14:0] + 'b1;
		c6[15] = 1;
	end
	else
		c6 = coeff6;
	if (coeff5[15])begin
		c5[14:0] = ~coeff5[14:0] + 'b1;
		c5[15] = 1;
	end
	else
		c5 = coeff5;
	if (coeff4[15])begin
		c4[14:0] = ~coeff4[14:0] + 'b1;
		c4[15] = 1;
	end
	else
		c4 = coeff4;
	if (coeff3[15])begin
		c3[14:0] = ~coeff3[14:0] + 'b1;
		c3[15] = 3;
	end
	else
		c3 = coeff3;
	if (coeff2[15])begin
		c2[14:0] = ~coeff2[14:0] + 'b1;
		c2[15] = 1;
	end
	else
		c2 = coeff2;
	if (coeff1[15])begin
		c1[14:0] = ~coeff1[14:0] + 'b1;
		c1[15] = 1;
	end
	else
		c1 = coeff1;
	if (coeff0[15])begin
		c0[14:0] = ~coeff0[14:0] + 'b1;
		c0[15] = 1;
	end
	else
		c0 = coeff0;
*/
	c0 = coeff0;
	c1 = coeff1;
	c2 = coeff2;
	c3 = coeff3;
	c4 = coeff4;
	c5 = coeff5;
	c6 = coeff6;
	c7 = coeff7;
	c8 = coeff8;
	c9 = coeff9;
	c10 = coeff10;
	x_reg = x;
	store = (c10*(x_reg**10))+(c9*(x_reg**9))+(c8*(x_reg**8))+(c7*(x_reg**7))+(c6*(x_reg**6))+(c5*(x_reg**5))+(c4*(x_reg**4))+(c3*(x_reg**3))+(c2*(x_reg**2))+(c1*(x_reg))+c0;
	//if (store[31]) begin // convert back to 2's complimenet
	//	final[30:0] = ~store[30:0] + 'b1;
	//	final[31] = 1;
	//end
	//else
		final_v = store;

end // always block

endmodule