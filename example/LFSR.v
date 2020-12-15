module LFSR( clk,reset,out);
parameter width =4;
input clk,reset;
output [width-1:0] out ;
reg [width-1:0] lfsr;

integer r;
wire feedback = lfsr[width-1]^lfsr[width-2];


always @(posedge clk)
  if (reset)
    begin
      lfsr <= 4'b1000; 
    end
  else
    begin
      lfsr[0] <= feedback;
      for(r=1;r<width;r=r+1)
        lfsr[r]<=lfsr[r-1];
    end

  assign out=lfsr;
endmodule