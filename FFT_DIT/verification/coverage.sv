// Define the covergroup OUTSIDE the module
covergroup cg_val (ref logic signed [15:0] r, ref logic signed [15:0] i);
    cp_r : coverpoint r;
    cp_i : coverpoint i;
endgroup