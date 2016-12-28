`timescale 1ns/10ps
`define N 10


module Polynonial_Evaluator(result, status, read_enable_instruction, read_enable_data, write_enable_result, data, instruction, clk, reset, empty_instruction, empty_data, full_result, full_status, enable_firing_reset);

/* States of the PEA . */
parameter s_reset 	= 2'b00;
parameter read_instruction 	= 2'b01;
parameter execute_instruction = 2'b10;
//parameter stalled_on_result = 2'b11;

parameter RST = 2'b00;
parameter STP = 2'b01;
parameter EVP = 2'b10;
parameter EVB = 2'b11;
parameter CORRECT_EVB_INSTRUCTION = 0;
parameter CORRECT_STP_INSTRUCTION = 1;
parameter EVP_CORRECT = 2;
parameter EVB_CORRECT = 3;
parameter INVALID_A = 4;
parameter INVALID_N = 5;
parameter INVALID_B = 6;
parameter A_NOT_SET = 7;
//parameter IGNORE = 8;

//TODO : add status FIFO //Done

/* Ouput data in 16 bit signed integer representation. */
	output[31:0] result;
	output read_enable_instruction;
	output read_enable_data;
	output write_enable_result;  //This drives both status and result FIFOs
	output[2:0] status;
	input enable_firing_reset;
	
	input[15:0] data;
	input[20:0] instruction;
	input reset;
	input clk;
	input empty_instruction;
	input empty_data;
	input full_result;
	input full_status;
	integer i, j, execution_counter, flag1;
	
	reg signed[31:0] result;
	reg[2:0] status;
	//reg [20:0] instruction;
	//reg[15:0] data;
	reg[15:0] coefficients[7:0][`N:0];
	reg[7:0] flag[7:0];
	reg[1:0] pea_inst;
	reg[2:0] pea_arg1;
	reg signed[15:0] pea_arg2;
	reg read_enable_instruction, read_enable_data, write_enable_result;
	reg[15:0] coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0, x;
	wire[31:0] sum;
	reg[1:0] current_state, next_state;
	reg instruction_ready, data_ready;

	evaluator evp(sum, x, coeff10, coeff9, coeff8, coeff7, coeff6, coeff5, coeff4, coeff3, coeff2, coeff1, coeff0);


//TODO: Write initial block //done
//initial current_state = read_instruction
//initial pea_inst = RST

initial
begin
current_state = read_instruction;
next_state = read_instruction;
pea_inst = RST;
read_enable_instruction = 0; read_enable_data =0; write_enable_result = 0;
execution_counter = 0;
for (i = 0; i < 8; i=i+1)begin
	for (j = 0; j <=`N; j=j+1 )
		coefficients[i][j] = 0;
	flag[i] = 0;
end
instruction_ready = 0; data_ready = 0;
end

//Errors to be handled:
//1) A out of range (STP, EVP, EVB)
//2) A not set by STP, before using it in EVP or EVB
//3) Invalid 'n' for STP A n
//TODO: Are there any more errors? //done

//TODO: when its an error, output/result is 0 //done

//Note: use if (~empty in place if if (empty). The former handles the case of 'x' well
always @(*)
begin

