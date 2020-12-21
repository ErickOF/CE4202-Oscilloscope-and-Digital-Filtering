/**
 * This module performs a digital filter.
 *
 * Inputs:
 *      @clk - clock signal.
 *      @rst - reset signal.
 *      @xn - value to apply the filter.
 *
 * Outputs:
 *      @low_pass - filtered value by a low-pass filter.
 *      @high_pass - filtered value by a low-pass filter.
 */
module filter (input  logic clk, rst,
               input  logic[31:0] xn,
               output logic[31:0] low_pass, high_pass);

    // Temp values
    logic[31:0] mult1, mult2, mult3, mult4, mult5, mult6;
    logic[1:0] current;

    // w and y
    logic[31:0] low_pass_wn, low_pass_wn_1, low_pass_yn;
    logic[31:0] high_pass_wn, high_pass_wn_1, high_pass_yn;

    // Constant value for filters
    // -0.99686
    localparam LOW_PASS_A1 = {~16'b0000_0000_0001_1001 + 16'b1, 16'b1000_0101_0000_0110};
    // 0.0015683
    localparam LOW_PASS_B0 = 32'b0000_0000_0000_0000_0000_1010_0100_0111;
    // 0.0015683
    localparam LOW_PASS_B1 = 32'b0000_0000_0000_0000_0000_1010_0100_0111;
    // -0.72654
    localparam HIGH_PASS_A1 = {~16'b0000_0000_0001_0010 + 16'b1, 16'b1001_1001_0111_0100};
    // 0.86327
    localparam HIGH_PASS_B0 = 32'b0000_0000_0001_0110_0001_1001_1000_0111;
    // -0.86327
    localparam HIGH_PASS_B1 = {~16'b0000_0000_0001_0110 + 16'b1, 16'b0001_1001_1000_0111};

    // Multiplication modules
    mult m1(.clk(clk), .rst(rst), .value1(LOW_PASS_A1),
            .value2(low_pass_wn_1), .result(mult1), .cycle(2'b0));
    mult m2(.clk(clk), .rst(rst), .value1(LOW_PASS_B0),
            .value2(low_pass_wn), .result(mult2), .cycle(2'b1));
    mult m3(.clk(clk), .rst(rst), .value1(LOW_PASS_B1),
            .value2(low_pass_wn_1), .result(mult3), .cycle(2'b0));
    mult m4(.clk(clk), .rst(rst), .value1(HIGH_PASS_A1),
            .value2(high_pass_wn_1), .result(mult4), .cycle(2'b0));
    mult m5(.clk(clk), .rst(rst), .value1(HIGH_PASS_B0),
            .value2(high_pass_wn), .result(mult5), .cycle(2'b1));
    mult m6(.clk(clk), .rst(rst), .value1(HIGH_PASS_B1),
            .value2(high_pass_wn_1), .result(mult6), .cycle(2'b0));

    always@(clk or rst) begin
        if (rst) begin
            low_pass_wn <= 32'b0;
            low_pass_wn_1 <= 32'b0;
            low_pass_yn <= 32'b0;
            high_pass_wn <= 32'b0;
            high_pass_wn_1 <= 32'b0;
            high_pass_yn <= 32'b0;
            current <= 1'b0;
        end
        else begin
            if (clk) begin
                // w[n] = x[n] - a1*w[n - 1]
                // y[n] = b0*w[n] + b1*w[n - 1]

                if (current == 2'b0) begin
                    // Low Pass Filter
                    low_pass_wn <= xn - mult1;
                    // High Pass Filter
                    high_pass_wn <= xn - mult4;

                    current <= current + 2'b1;
                end
                else if (current == 2'b1) begin
                    // Low Pass Filter
                    low_pass_yn <= mult2 + mult3;
                    // High Pass Filter
                    high_pass_yn <= mult5 + mult6;

                    current <= current + 2'b1;
                end
                else begin
                    // Low Pass Filter
                    low_pass_yn <= mult2 + mult3;
                    // High Pass Filter
                    high_pass_yn <= mult5 + mult6;

                    // Set new n-1
                    low_pass_wn_1 <= low_pass_wn;
                    high_pass_wn_1 <= high_pass_wn;

                    current <= 2'b0;
                end
            end
        end
    end

    assign low_pass = low_pass_yn;
    assign high_pass = high_pass_yn;

endmodule /* filter */
