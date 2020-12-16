/**
 * This module performs a digital filter.
 *
 * Inputs:
 *      @clk - clock signal.
 *      @rst - reset signal.
 *
 * Outputs:
 *      @low_pass - filtered value by a low-pass filter.
 *      @high_pass - filtered value by a low-pass filter.
 */
module filter #(parameter N=32000)
               (input  logic clk, rst,
                input  logic[31:0] xn,
                output logic[31:0] low_pass, high_pass);

    logic[14:0] address;

    // w and y
    logic[31:0] low_pass_wn, low_pass_wn_1, low_pass_yn, low_pass_yn_1;
    logic[31:0] high_pass_wn, high_pass_wn_1, high_pass_yn, high_pass_yn_1;

    // Constant value for filters
    // -0.99686
    localparam LOW_PASS_A1 = 32'b1000_0000_0000_0000_1111_1111_0011_0010;
    // 0.0015683
    localparam LOW_PASS_B0 = 32'b0000_0000_0000_0000_0000_0000_0110_0110;
    // 0.0015683
    localparam LOW_PASS_B1 = 32'b0000_0000_0000_0000_0000_0000_0110_0110;
    // -0.72654
    localparam HIGH_PASS_A1 = 32'b1000_0000_0000_0000_1011_1001_1111_1110;
    // 0.86327
    localparam HIGH_PASS_B0 = 32'b0000_0000_0000_0000_1101_1100_1111_1111;
    // -0.86327
    localparam HIGH_PASS_B1 = 32'b1000_0000_0000_0000_1101_1100_1111_1111;

    always@(posedge clk or posedge rst) begin
        if (rst) begin
            address <= 0;
            low_pass_wn <= 32'b0;
            low_pass_wn_1 <= 32'b0;
            low_pass_yn <= 32'b0;
            low_pass_yn_1 <= 32'b0;
            high_pass_wn <= 32'b0;
            high_pass_wn_1 <= 32'b0;
            high_pass_yn <= 32'b0;
            high_pass_yn_1 <= 32'b0;
        end
        else begin
            if (clk) begin
                // Next address
                address <= address + 15'b1;

                // Set new n-1
                low_pass_wn_1 <= low_pass_wn;
                low_pass_yn_1 <= low_pass_yn;
                high_pass_wn_1 <= high_pass_wn;
                high_pass_yn_1 <= high_pass_yn;

                // w[n] = x[n] - a1*w[n - 1]
                // y[n] = b0*w[n] - b1*y[n - 1]

                // Low Pass Filter
                low_pass_wn <= xn - LOW_PASS_A1*low_pass_wn_1;
                low_pass_yn <= LOW_PASS_B0*low_pass_wn - LOW_PASS_B1*low_pass_yn_1;

                // High Pass Filter
                high_pass_wn <= xn - HIGH_PASS_A1*high_pass_wn_1;
                high_pass_yn <= HIGH_PASS_B0*high_pass_wn - HIGH_PASS_B1*high_pass_yn_1;
            end
        end
    end
	 
    assign low_pass = low_pass_yn;
    assign high_pass = high_pass_yn;

endmodule /* filter */
