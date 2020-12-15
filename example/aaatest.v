module aaatest();

  parameter width =4;
  reg   clk,reset;
  wire [width-1:0] out;
  reg  [width-1:0] lfsr[13:0];
  integer f,i;

  LFSR patt (clk,reset,out);

  always #5 clk=~clk;

  //Clock and reset release
  initial begin
    clk=0; reset=1; //Clock low at time zero
    @(posedge clk);
    @(posedge clk);
    reset=0;
  end

  initial begin
    f = $fopen("output.txt","w");

    @(negedge reset); //Wait for reset to be released
    @(posedge clk);   //Wait for fisrt clock out of reset

    for (i = 0; i<14; i=i+1) begin
      @(posedge clk);
      lfsr[i] <= out;
      $display("LFSR %b", out);
      $fwrite(f,"%b\n",   out);
    end

    $fclose(f);  

    $finish;
  end
endmodule