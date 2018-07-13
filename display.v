module display(
    input digi_in,
    output [7:0] digi_out,
    output [3:0] AN);

    assign digi_out = digi_in[7:0];
    assign AN = digi_in[11:8];

endmodule
