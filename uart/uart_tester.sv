`timescale 1ns / 1ns


module uart_tester(
    );

    parameter int CLK_PERIOD_NS = 83.33;
    parameter int BAUD = 115200;
    parameter int BAUD_LENGTH = 1000000000 / BAUD;
    parameter int CLKS_PER_BIT = BAUD_LENGTH / CLK_PERIOD_NS;

    reg clk;

    initial clk = 0;
    always #(CLK_PERIOD_NS / 2.0) clk = ~clk;

    wire [6:0] received;
    wire rx_ready;

    uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uut_rx (
        .clk(clk),
        .serial_rx(serial_tx),
        .received(received),
        .ready(rx_ready)
    );

    reg serial_tx;

    reg [6:0] to_sent;
    reg flush;
    wire busy;

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) uut_tx (
        .clk(clk),
        .serial_tx(serial_tx),
        .to_sent(to_sent),
        .flush(flush),
        .busy(busy)
    );

    initial begin
        to_sent = 115;
        #(CLK_PERIOD_NS * 5) flush = 1;
        #(CLK_PERIOD_NS) flush = 0;
    end

    always @(negedge busy) begin
        #(CLK_PERIOD_NS) flush = 1;
        #(CLK_PERIOD_NS) flush = 0;
    end
endmodule
