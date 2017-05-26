
module neuron
  #(
    parameter int bW=16,
    parameter int romaW=19,
    parameter int ramaW=10 
    )
	(
	input logic clk, 
	input logic rst
	);

	//Select Lines
	logic A1, A2, A3, A4, A5, A6, A7, A8, A9, A11, A12;

	//Mux outputs
	logic [bW-1:0] data1, data2, data3, data4;

	//Mux inputs and outputs out of Local L2
	logic [bW-1:0] rdData1, rdData2, rdData3, rdData4;

	//Outputs out of Local L1L2 Syn
	logic rdData1_syn, rdData2_syn, rdData3_syn, rdData4_syn;

	//Output of ROML1L2
	logic [bW-3:0] rdDataROM_L1L2;
	logic [romaW-1:0] rdAddrROM_L1L2;
	logic readEnROM_L1L2;

	//Output of ROML1L2Syn
	logic rdDataROM_L1L2_Syn;

	//Dff for romAddr 
	logic [romaW-1:0] rdAddrROM_L1L2_d;

	//Dff for ramL2
	logic [ramaW-1:0] rdAddrRAM_L2;
	logic [ramaW-1:0] wrAddrRAM_L2;
	logic [ramaW-1:0] wrAddrRAM_L2_d;
	logic [ramaW-1:0] rdAddrRAM_L2_d;
	logic wrEnRAM_L2;

	//Dff for L2 Vmem
	logic [bW-1:0] Vmemt1L2_d, Vmemt1L2_f;
	logic [bW-1:0] Vmemt2L2_d, Vmemt2L2_f;
	logic [bW-1:0] Vmemt3L2_d, Vmemt3L2_f;
	logic [bW-1:0] Vmemt4L2_d, Vmemt4L2_f;

	//Total Vmembrane L2
	logic [bW-1:0] VmemL2Tot_d, VmemL2Tot_f;

	//Threshold for the membrane
	logic [bW-1:0] Vth;

	//Dff for L3
	logic [bW-1:0] Vmemt1L3_d, Vmemt1L3_f;
	logic [bW-1:0] Vmemt2L3_d, Vmemt2L3_f;
	logic [bW-1:0] Vmemt3L3_d, Vmemt3L3_f;
	logic [bW-1:0] Vmemt4L3_d, Vmemt4L3_f;

	//Total Vmembrane L3
	logic [bW-1:0] VmemL3Tot_d, VmemL3Tot_f;

	//Adder output
	logic [bW-1:0] Vmemt1L2sum, Vmemt2L2sum, Vmemt3L2sum, Vmemt4L2sum;

	//Current state and next state
	logic [3:0] state, nextstate;

	//Fill status
	logic fill, fill_d;	

	assign VmemL2Tot_d = Vmemt1L2_f + Vmemt2L2_f + Vmemt3L2_f + Vmemt4L2_f;
	assign Vth = 16'd1140;


	always @ (*) begin
		if (VmemL2Tot_f > Vth)
		

	end

	//FSM - Choosing the next state
	always @ (*) begin

		if (~rst) begin
			A12 = 1'b0;
			A11 = 1'b0;
			A9 = 1'b0;
			A1 = 1'b1;
			A2 = 1'b1;
			A3 = 1'b1;
			A4 = 1'b1;
			A5 = 1'b0;
			A6 = 1'b0;
			A7 = 1'b0;
			A8 = 1'b0;
			readEnROM_L1L2 = 1'b0;
			wrEnRAM_L2 = 1'b0;
		end
		else begin
			case(state) 
				4'd0: begin
				        A12 = 1'b1;
				        A11 = 1'b1;
				        A9 = 1'b0;
				        A1 = 1'b1;
				        A2 = 1'b1;
				        A3 = 1'b1;
				        A4 = 1'b1;
				        A5 = 1'b0;
				        A6 = 1'b0;
				        A7 = 1'b0;
				        A8 = 1'b0;
				        readEnROM_L1L2 = 1'b1;
				        wrEnRAM_L2 = 1'b1;

					if (wrAddrRAM_L2 == 783) begin
						nextstate = 4'd1;
					end
					else begin
						nextstate = 4'd0;
					end
				      end
				4'd1: begin
				        A12 = 1'b0;
				        A11 = 1'b0;
				        A9 = 1'b1;
				        A5 = 1'b1;
				        A6 = 1'b1;
				        A7 = 1'b1;
				        A8 = 1'b1;

					//Check if synapses is high, if so set the A1 - A4
					if (rdData1_syn) A1 = 1'b0; else A1 = 1'b1;
					if (rdData2_syn) A2 = 1'b0; else A2 = 1'b1;
					if (rdData3_syn) A3 = 1'b0; else A3 = 1'b1;
					if (rdData4_syn) A4 = 1'b0; else A4 = 1'b1;

					if (rdAddrRAM_L2 == 780 || VmemL2Tot_f > Vth) begin
						nextstate = 4'd2;
					end
					else begin
						nextstate = 4'd1;
					end
				      end
				4'd2: begin



				      end
			endcase
		end
	end

	//Mux for "fill" variable
	//always @ (*) begin
	//	if (wrAddrRAM_L2 == 783) begin
	//		fill_d = 1;
	//	end
	//	else begin
	//		fill_d = 0;
	//	end
	//end

	//FSM - Toggling state at clock
	always @ (posedge clk or negedge rst) begin
		if (~rst) begin
			state <= 0;
		end
		else begin
			state <= nextstate;
		end
	end


	//FSM - changing output per clock edge
	//always @ (posedge clk or negedge rst) begin	
	//	if (~rst) begin
	//		A12 <= 1'b0;
	//		A11 <= 1'b0;
	//		A9 <= 1'b0;
	//		A1 <= 1'b1;
	//		A2 <= 1'b1;
	//		A3 <= 1'b1;
	//		A4 <= 1'b1;
	//		A5 <= 1'b0;
	//		A6 <= 1'b0;
	//		A7 <= 1'b0;
	//		A8 <= 1'b0;
	//		readEnROM_L1L2 <= 1'b0;
	//		wrEnRAM_L2 <= 1'b0;
	//	end
	//	else begin
	//		case (state)
	//		  4'd0: begin
	//			  A12 <= 1'b1;
	//			  A11 <= 1'b1;
	//			  A9 <= 1'b0;
	//			  A1 <= 1'b1;
	//			  A2 <= 1'b1;
	//			  A3 <= 1'b1;
	//			  A4 <= 1'b1;
	//			  A5 <= 1'b0;
	//			  A6 <= 1'b0;
	//			  A7 <= 1'b0;
	//			  A8 <= 1'b0;
	//			  readEnROM_L1L2 <= 1'b1;
	//			  wrEnRAM_L2 <= 1'b1;
	//			end
	//		  4'd1: begin
	//			  A12 <= 1'b0;
	//			  A11 <= 1'b0;
	//			  A9 <= 1'b1;
	//			  A1 <= 1'b0;
	//			  A2 <= 1'b0;
	//			  A3 <= 1'b0;
	//			  A4 <= 1'b0;
	//			  A5 <= 1'b1;
	//			  A6 <= 1'b1;
	//			  A7 <= 1'b1;
	//			  A8 <= 1'b1;
	//			end
	//		endcase
	//	end
	//end

	//Instantiate Muxes
	mux #(ramaW) muxA12 (.A({ramaW{1'b0}}), 
			     .B(wrAddrRAM_L2 + 1'b1), 
			     .C(wrAddrRAM_L2_d), 
			     .S(A12));
	mux #(romaW) muxA11 (.A({romaW{1'b0}}), 
			     .B(rdAddrROM_L1L2 + 1'b1), 
			     .C(rdAddrROM_L1L2_d), 
			     .S(A11));
	mux #(ramaW) muxA9 (.A({ramaW{1'b0}}), 
			    .B(rdAddrRAM_L2 + 4), 
			    .C(rdAddrRAM_L2_d), 
			    .S(A9));
	mux #(bW) muxA1 (.A(rdData1), 
			 .B(16'b0), 
			 .C(data1), 
			 .S(A1));
	mux #(bW) muxA2 (.A(rdData2), 
			 .B(16'b0), 
			 .C(data2), 
			 .S(A2));
	mux #(bW) muxA3 (.A(rdData3), 
			 .B(16'b0), 
			 .C(data3), 
			 .S(A3));
	mux #(bW) muxA4 (.A(rdData4), 
			 .B(16'b0), 
			 .C(data4), 
			 .S(A4));
	mux #(bW) muxA5 (.A(0), 
			 .B(Vmemt1L2sum), 
			 .C(Vmemt1L2_d), 
			 .S(A5));
	mux #(bW) muxA6 (.A(0), 
			 .B(Vmemt2L2sum), 
			 .C(Vmemt2L2_d), 
			 .S(A6));
	mux #(bW) muxA7 (.A(0), 
			 .B(Vmemt3L2sum), 
			 .C(Vmemt3L2_d), 
			 .S(A7));
	mux #(bW) muxA8 (.A(0), 
			 .B(Vmemt4L2sum), 
			 .C(Vmemt4L2_d), 
			 .S(A8));

	//Instantiate 4 adders for the temp
	//calculation for Vmem L2
	adder #(bW) Vmemt1L2add (.A(data1),
				 .B(Vmemt1L2_f),
				 .C(Vmemt1L2sum));
	adder #(bW) Vmemt2L2add (.A(data2),
				 .B(Vmemt2L2_f),
				 .C(Vmemt2L2sum));
	adder #(bW) Vmemt3L2add (.A(data3),
				 .B(Vmemt3L2_f),
				 .C(Vmemt3L2sum));
	adder #(bW) Vmemt4L2add (.A(data4),
				 .B(Vmemt4L2_f),
				 .C(Vmemt4L2sum));

	//Instantiate Flip Flops for temporary Flip Flops
	//that are for Vmem L2
	dff #(bW) Vmemt1L2 (.din(Vmemt1L2_d),
			    .clk(clk),
			    .rst(rst),
			    .en(1'b1),
			    .q(Vmemt1L2_f));
	dff #(bW) Vmemt2L2 (.din(Vmemt2L2_d),
			    .clk(clk),
			    .rst(rst),
			    .en(1'b1),
			    .q(Vmemt2L2_f));
	dff #(bW) Vmemt3L2 (.din(Vmemt3L2_d),
			    .clk(clk),
			    .rst(rst),
			    .en(1'b1),
			    .q(Vmemt3L2_f));
	dff #(bW) Vmemt4L2 (.din(Vmemt4L2_d),
			    .clk(clk),
			    .rst(rst),
			    .en(1'b1),
			    .q(Vmemt4L2_f));
	dff #(bW) VmemtotL2 (.din(VmemL2Tot_d),
			     .clk(clk),
			     .rst(rst),
			     .en(1'b1),
			     .q(VmemL2Tot_f));

	//Dff for fill variable
	dff #(1) fill_dff (.din(fill_d),
			   .clk(clk),
			   .rst(rst),
			   .en(1'b1),
			   .q(fill));

	//ROM Memory - L1L2 weights
	romL1L2Weights #(bW-2,784,romaW) ROML1L2weights (.address(rdAddrROM_L1L2),
		  			                 .data(rdDataROM_L1L2),
					                 .read_en(readEnROM_L1L2));

	romL1L2Syn #(1,784,romaW) ROML1L2synapses (.address(rdAddrROM_L1L2),
					           .data(rdDataROM_L1L2_Syn),
					           .read_en(readEnROM_L1L2));

	//RAM Memory for L1L2 Synapses - holds 784
	ram #(1,784,10) L1L2LocalSyn (.wrData(rdDataROM_L1L2_Syn),
				         .wrAddr(wrAddrRAM_L2),
				         .wrEn(readEnROM_L1L2),
				         .rdData1(rdData1_syn),
				         .rdData2(rdData2_syn),
				         .rdData3(rdData3_syn),
				         .rdData4(rdData4_syn),
				         .rdAddr(rdAddrRAM_L2),
				         .clk(clk),
				         .rst(rst));

	//RAM Memory for L2 Weights - holds 784
	ram #(bW-2,784,10) L1L2LocalWeights (.wrData(rdDataROM_L1L2),
				             .wrAddr(wrAddrRAM_L2),
				             .wrEn(readEnROM_L1L2),
				             .rdData1(rdData1),
				             .rdData2(rdData2),
				             .rdData3(rdData3),
				             .rdData4(rdData4),
				             .rdAddr(rdAddrRAM_L2),
				             .clk(clk),
				             .rst(rst));

	//Dff for Addr for RAM L2 weights - rd and wraddr
	dff #(ramaW) RAML2rdAddrdff (.din(rdAddrRAM_L2_d),
			 	     .clk(clk),
			 	     .rst(rst),
				     .en(1'b1),
				     .q(rdAddrRAM_L2));
	dff #(ramaW) RAML2wrAddrdff (.din(wrAddrRAM_L2_d),
				     .clk(clk),
				     .rst(rst),
				     .en(1'b1),
				     .q(wrAddrRAM_L2));

	//Dff for Addr for ROM L1L2 weights
	dff #(romaW) ROML1L2Addrdff (.din(rdAddrROM_L1L2_d),
				     .clk(clk),
				     .rst(rst),
				     .en(1'b1),
				     .q(rdAddrROM_L1L2));






endmodule
