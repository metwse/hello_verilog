`timescale 1ns / 1ps


module main_tester(
    );

    localparam real SysclkPeriodNs = 83.3333;
    localparam real Clk72MhzPeriodNs = 13.8888;

    reg sysclk = 0;
    reg clk_72mhz = 0;
    reg clk_72mhz_locked = 1;
    wire uart_rx;
    wire uart_tx;
    reg btn = 0;

    always #(SysclkPeriodNs / 2.0) sysclk = ~sysclk;

    always #(Clk72MhzPeriodNs / 2.0) clk_72mhz = ~clk_72mhz;

    main #(.BAUD(115200)) uut_main (
        .sysclk(sysclk),
        .clk_72mhz(clk_72mhz),
        .clk_72mhz_locked(clk_72mhz_locked),
        .uart_rx(uart_rx),
        .uart_tx(uart_tx),
        .btn(btn)
    );


    always #(SysclkPeriodNs * 15000) begin
        btn = 3;
        #(SysclkPeriodNs) btn = 0;
    end

endmodule
