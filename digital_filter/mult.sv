/**
 * This module performs a multiplication.
 *
 * Inputs:
 *      @clk - clock signal.
 *      @rst - reset signal.
 *      @value1 - first operand.
 *      @value2 - second operand.
 *
 * Outputs:
 *      @result - multiplication result.
 */
module mult (input logic clk, rst,
             input logic [1:0] cycle,
             input logic[31:0] value1, value2,
             output logic[31:0] result);

    // Temp values
    logic[15:0] a, b, c, d;
    logic[31:0] mult_high, mult_mid, mult_low, mult_result;
    logic[31:0] value1_temp, value2_temp, result_temp;
    logic[31:0] shifted_high, shifted_low;
    logic[1:0] current;

    always@(posedge clk) begin
        if (rst == 1'b0) begin
            if (current == cycle) begin
                if (value1[31] == 1'b1) begin
                    value1_temp = {~value1[31:16] + 16'b1, value1[15:0]};
                end
                else begin
                    value1_temp = value1;
                end

                if (value2[31] == 1'b1) begin
                    value2_temp = {~value2[31:16] + 16'b1, value2[15:0]};
                end
                else begin
                    value2_temp = value2;
                end

                // Mult values Qa.b x Qc.d
                a = value1_temp[31:16];
                b = value1_temp[15:0];
                c = value2_temp[31:16];
                d = value2_temp[15:0];

                // Compute high, mid and low
                mult_high = a*c;
                mult_mid = a*d + b*c;
                mult_low = b*d;

                shifted_high = mult_high << 16;
                shifted_low = mult_low >> 16;

                mult_result = shifted_high + mult_mid + shifted_low;

                if ((value1[31] == 1'b1) && (value2[31] == 1'b1)) begin
                    result_temp = mult_result;
                end
                else if ((value1[31] == 1'b1) || (value2[31] == 1'b1)) begin
                    result_temp = {~mult_result[31:16] + 16'b1, mult_result[15:0]};
                end
                else begin
                    result_temp = mult_result;
                end

                current <= current + 2'b1;
            end
            else if (current == 2'b10) begin
                current <= 2'b0;
            end
            else begin
                current <= current + 2'b1;
            end
        end
        else begin
            result_temp <= 32'b0;
            current <= 2'b0;
        end
    end

    assign result = result_temp;
endmodule /* mult */
