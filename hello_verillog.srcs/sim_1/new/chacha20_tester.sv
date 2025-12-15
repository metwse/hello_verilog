`timescale 1ns / 1ps


module chacha20_tester(
    );

    reg clk;
    reg start;
    reg [31:0] state_in [16];

    wire done;
    wire [31:0] state_out [16];

    int k;

    chacha20_block uut1 (
        .clk(clk), .start(start), .state_in(state_in),
        .done(done), .state_out(state_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        start = 0;

        $readmemh("chacha20_state_in.dat", state_in);

        #10 start = 1;
        #10 start = 0;
    end

    always @(posedge done) begin
        for (k = 0; k < 16; k++)
            $display("out[%0d] = %h", k, state_out[k]);

        #10 $stop;
    end

endmodule