module main
    #(parameter int CLKS_PER_BIT)
    (
    input wire clk,
    input wire serial_rx,
    output wire serial_tx
    );

    wire [7:0] received_byte;
    wire rx_ready;

    reg [7:0] outgoing_byte;
    wire flush_pulse;

    uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) t_uart_rx (
        .clk(clk),
        .serial_rx(serial_rx),
        .incoming(received_byte),
        .ready(rx_ready)
    );

    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_uart_tx (
        .clk(clk),
        .serial_tx(serial_tx),
        .outgoing(outgoing_byte),
        .flush(flush_pulse),
        .busy()
    );

    assign flush_pulse = rx_ready;

    always @(posedge clk) begin
        if (rx_ready) begin
            outgoing_byte = received_byte;
        end
    end

endmodule