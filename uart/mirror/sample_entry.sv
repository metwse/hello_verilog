module entry(
    input sysclk,
    input uart_txd_in,
    output uart_rxd_out
    );

    localparam int Baud = 921600;
    localparam real ClkPeriodNs = 13.8888;

    localparam real BaudLength = 1000000000.00 / Baud;
    localparam real ClksPerBit = BaudLength / ClkPeriodNs;

    wire clk;

    clk_wiz_0 u_clk_72mhz (
        .clk_in1(sysclk),
        .clk_out1(clk),
        .locked()
    );

    uart_mirror #(.CLKS_PER_BIT(ClksPerBit)) u_main (
        .clk(clk),
        .serial_rx(uart_txd_in),
        .serial_tx(uart_rxd_out)
    );

endmodule
