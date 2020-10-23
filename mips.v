module mips#(parameter WIDTH=32,INST_WIDTH=32,REG_COUNT_BITS=5)
				(input clk,input reset,output [WIDTH-1:0]pc,input [INST_WIDTH-1:0]inst,
				 output [WIDTH-1:0] alu_result,input [WIDTH-1:0] read_data,output  mem_write,output [WIDTH-1:0]write_data);

	wire [2:0]alu_control;
	wire reg_write,reg_dst,alu_src,mem_to_reg,beq_inst,j_inst;	
	
	
	datapath #(WIDTH,INST_WIDTH,REG_COUNT_BITS)dp(.clk(clk),
																 .reset(reset),
																 .pc(pc),
																 .inst(inst),
																 .alu_control(alu_control),
																 .alu_result(alu_result),
																 .read_data(read_data),
																 .reg_write(reg_write),
																 .write_data(write_data),
																 .reg_dst(reg_dst),
																 .alu_src(alu_src),
																 .mem_to_reg(mem_to_reg),
																 .beq_inst(beq_inst),
																 .j_inst(j_inst));

	controller #(INST_WIDTH)ctl(.inst(inst),
										 .alu_control(alu_control),
										 .reg_write(reg_write),
										 .mem_write(mem_write),
										 .reg_dst(reg_dst),
										 .alu_src(alu_src),
										 .mem_to_reg(mem_to_reg),
										 .beq_inst(beq_inst),
										 .j_inst(j_inst));
endmodule