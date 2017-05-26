module counter(out, clk, reset);

  parameter WIDTH = 8;

  output logic [WIDTH-1 : 0] out;
  input logic      clk, reset;

  always @(posedge clk)
    out <= out + 1;

  always @reset
    if (reset)
      assign out = 0;
    else
      deassign out;

endmodule // counter
