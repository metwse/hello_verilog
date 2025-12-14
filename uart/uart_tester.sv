`timescale 1ns / 1ns


module uart_tester(
    );

    localparam real ClkPeriodNs = 83.33;
    localparam real Baud = 4800;
    localparam real BaudLength = 1000000000 / Baud;
    localparam int ClksPerBit = BaudLength / ClkPeriodNs;

    reg clk;

    initial clk = 0;
    always #(ClkPeriodNs / 2.0) clk = ~clk;

    wire [7:0] received;
    wire rx_ready;

    uart_rx #(.CLKS_PER_BIT(ClksPerBit)) uut_rx (
        .clk(clk),
        .serial_rx(serial_tx),
        .received(received),
        .ready(rx_ready)
    );

    reg serial_tx;

    reg [7:0] to_sent;
    reg flush;
    wire busy;

    uart_tx #(.CLKS_PER_BIT(ClksPerBit)) uut_tx (
        .clk(clk),
        .serial_tx(serial_tx),
        .to_sent(to_sent),
        .flush(flush),
        .busy(busy)
    );

    initial begin
        to_sent = 213;
        #(ClkPeriodNs * 5) flush = 1;
        #(ClkPeriodNs) flush = 0;
    end

    always @(negedge busy) begin
        #(ClkPeriodNs) flush = 1;
        #(ClkPeriodNs) flush = 0;
    end
endmodule
