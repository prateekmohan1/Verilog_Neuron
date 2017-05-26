module mux
  #(
    parameter int bW=14  // Bitwidth
    )
	(
	input logic [bW-1:0] A,   //Input 1 
	input logic [bW-1:0] B,   //Input 2
	output logic [bW-1:0] C,  //Output
	input logic S		  //Select
	);

	always @ (*) begin
		case (S)
			1'b0: C = A;
			1'b1: C = B;
			default: C = 0;
		endcase
	end

endmodule
