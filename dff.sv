module dff
        #(parameter int size = 1 ) // Our first module parameter! Now everything is squishy
        (
        input logic [size-1:0]  din,
        input logic         clk,
        input logic         rst,
        input logic         en,
        output logic [size-1:0] q
    );

        logic [size-1:0]       rst_val ; // To avoid assigning a constant of unspec length
        logic [size-1:0]        d ;       // Internal version of d
        logic [size-1:0]        q_val;    // Internal version of q_val

        assign    d[size-1:0] = din[size-1:0]; //Delay data in to prevent inf. loops
        assign    q           = q_val ;
        assign    rst_val     = 0 ;

        always @ (posedge clk) begin //should be always_ff
                case ( 1'b1 ) // should be priority case
                (~rst): q_val[size-1:0]  <=  rst_val[size-1:0] ;  //Reset is active low
                ( en):  q_val[size-1:0]  <=        d[size-1:0] ;  //Enable is active high
                (~en):  q_val[size-1:0]  <=        q[size-1:0] ;  //Enable is active high
        endcase
    end

endmodule //dff
