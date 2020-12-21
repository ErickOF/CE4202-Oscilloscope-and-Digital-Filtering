// Filter test module
module filter_test();
    // Values
    logic clock, reset;
    logic[31:0] low_pass, high_pass, xn, tmp;

    // For file descriptors
    integer input_file, output_file;

    // Q15.16 scaling factor
    localparam sf = 5.0/(2.0**23.0);

    filter DUTT (.clk(clock), .rst(reset), .xn(xn), .low_pass(low_pass),
                 .high_pass(high_pass));

    always #10ns clock = ~clock;

    // Clock and reset release
    initial begin
        // Clock low at time zero
        clock = 0; reset = 1;
        @(posedge clock);
        @(posedge clock);
        @(negedge clock);
        reset = 0;
    end

    initial begin
        // Open input file
        input_file = $fopen("C:/Users/erick/Documents/Git/CE4202-Oscilloscope-and-Digital-Filtering/digital_filter/data_sample.txt", "r");
        // Create the output file
        output_file = $fopen("C:/Users/erick/Documents/Git/CE4202-Oscilloscope-and-Digital-Filtering/digital_filter/output.txt", "w");

        // Wait for reset to be released
        @(negedge reset);

        // Read line by line until an "end of file" is reached
        while (! $feof(input_file)) begin
            // Scan each line and get the value as a binary
            tmp = $fscanf(input_file, "%b\n", xn);

            // Wait some time
            @(negedge clock);
            @(posedge clock);
            @(negedge clock);
            @(posedge clock);
            @(negedge clock);
            @(posedge clock);

            // Write into the file
            $fwrite(output_file, "%b,%b\n", low_pass, high_pass);
        end

        $fclose(input_file);
        $fclose(output_file);
        $finish;
    end
endmodule /* filter_test */
