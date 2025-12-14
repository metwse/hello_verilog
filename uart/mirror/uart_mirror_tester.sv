`timescale 1ns / 1ps


module uart_mirror_tester(
    );

    localparam int Baud = 921600;

    localparam real SysclkPeriodNs = 83.3333;
    localparam real Clk72MhzPeriodNs = 13.8888;

    localparam real BaudLength = 1000000000.00 / Baud;
    localparam int ClksPerBit = BaudLength / Clk72MhzPeriodNs;


    reg sysclk = 0;
    reg clk_72mhz = 0;
    reg clk_72mhz_locked = 0;
    wire serial_rx;
    wire serial_tx_cloned;

    always #(SysclkPeriodNs / 2.0) sysclk = ~sysclk;

    always #(Clk72MhzPeriodNs / 2.0) clk_72mhz = ~clk_72mhz;

    main #(.CLKS_PER_BIT(ClksPerBit)) uut_main (
        .clk(clk_72mhz),
        .serial_rx(serial_rx),
        .serial_tx(serial_tx_cloned)
    );

    reg [7:0] outgoing_byte = 205;
    reg flush_pulse = 0;

    uart_tx #(.CLKS_PER_BIT(ClksPerBit)) uut_uart_tx (
        .clk(clk_72mhz),
        .serial_tx(serial_rx),
        .outgoing(outgoing_byte),
        .flush(flush_pulse),
        .busy()
    );

    initial @(posedge clk_72mhz_locked) begin
        flush_pulse = 1;
        #(Clk72MhzPeriodNs) flush_pulse = 0;
    end

    initial begin
        #(SysclkPeriodNs * 2) clk_72mhz_locked = 1;
    end

endmodule
