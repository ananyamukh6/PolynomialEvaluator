`timescale 1ns/10ps

module testbench;

	localparam delay = 5;
    localparam clock_cycle = delay*2;
	
	reg clock;
    reg reset;


	polynomial_evaluation_accelerator pea(clock, reset);
	
    initial begin
	$monitor("%d, %d, r: %d, sum: %d >>> instrs: %p, >>> data: %p", $time, clock, reset, pea.pea.sum, pea.fifo_module1.memory, pea.fifo_module2.memory );
       // $monitor("%d, %d, %d, result: %d status: %d currstate: %d, nextstate: %d, (ei:%d ed:%d fr:%d fs:%d), (rei:%d red:%d wer%d)  inst: %d, pea_inst: %d. fifo inst %p, fifo data %p %d  %d %d %d %d sum %d status %d %p %d %d %d", $time, clock, reset, pea.pea.result, pea.pea.status, pea.pea.current_state, pea.pea.next_state, pea.pea.empty_instruction, pea.pea.empty_data, pea.pea.full_result, pea.pea.full_status, pea.pea.read_enable_instruction, pea.pea.read_enable_data, pea.pea.write_enable_result, pea.pea.instruction, pea.pea.pea_inst, pea.fifo_module1.memory, pea.fifo_module2.memory, pea.fifo_module1.out_data, pea.file_source_module1.out, pea.file_source_module1.output_ready, pea.file_source_module1.write, pea.file_source_module1.value, pea.pea.sum, pea.pea.status, pea.fifo_module4.memory, pea.fifo_module4.empty, pea.fifo_module4.out_data, pea.fifo_module4.r_en);
		//$monitor("%d %d", $time, clock, pea.pea.status)
    reset = 1;
	clock = 0;
	#(clock_cycle) reset = 0;
	#(clock_cycle) reset = 1;
    #(clock_cycle*9)         
    $finish; 
	end

   always
        #(delay) clock = ~clock;

endmodule