if (instruction_ready || data_ready) begin
	if (instruction_ready) begin
		//$display("instruction_ready %d", instruction);
		instruction_ready = 0;
		pea_inst = instruction[20:19];
		pea_arg1 = instruction[18:16];
		pea_arg2 = instruction[15:0];
		
		//$display("pea_inst == %d seq", pea_inst);

		if (pea_inst == RST) begin
				//TODO //done
				current_state = s_reset; //read_instruction;
				execution_counter = 0;
				read_enable_data = 1'b0; read_enable_instruction = 1'b0; write_enable_result = 1'b0;
				//TODO for loop coeff  //done
				//TODO reset flags //done
				for (i = 0; i < 8; i=i+1)begin
					for (j = 0; j <=`N; j=j+1)
						coefficients[i][j] = 0;
					flag[i] = 0;
				end
			end

			if (pea_inst == EVP) begin
				x = pea_arg2;
				coeff0 = coefficients[pea_arg1][0];
				coeff1 = coefficients[pea_arg1][1];
				coeff2 = coefficients[pea_arg1][2];
				coeff3 = coefficients[pea_arg1][3];
				coeff4 = coefficients[pea_arg1][4];
				coeff5 = coefficients[pea_arg1][5];
				coeff6 = coefficients[pea_arg1][6];
				coeff7 = coefficients[pea_arg1][7];
				coeff8 = coefficients[pea_arg1][8];
				coeff9 = coefficients[pea_arg1][9];
				coeff10 = coefficients[pea_arg1][10];
			end

			if (pea_inst == STP) begin
				execution_counter = 0;
				//TODO anything else?
			end
			if (pea_inst == EVB) begin
				execution_counter = 0;
				//$display("pea_inst == EVB seq");
				//TODO anything else?
			end
	end
	else begin  //data_ready
		//$display("data_ready %d", data);
		data_ready = 0;
		if(pea_inst == STP)begin
			//$display("data_ready %d execution_counter %d pea_arg2 %d", data, execution_counter, pea_arg2);
			if (execution_counter <= pea_arg2)begin
				coefficients[pea_arg1][execution_counter] = data;
				$display("execution_counter %d val = %d", execution_counter,  coefficients[pea_arg1][execution_counter]);
				execution_counter = execution_counter+1;
				if (execution_counter >= pea_arg2) begin  //if last coeff has been read in, set flag and set rest of coeffs to 0
					flag[pea_arg1] = 1;
					//set remaining elements of the CV to 0
					for (i = pea_arg2+1; i < (`N+1) ; i=i+1) begin //NOTE: was 12, should be `N+1 or 11 I think
						coefficients[pea_arg1][i] = 0;
					end
				end
			end
		end
		if (pea_inst == EVB) begin
			x = data;
			coeff0 = coefficients[pea_arg1][0];
			coeff1 = coefficients[pea_arg1][1];
			coeff2 = coefficients[pea_arg1][2];
			coeff3 = coefficients[pea_arg1][3];
			coeff4 = coefficients[pea_arg1][4];
			coeff5 = coefficients[pea_arg1][5];
			coeff6 = coefficients[pea_arg1][6];
			coeff7 = coefficients[pea_arg1][7];
			coeff8 = coefficients[pea_arg1][8];
			coeff9 = coefficients[pea_arg1][9];
			coeff10 = coefficients[pea_arg1][10];
			execution_counter = execution_counter+1;
		end
	end
