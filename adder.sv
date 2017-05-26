
module adder
        #(parameter int size = 1 ) // Our first module parameter! Now everything is squishy
        (
        input logic [size-1:0] A , // Input 1
        input logic [size-1:0] B , // Input 2
        output logic [size-1:0] C   // Output
        );

        logic [size:0] temp;

	always @ (*) begin
		temp = A + B;
	end
	
	assign C = temp[size-1:0];

endmodule

