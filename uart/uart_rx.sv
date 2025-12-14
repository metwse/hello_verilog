module uart_rx
    #(parameter int CLKS_PER_BIT)
    (
    input wire clk,
    input wire serial_rx,
    output reg [7:0] received,
    output wire ready
    );

    localparam int Idle = 0;
    localparam int StartBit = 1;
    localparam int DataBits = 2;
    localparam int Ready = 3;

    reg [15:0] uart_clk = 0;
    reg [3:0] state = 0;
    reg [2:0] collected = 0;

    assign ready = state == Ready && uart_clk == CLKS_PER_BIT - 1;

    always @(posedge clk) begin
        if (state == Idle) begin
            if (serial_rx == 0) begin
                uart_clk = 0;
                state = StartBit;
            end
        end else if (uart_clk == CLKS_PER_BIT / 2) begin
            uart_clk++;

            unique case (state)
                StartBit:
            begin
                received <= 0;
                collected <= 0;

                state = DataBits;
            end
                DataBits:
            begin
                received[collected] = serial_rx;
                collected++;
                if (collected == 0)
                    state = Ready;
            end
            endcase
        end else begin
            uart_clk++;

            if (uart_clk == CLKS_PER_BIT) begin
                uart_clk <= 0;

                if (state == Ready)
                    state <= Idle;
            end
        end
    end

endmodule
