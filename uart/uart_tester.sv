`timescale 1ns / 1ns


module uart_tester(
    );

    localparam real ClkPeriodNs = 83.33;
    localparam real Baud = 9600;
    localparam real BaudLength = 1000000000 / Baud;
    localparam int ClksPerBit = BaudLength / ClkPeriodNs;

    reg clk = 0;

    always #(ClkPeriodNs / 2.0) clk = ~clk;

    wire serial_transmission_medium;

    wire [7:0] incoming;
    wire rx_ready;

    uart_rx #(.CLKS_PER_BIT(ClksPerBit)) uut_uart_rx (
        .clk(clk),
        .serial_rx(serial_transmission_medium),
        .incoming(incoming),
        .ready(rx_ready)
    );

    reg [7:0] outgoing;
    reg flush;
    wire busy;

    uart_tx #(.CLKS_PER_BIT(ClksPerBit)) uut_uart_tx (
        .clk(clk),
        .serial_tx(serial_transmission_medium),
        .outgoing(outgoing),
        .flush(flush),
        .busy(busy)
    );

    initial begin
        outgoing = 213;
        #(ClkPeriodNs * 5) flush = 1;
        #(ClkPeriodNs) flush = 0;
    end

    always @(negedge busy) begin
        #(ClkPeriodNs) flush = 1;
        #(ClkPeriodNs) flush = 0;
    end
endmodule
