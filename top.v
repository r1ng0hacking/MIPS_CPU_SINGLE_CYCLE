module top#(parameter WIDTH=32,INST_WIDTH=32,REG_COUNT_BITS=5)(input clk,input reset,output [WIDTH-1:0] pc,output [INST_WIDTH-1:0] inst,
																					output [WIDTH-1:0] alu_result,output [WIDTH-1:0] read_data,output [WIDTH-1:0] write_data);

//	wire [WIDTH-1:0] pc;
//	wire [INST_WIDTH-1:0] inst;
//	wire [WIDTH-1:0] alu_result;
//	wire [WIDTH-1:0] read_data;
	wire mem_write;
	
	mips #(WIDTH,INST_WIDTH,REG_COUNT_BITS)mips(.clk(clk),
															  .reset(reset),
															  .pc(pc),
															  .inst(inst),
															  .alu_result(alu_result),
															  .read_data(read_data),
															  .mem_write(mem_write),
															  .write_data(write_data));
	imem imem(.addr(pc),.rd(inst));
	
	dmem dmem(.clk(clk),.addr(alu_result),.rd(read_data),.we(mem_write),.wd(write_data));

endmodule

module top_tb;

	parameter WIDTH=32,INST_WIDTH=32,REG_COUNT_BITS=5;
	
	reg clk,reset;
	wire [WIDTH-1:0] pc,read_data,alu_result;
	wire [INST_WIDTH-1:0] inst;
	
	top #(WIDTH,INST_WIDTH,REG_COUNT_BITS)top(.reset(reset),
															.clk(clk),
															.pc(pc),
															.read_data(read_data),
															.alu_result(alu_result),
															.inst(inst));
	
	initial
	begin
		reset = 0;#1;
		reset = 1;#1;
		reset = 0;#1;
	end
	
	always begin
		clk = 0;#1;
		clk = 1;#1;
	end
	

endmodule

