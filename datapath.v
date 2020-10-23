module datapath#(parameter WIDTH=32,INST_WIDTH=32,REG_COUNT_BITS=5)
					(input clk,input reset,output [WIDTH-1:0]pc,input [INST_WIDTH-1:0]inst,
					input [2:0]alu_control,output [WIDTH-1:0] alu_result,input [WIDTH-1:0] read_data,input reg_write,output [WIDTH-1:0]write_data,
					input reg_dst,
					input alu_src,
					input mem_to_reg,
					input beq_inst,
					input j_inst);

	wire [WIDTH-1:0] pc_plus4,pc_next,pc_beq_target,pc_target;
	wire [WIDTH-1:0] pc_offset_0,pc_offset_4,pc_offset_4_plus;
	wire [WIDTH-1:0] sign_imm;
	wire [WIDTH-1:0] src_a;
	wire [WIDTH-1:0] a3;
	wire [WIDTH-1:0] src_b;
	wire [WIDTH-1:0] result;
	wire zero;
	
	adder #(WIDTH)pc_adder4(.a(pc),.b(32'd4),.cin(32'd0),.s(pc_plus4));
	
	signextend #(16,WIDTH)signext_pc_offset(.a(inst[15:0]),.y(pc_offset_0));
	sl2 #(WIDTH)pc_offset_sl2(.a(pc_offset_0),.y(pc_offset_4));
	adder #(WIDTH)pc_offset_adder_pc4(.a(pc_plus4),.b(pc_offset_4),.cin(32'd0),.s(pc_beq_target));
	mux2 mux_pc_branch(.d0(pc_plus4),.d1(pc_beq_target),.sel(zero & beq_inst),.y(pc_target));
	mux2 mux_pc_next(.d0(pc_target),.d1({pc_plus4[31:28],inst[25:0],2'b00}),.sel(j_inst),.y(pc_next));
	flopr #(WIDTH)pc_reg(.clk(clk),
								.reset(reset),
								.d(pc_next),
								.q(pc));
								
	mux2 regdst(.d0(inst[20:16]),.d1(inst[15:11]),.sel(reg_dst),.y(a3));							
	regfile #(REG_COUNT_BITS,WIDTH)rf(.clk(clk),
												 .a1(inst[25:21]),
												 .a2(inst[20:16]),
												 .a3(a3),
												 .wd3(result),
												 .we3(reg_write),
												 .rd1(src_a),
												 .rd2(write_data));
												 
	signextend #(16,WIDTH)signext(.a(inst[15:0]),.y(sign_imm));
	
	mux2 alu_src_b(.d0(write_data),.d1(sign_imm),.sel(alu_src),.y(src_b));
	alu #(WIDTH)alu(.a(src_a),.b(src_b),.f(alu_control),.y(alu_result),.zero(zero));
	mux2 mem_or_reg(.d0(alu_result),.d1(read_data),.sel(mem_to_reg),.y(result));
endmodule

