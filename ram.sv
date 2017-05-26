module ram
  #(
    parameter int bW=14,  // Bitwidth
    parameter int eC=784, // entry count
    parameter int aW=10   // address width
    )
	(
	input logic [bW-1:0] wrData,
	input logic [aW-1:0] wrAddr,
	input logic wrEn,
	output logic [bW-1:0] rdData1,
	output logic [bW-1:0] rdData2,
	output logic [bW-1:0] rdData3,
	output logic [bW-1:0] rdData4,
	input logic [aW-1:0] rdAddr,
	input logic clk,
	input logic rst
	);
	
	// signal declaration
	logic [bW-1:0] mem [eC-1:0];
	
	always @ (*) begin
	        rdData1 = mem[rdAddr];
	        rdData2 = mem[rdAddr+1];
	        rdData3 = mem[rdAddr+2];
	        rdData4 = mem[rdAddr+3];
	end
	
	always @(posedge clk) begin
	  if (wrEn) begin
	        mem[wrAddr] <= wrData;
	  end
	end

endmodule

