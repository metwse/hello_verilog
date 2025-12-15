// rotate
`define ROTL_VAL(a, b) ((a << b) | (a >> (32 - b)))

// quarter round
`define QR(a, b, c, d) \
    a = a + b; d = d ^ a; d = `ROTL_VAL(d, 16); \
    c = c + d; b = b ^ c; b = `ROTL_VAL(b, 12); \
    a = a + b; d = d ^ a; d = `ROTL_VAL(d, 8); \
    c = c + d; b = b ^ c; b = `ROTL_VAL(b, 7);


module chacha20_block(
    input wire clk,
    input wire start,
    input wire [31:0] state_in [16],
    output wire done,
    output reg [31:0] state_out [16]
    );

    reg [31:0] x [16];
    reg [31:0] initial_state [16];
    reg [3:0] round_counter = 0;

    int k;

    assign done = round_counter == 12;

    always @(posedge clk) begin
        if (start) begin
            for (k = 0; k < 16; k++) begin
                x[k] <= state_in[k];
                initial_state[k] <= state_in[k];
            end

            round_counter = 1;
        end else if (round_counter > 0 && round_counter < 11) begin
            // odd round
            `QR(x[0], x[4], x[ 8], x[12]);
            `QR(x[1], x[5], x[ 9], x[13]);
            `QR(x[2], x[6], x[10], x[14]);
            `QR(x[3], x[7], x[11], x[15]);

            // even round
            `QR(x[0], x[5], x[10], x[15]);
            `QR(x[1], x[6], x[11], x[12]);
            `QR(x[2], x[7], x[ 8], x[13]);
            `QR(x[3], x[4], x[ 9], x[14]);

            round_counter++;
        end else if (round_counter == 11) begin
            for (k = 0; k < 16; k++)
                state_out[k] <= initial_state[k] + x[k];

            round_counter++;
        end
    end

endmodule
