module regfile#(parameter N=5,M=32)(input clk,input [N-1:0]a1
											 ,input [N-1:0]a2
											 ,input [N-1:0]a3
											 ,input [M-1:0]wd3
											 ,input we3
											 ,output [M-1:0]rd1
											 ,output [M-1:0]rd2);
	
	reg [M-1:0]rf[2**N-1:0];
	always @(posedge clk)
	begin
		if(we3)begin
			rf[a3] <= wd3;
		end
	end
	
	assign rd1 = a1==0?0:rf[a1];
	assign rd2 = a2==0?0:rf[a2];
	
endmodule

module regfile_tb;

	parameter N=5,M=32;
	
	reg clk;
	reg [N-1:0]a1,a2,a3;
	reg [M-1:0]wd3;
	reg we3;
	
	wire [M-1:0] rd1,rd2;
	
	regfile #(N,M)DUT(.clk(clk),
							.a1(a1),
							.a2(a2),
							.a3(a3),
							.wd3(wd3),
							.we3(we3),
							.rd1(rd1),
							.rd2(rd2));
							
	initial
	begin
		clk = 0;
		
		a1 = 0;#10;
		$display("a1(0):%d",rd1);#10;
		
		a2 = 0;#10;
		$display("a2(0):%d",rd2);#10;
		
		wd3 = 100;a3=0;we3=1;#10;
		clk = 1;#10;
		clk = 0;#10;
		we3=0;#10;
		a1 = 0;#10;
		$display("a1(0):%d",rd1);#10;
		
		wd3 = 100;a3=3;we3=1;#10;
		clk = 1;#10;
		clk = 0;#10;
		we3=0;#10;
		a1 = 3;#10;
		$display("a1(3):%d",rd1);#10;
		
	end

endmodule