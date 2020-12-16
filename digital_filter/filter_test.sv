// Filter test module
module filter_test();
    // Values
    logic clock, reset;
    logic[31:0] low_pass, high_pass, xn;
    integer file, i;

    filter DUTT (.clk(clock), .rst(reset), .xn(xn), .low_pass(low_pass),
                 .high_pass(high_pass));

    always #100ns clock = ~clock;

    // Clock and reset release
    initial begin
        // Clock low at time zero
        clock = 0; reset = 1; xn = 32'h0100;
        @(posedge clock);
        @(posedge clock);
        @(negedge clock);
        reset = 0;
    end

    initial begin
        //file = $fopen("output.txt","w");

        // Wait for reset to be released
        @(negedge reset);
        // Wait for first clock out of reset
        @(posedge clock);

        for (i = 0; i < 4000; i = i + 1) begin
            @(posedge clock);
            $display("xn, high_pass %f, low_pass %f", high_pass, low_pass);
            xn <= xn + 32'b1;
            //$fwrite(file, "%b,%b\n", low_pass, high_pass);
        end

        //$fclose(file);
        //$finish;
    end
endmodule /* filter_test */
