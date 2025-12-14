module main
    #(parameter int BAUD)
    (
    input wire sysclk,
    input wire clk_72mhz,
    input wire clk_72mhz_locked,
    input wire uart_rx,
    output wire uart_tx,
    input wire btn
    );

    localparam real ClkPeriodNs = 13.8888;
    localparam real BaudLength = 1000000000.00 / BAUD;
    localparam real ClksPerBit = BaudLength / ClkPeriodNs;

    wire [7:0] char_a = 65;

    reg btn_prev = 0;
    wire send_pulse;

    always @(posedge clk_72mhz) begin
        btn_prev <= btn;
    end

    assign flush_pulse = clk_72mhz_locked && btn == 1 && btn_prev == 0;

    uart_tx #(.CLKS_PER_BIT(ClksPerBit)) u_tx (
        .clk(clk_72mhz),
        .serial_tx(uart_tx),
        .outgoing(char_a),
        .flush(flush_pulse),
        .busy()
    );

endmodule

