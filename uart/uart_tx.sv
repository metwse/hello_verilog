module uart_tx
    #(parameter int CLKS_PER_BIT)
    (
    input wire clk,
    output wire serial_tx,
    input wire [7:0] outgoing,
    input wire flush,
    output wire busy
    );

    localparam int Idle = 0;
    localparam int StartBit = 1;
    localparam int DataBits = 2;

    reg [15:0] uart_clk = 0;
    reg [2:0] state = Idle;
    reg [2:0] sent = 0;

    assign busy = state != Idle;
    assign serial_tx = state == DataBits ?
                                    outgoing[7 - sent] :
                                    (state == Idle ? 1 : 0);

    always @(posedge clk) begin
        if (state == Idle) begin
            if (flush) begin
                uart_clk <= 0;
                sent <= 7;
                state <= StartBit;
            end
        end else if (flush == 0) begin
            uart_clk++;

            if (uart_clk == CLKS_PER_BIT) begin
                uart_clk <= 0;

                unique case (state)
                    StartBit:
                begin
                    state <= DataBits;
                end
                    DataBits:
                begin
                    sent--;
                    if (sent == 7)
                        state <= Idle;
                end
                endcase
            end
        end
    end

endmodule