end
//else begin
	next_state = current_state;
	case(current_state)
		s_reset:begin
			for (i = 0; i < 8; i=i+1)begin
				for (j = 0; j <=`N; j=j+1)
					coefficients[i][j] = 0;
				flag[i] = 0;
			end
			//TODO //done
			read_enable_data = 1'b0;
			write_enable_result = 1'b0;
			if (~empty_instruction) begin
				read_enable_instruction = 1'b1;
				next_state = read_instruction;
			end
			else begin
				read_enable_instruction = 1'b0;
				next_state = s_reset;
			end
			//$display("xxx next_state %d", next_state);
		end

		read_instruction:begin
			//$display("pea_inst:%d",pea_inst);
			if (pea_inst == RST) begin
				//$display("pea_inst:%d, next_state %d empty_instruction %d read_enable_instruction %d instruction %d",pea_inst, next_state, empty_instruction, read_enable_instruction, instruction);
				next_state = read_instruction;
				if (~empty_instruction)
					read_enable_instruction = 1'b1;
				else
					read_enable_instruction = 1'b0;
				//$display("pea_inst:%d, next_state %d empty_instruction %d read_enable_instruction %d, instruction %d... %d %d %d",pea_inst, next_state, empty_instruction, read_enable_instruction, instruction, instruction[20:19], instruction[18:16], instruction[15:0]);
				read_enable_data = 1'b0;
				write_enable_result = 1'b0;
			end
			if(pea_inst == STP) begin
				//$display("write_enable_result %d", write_enable_result);
				result = 0; //result from STP is 0 for error or normal execution
				status = CORRECT_STP_INSTRUCTION;
				if (pea_arg1 >= 8 || pea_arg2 > 10) begin  //Check for invalid A and n values
					//Behave similar to EVP, that is do not go to execute mode, but try to push out the result at this phase (the incorrect status) and read in a new instruction.
					next_state = read_instruction;
					status = pea_arg1 >= 8 ? INVALID_A : INVALID_N;
					read_enable_data = 1'b0;
					if (~(full_result || full_status)) begin
						if (~empty_instruction)
							read_enable_instruction = 1'b1;
						else
							read_enable_instruction = 1'b0;
						write_enable_result = 1'b1;
					end
					else begin
						read_enable_instruction = 1'b0;
						write_enable_result = 1'b0;
					end
				end
				else begin //No error in A or n values of STP
					next_state = execute_instruction;
					read_enable_instruction = 1'b0;
					if (~(full_result || full_status)) begin
						if (~empty_data)
							read_enable_data = 1'b1;
						else
							read_enable_data = 1'b0;
						write_enable_result = 1'b1;
					end
					else begin
						write_enable_result = 1'b0;
					end
				end
				//$display("write_enable_result exit %d, status %d", write_enable_result, status);
			end
			if (pea_inst == EVP) begin
				//$display("read EVP");
				//TODO: check full_result is replaced by full_result || full_status everywhere //done
				status = EVP_CORRECT;
				if (pea_arg1 >= 8) begin //error check
					status = INVALID_A; result = 0;
				end
				else begin 
					//$display("flag[pea_arg1] %d  pea_arg1 %d, pea_arg2 %d", flag[pea_arg1], pea_arg1, pea_arg2);
					if (flag[pea_arg1] != 1)begin //error check
						status = A_NOT_SET; result = 0;
					end
					else begin
						result = sum;
					end
				end
				next_state = read_instruction;
				read_enable_data = 1'b0;
				if (~(full_result || full_status)) begin
					if (~empty_instruction)
						read_enable_instruction = 1'b1;
					else
						read_enable_instruction = 1'b0;
					write_enable_result = 1'b1;
				end
				else begin
					read_enable_instruction = 1'b0;
					write_enable_result = 1'b0;
				end
				//$display("read_enable_instruction %d write_enable_result %d empty_instruction %d", read_enable_instruction, write_enable_result, empty_instruction);
			end
			if (pea_inst == EVB) begin
				//$display("entered EVB");
				flag1 = 0;
				result = 0;
				status = CORRECT_EVB_INSTRUCTION;
				if (pea_arg1 >= 8 || pea_arg2 >= 32 || pea_arg2 < 0) begin  //Check for invalid A and n values
					status = pea_arg1 >= 8 ? INVALID_A : INVALID_B;
					flag1 = 1;
				end
				else begin
					//$display("Made it where i need to");
					if (flag[pea_arg1] != 1) begin
						status = A_NOT_SET;
						flag1 = 1;
					end
				end
				//$display("AAAAAAA flag1 %d status %d", flag1, status);
				if (flag1) begin  //any error occured
					next_state = read_instruction;
					read_enable_data = 1'b0;
					if (~(full_result || full_status)) begin
						if (~empty_instruction)
							read_enable_instruction = 1'b1;
						else
							read_enable_instruction = 1'b0;
						write_enable_result = 1'b1;
					end
					else begin
						read_enable_instruction = 1'b0;
						write_enable_result = 1'b0;
					end
				end
				else begin
					next_state = execute_instruction;
					read_enable_instruction = 1'b0;
					if (~(full_result || full_status)) begin
						if (~empty_data)
							read_enable_data = 1'b1;
						else
							read_enable_data = 1'b0;
						write_enable_result = 1'b1;
					end
					else begin
						write_enable_result = 1'b0;
					end
				end
			end
		end

		execute_instruction:begin	
			//$display("XXXXXXXX pea_inst %d execution_counter %d", pea_inst, execution_counter);
			if (pea_inst == STP) begin
				write_enable_result = 1'b0;
				if (pea_arg2 < execution_counter) begin  //STP has finished executing
					next_state = read_instruction;
					if (~empty_instruction)
						read_enable_instruction = 1'b1;
					else
						read_enable_instruction = 1'b0;
					read_enable_data = 1'b0;
					//pea_inst = RST;
				end
				else begin  //STP is still executing
					next_state = execute_instruction;
					read_enable_instruction = 1'b0;
					if (~empty_data)
						read_enable_data = 1'b1;
					else
						read_enable_data = 1'b0;
				end
				//TODO execution_counter: pea_arg2 == execution_counter or pea_arg2 == execution_counter-1  //done
				
			end
			else begin
				if (pea_inst == EVB) begin
					result = sum;
					status = EVB_CORRECT;
					//$display("pea_arg2 %d execution_counter %d", pea_arg2, execution_counter);
					if (pea_arg2 == execution_counter) begin //EVB has finished executing
						if (~(full_result || full_status)) begin  //Is it able to push out its result to result FIFO?
							next_state = read_instruction;
							if (~empty_instruction)
								read_enable_instruction = 1'b1;
							else
								read_enable_instruction = 1'b0;
							write_enable_result = 1'b1;
							read_enable_data = 1'b0;
							//pea_inst = RST;
						end
						else begin
							next_state = execute_instruction;  //since it cant dump out result, it cant move to read_instruction
							write_enable_result = 1'b0;
							read_enable_data = 1'b0;
							read_enable_instruction = 1'b0;
						end
					end
					else begin  //EVB hasn't finished executing yet
						next_state = execute_instruction;
						read_enable_instruction = 1'b0;
						if (~(full_result || full_status)) begin
							write_enable_result = 1'b1;
							if (~empty_data)
								read_enable_data = 1'b1;
							else
								read_enable_data = 1'b0;
						end
						else begin
							write_enable_result = 1'b0;
							read_enable_data = 1'b0;
						end
					end
				end
				else begin
					//error TODO set error status
					//$display("ERROR RST");
				end
			end
		end
	endcase

//end
end

always @(posedge clk or negedge reset)
begin
if (~reset && enable_firing_reset) begin
	current_state <= s_reset;
end
else
	current_state <= next_state;

if (next_state == read_instruction)begin
	// If pea_inst==EVP,EVB, they must push out their result. The result of EVP/EVB can be error state result or actual execution phase result. Either way they have to push out a result
	//RST does not have any result/status
	//STP: If it produces an error, then it does not go into execute mode and must push out a error status/result and next_state is read (instead of the usual execution). If it is a valid STP instruction, then it goes to execution mode, and hence will not need to push out a result in its execution phase.
	
	//if (inst is EVP or EVB and we can push out result
	//     or inst is rst
	//     or inst = STP and there is an error and we can push out result
	//     or inst = STP and there is no result  (no check for pushing out result required in this case)
	//)
	instruction_ready <= 0;
	if (((pea_inst == EVP || pea_inst == EVB) && write_enable_result) || (pea_inst == RST) || (pea_inst == STP && (status == INVALID_A || status == INVALID_N) && write_enable_result) || (pea_inst == STP && status == CORRECT_STP_INSTRUCTION)) begin
		if (read_enable_instruction) begin
			instruction_ready <= 1;
		end
	end
end

if (next_state == execute_instruction)begin
	data_ready <= 0;
	if ((pea_inst == EVB && write_enable_result) || pea_inst == STP) begin //Am I able to push out my current evaluated data?
		if (read_enable_data) begin //Able to read in a new piece of data
			data_ready <= 1;
		end
	end
end
end
endmodule