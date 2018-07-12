module display(
    input digi_in,
    output digi_out_1,
    output digi_out_2,
    output digi_out_3，
    output digi_out_4);

    assign digi_out_1 = digi_in[11:8] == 4'b0001? digi_in[7:0]: 7'b0;
    assign digi_out_2 = digi_in[11:8] == 4'b0010? digi_in[7:0]: 7'b0;
    assign digi_out_3 = digi_in[11:8] == 4'b0100? digi_in[7:0]: 7'b0;
    assign digi_out_4 = digi_in[11:8] == 4'b1000? digi_in[7:0]: 7'b0;

endmodule
