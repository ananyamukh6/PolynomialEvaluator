module polynomial_evaluation_accelerator(clock, reset); 

	parameter IN_FILE1 = "control.txt";
    parameter IN_FILE2 = "data.txt";  
    parameter RESULT_FILE = "result.txt";
	parameter STATUS_FILE = "status.txt";
	parameter CAPACITY = 8;
	parameter PTR_WIDTH = 3;
	
	input clock, reset;
	
	wire [21 - 1 : 0] fifo1_in;  //instruction is 21 bits
    wire [21 - 1 : 0] fifo1_out;    
    wire [16 - 1 : 0] fifo2_in;    //data is 16 bits
    wire [16 - 1 : 0] fifo2_out;        
    wire [32 - 1 : 0] fifo3_in;   //answer is 32 bits 
    wire [32 - 1 : 0] fifo3_out;
	wire [3 - 1 : 0] fifo4_in;    //status is 3 bits
    wire [3 - 1 : 0] fifo4_out;      

    wire fifo1_read, fifo1_write, fifo2_read, fifo2_write, fifo3_read, fifo3_write, fifo4_read;         

    wire fifo1_empty, fifo1_full, fifo2_empty, fifo2_full, fifo3_empty, fifo3_full, fifo4_empty, fifo4_full;

	
	file_source #(.DATA_WIDTH(21), .IN_FILE(IN_FILE1))
    file_source_module1(.out(fifo1_in), .write(fifo1_write),
        .out_full(fifo1_full), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
		

	fifo #(.DATA_WIDTH(21), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module1 (.out_data(fifo1_out), .full(fifo1_full),
        .empty(fifo1_empty), .in_data(fifo1_in), .r_en(fifo1_read), .w_en(fifo1_write), .r_clk(clock), .w_clk(clock),
        .reset(reset));
		

    file_source #(.DATA_WIDTH(16), .IN_FILE(IN_FILE2))
    file_source_module2(.out(fifo2_in), .write(fifo2_write),
        .out_full(fifo2_full), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));

    fifo #(.DATA_WIDTH(16), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module2 (.out_data(fifo2_out), .full(fifo2_full),
        .empty(fifo2_empty), .in_data(fifo2_in), .r_en(fifo2_read), .w_en(fifo2_write), .r_clk(clock), .w_clk(clock),
        .reset(reset));

	Polynonial_Evaluator pea(.result(fifo3_in), .status(fifo4_in), .read_enable_instruction(fifo1_read), .read_enable_data(fifo2_read), .write_enable_result(fifo3_write), .data(fifo2_out), .instruction(fifo1_out), .clk(clock), .reset(reset), .empty_instruction(fifo1_empty), .empty_data(fifo2_empty), .full_result(fifo3_full), .full_status(fifo4_full), .enable_firing_reset(1'b1));
	
	fifo #(.DATA_WIDTH(32), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module3 (.out_data(fifo3_out), .full(fifo3_full),
        .empty(fifo3_empty), .in_data(fifo3_in), .r_en(fifo3_read), .w_en(fifo3_write), .r_clk(clock), .w_clk(clock),
        .reset(reset));

    file_sink #(.DATA_WIDTH(32), .OUT_FILE(RESULT_FILE))
    file_sink_module1(.read(fifo3_read), .in(fifo3_out),
        .in_empty(fifo3_empty), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
		
	fifo #(.DATA_WIDTH(3), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module4 (.out_data(fifo4_out), .full(fifo4_full),
        .empty(fifo4_empty), .in_data(fifo4_in), .r_en(fifo4_read), .w_en(fifo3_write), .r_clk(clock), .w_clk(clock),
        .reset(reset));
		
	file_sink #(.DATA_WIDTH(3), .OUT_FILE(STATUS_FILE))
    file_sink_module2(.read(fifo4_read), .in(fifo4_out),
        .in_empty(fifo4_empty), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
	
	
		
		
		
		
		
		
		
		
		
		
/*
	wire [2:0] population;
		
		
	file_source #(.DATA_WIDTH(21), .IN_FILE(IN_FILE1))
    file_source_module1(.out(fifo1_in), .write(fifo1_write),
        .out_full(fifo1_full), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
		
	mixed_clock_fifo  #(.bit_width(21), .capacity(CAPACITY)) fifo_module1( fifo1_out, population, fifo1_full, fifo1_empty, fifo1_in, fifo1_write, fifo1_read, reset, clock, clock );
	
	//fifo #(.DATA_WIDTH(21), .CAPACITY(CAPACITY),
     //   .PTR_WIDTH(PTR_WIDTH)) fifo_module1 (fifo1_out, fifo1_full,
       // fifo1_empty, fifo1_in, fifo1_read, fifo1_write, clock, clock,
        //reset);

    file_source #(.DATA_WIDTH(16), .IN_FILE(IN_FILE2))
    file_source_module2(.out(fifo2_in), .write(fifo2_write),
        .out_full(fifo2_full), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));

    fifo #(.DATA_WIDTH(16), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module2 (fifo2_out, fifo2_full,
        fifo2_empty, fifo2_in, fifo2_read, fifo2_write, clock, clock,
        reset);

	Polynonial_Evaluator pea(.result(fifo3_in), .status(fifo4_in), .read_enable_instruction(fifo1_read), .read_enable_data(fifo2_read), .write_enable_result(fifo3_write), .data(fifo2_out), .instruction(fifo1_out), .clk(clock), .reset(reset), .empty_instruction(fifo1_empty), .empty_data(fifo2_empty), .full_result(fifo3_full), .full_status(fifo4_full), .enable_firing_reset(1'b1));
	
	fifo #(.DATA_WIDTH(32), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module3 (fifo3_out, fifo3_full,
        fifo3_empty, fifo3_in, fifo3_read, fifo3_write, clock, clock,
        reset);

    file_sink #(.DATA_WIDTH(32), .OUT_FILE(RESULT_FILE))
    file_sink_module1(.read(fifo3_read), .in(fifo3_out),
        .in_empty(fifo3_empty), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
		
	fifo #(.DATA_WIDTH(3), .CAPACITY(CAPACITY),
        .PTR_WIDTH(PTR_WIDTH)) fifo_module4 (fifo4_out, fifo4_full,
        fifo4_empty, fifo4_in, fifo4_read, fifo4_write, clock, clock,
        reset);
		
	file_sink #(.DATA_WIDTH(3), .OUT_FILE(STATUS_FILE))
    file_sink_module2(.read(fifo4_read), .in(fifo4_out),
        .in_empty(fifo4_empty), .clock(clock), .reset(reset),
        .enable_firing_reset(1'b1));
		
	*/	
endmodule