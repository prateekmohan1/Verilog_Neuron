module romL1L2Weights
  #(
    parameter int bW=14,  // Bitwidth
    parameter int eC=391999, // entry count
    parameter int aW=19   // address width
    )
	(
	input logic [aW-1:0] address , // Address input
	output logic [bW-1:0] data    , // Data output
	input logic read_en // Read Enable 
	);

	logic [bW-1:0] mem [eC-1:0] ;  
      
	assign data = (read_en) ? mem[address] : 14'b0;

	initial begin
	  $readmemb("memory.list", mem); // memory_list is memory file
	end

endmodule
