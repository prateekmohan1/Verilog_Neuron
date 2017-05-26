module neuron_tb;

  /* Make a reset that pulses once. */
  logic reset;
  int lp;
  initial begin
     $dumpfile("neuron.vcd");
     $dumpvars(0,neuron_tb);
     for (lp=0; lp < 784; lp = lp+1) $dumpvars(0, neuron_tb.n1.ROML1L2weights.mem[lp]);
     for (lp=0; lp < 784; lp = lp+1) $dumpvars(0, neuron_tb.n1.L1L2LocalWeights.mem[lp]);

     reset = 1;
     clk = 0;

     #230;
     reset = 1'b0;
     
     #500;
     reset = 1'b1;

     #1000000;
     $finish;
  end

  /* Make a regular pulsing clock. */
  logic clk;

  always begin
    #250 clk = ~clk;
  end

  neuron n1 (clk, reset);

endmodule // test
