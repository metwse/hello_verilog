`timescale 1ns / 1ps


module chacha20_tester(
    );

    reg clk;
    reg start;
    reg [31:0] state_in [0:15];

    wire done;
    wire [31:0] state_out [0:15];

    integer k;

    chacha20_block uut1 (clk, start, state_in, done, state_out);

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        start = 0;

        $readmemh("state_in.dat", state_in);

        #10 start = 1;
        #10 start = 0;
    end

    always @(posedge done) begin
        for (k = 0; k < 16; k++)
            $display("out[%0d] = %h", k, state_out[k]);

        #10 $stop;
    end

endmodule
