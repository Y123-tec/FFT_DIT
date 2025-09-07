module fft_dit_pipeline (
    input  wire                        clk,
    input  wire                        rst,
    input  wire                        enable,
    input  wire signed [15:0]          x_r [0:7],
    input  wire signed [15:0]          x_i [0:7],
    output reg                         finish,
    output reg signed [16:0]           y_r [0:7],
    output reg signed [16:0]           y_i [0:7]
);

parameter signed [14:0] par_a = 15'h2D41; // cos(pi/4) in Q1.14

//---------------------------------------------------------
// Pipeline registers for each stage
//---------------------------------------------------------
reg signed [16:0] stg1_r [0:7], stg1_i [0:7];
reg signed [16:0] stg2_r [0:7], stg2_i [0:7];
reg signed [16:0] stg3_r [0:7], stg3_i [0:7];

//---------------------------------------------------------
// Valid signal pipeline (tracks data validity)
//---------------------------------------------------------
parameter N = 8;
parameter STAGES = 3;

reg [3:0] finish_pipe;  

always @(posedge clk or posedge rst) begin
    if (!rst) begin
        finish_pipe <= '0;
    end else  begin
        // Shift finish through pipeline
        finish_pipe <= {finish_pipe[2:0], enable};
    end
end

assign finish = finish_pipe[3];

//---------------------------------------------------------
// Stage 1: Bit reversal
//---------------------------------------------------------
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (int i=0; i<8; i++) begin
            stg1_r[i] <= 0; stg1_i[i] <= 0;
        end
    end else if (enable) begin
        stg1_r[0] <= x_r[0]; stg1_i[0] <= x_i[0];
        stg1_r[1] <= x_r[4]; stg1_i[1] <= x_i[4];
        stg1_r[2] <= x_r[2]; stg1_i[2] <= x_i[2];
        stg1_r[3] <= x_r[6]; stg1_i[3] <= x_i[6];
        stg1_r[4] <= x_r[1]; stg1_i[4] <= x_i[1];
        stg1_r[5] <= x_r[5]; stg1_i[5] <= x_i[5];
        stg1_r[6] <= x_r[3]; stg1_i[6] <= x_i[3];
        stg1_r[7] <= x_r[7]; stg1_i[7] <= x_i[7];
    end
end

//---------------------------------------------------------
// Stage 2: First butterflies
//---------------------------------------------------------
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (int i=0; i<8; i++) begin
            stg2_r[i] <= 0; stg2_i[i] <= 0;
        end
    end else begin
        stg2_r[0] <= stg1_r[0] + stg1_r[1];
        stg2_i[0] <= stg1_i[0] + stg1_i[1];
        stg2_r[1] <= stg1_r[0] - stg1_r[1];
        stg2_i[1] <= stg1_i[0] - stg1_i[1];

        stg2_r[2] <= stg1_r[2] + stg1_r[3];
        stg2_i[2] <= stg1_i[2] + stg1_i[3];
        stg2_r[3] <= stg1_r[2] - stg1_r[3];
        stg2_i[3] <= stg1_i[2] - stg1_i[3];

        stg2_r[4] <= stg1_r[4] + stg1_r[5];
        stg2_i[4] <= stg1_i[4] + stg1_i[5];
        stg2_r[5] <= stg1_r[4] - stg1_r[5];
        stg2_i[5] <= stg1_i[4] - stg1_i[5];

        stg2_r[6] <= stg1_r[6] + stg1_r[7];
        stg2_i[6] <= stg1_i[6] + stg1_i[7];
        stg2_r[7] <= stg1_r[6] - stg1_r[7];
        stg2_i[7] <= stg1_i[6] - stg1_i[7];
    end
end

//---------------------------------------------------------
// Stage 3: Twiddle multiplication and second butterflies
//---------------------------------------------------------
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (int i=0; i<8; i++) begin
            stg3_r[i] <= 0; stg3_i[i] <= 0;
        end
    end else begin
        // k=0 pairs
        stg3_r[0] <= stg2_r[0] + stg2_r[2];
        stg3_i[0] <= stg2_i[0] + stg2_i[2];
        stg3_r[2] <= stg2_r[0] - stg2_r[2];
        stg3_i[2] <= stg2_i[0] - stg2_i[2];

        // k=2 pair (W = -j)
        stg3_r[1] <= stg2_r[1] + stg2_i[3];
        stg3_i[1] <= stg2_i[1] - stg2_r[3];
        stg3_r[3] <= stg2_r[1] - stg2_i[3];
        stg3_i[3] <= stg2_i[1] + stg2_r[3];

        // Upper half
        stg3_r[4] <= stg2_r[4] + stg2_r[6];
        stg3_i[4] <= stg2_i[4] + stg2_i[6];
        stg3_r[6] <= stg2_r[4] - stg2_r[6];
        stg3_i[6] <= stg2_i[4] - stg2_i[6];

        // k=2 pair (W = -j)
        stg3_r[5] <= stg2_r[5] + stg2_i[7];
        stg3_i[5] <= stg2_i[5] - stg2_r[7];
        stg3_r[7] <= stg2_r[5] - stg2_i[7];
        stg3_i[7] <= stg2_i[5] + stg2_r[7];
    end
end

//---------------------------------------------------------
// Stage 4: Final twiddle multiplies and output
//---------------------------------------------------------
   reg signed [31:0] ac, bd, ad, bc,ac_2, bd_2, ad_2, bc_2;
always @(posedge clk or negedge rst) begin
    if (!rst) begin
        for (int i=0; i<8; i++) begin
            y_r[i] <= 0; y_i[i] <= 0;
        end
       // finish <= 0;
    end else begin
        // Example final butterflies with twiddles (simplified)
        y_r[0] <= stg3_r[0] + stg3_r[4];
        y_i[0] <= stg3_i[0] + stg3_i[4];

        y_r[2] <= stg3_r[2] + stg3_i[6];
        y_i[2] <= stg3_i[2] - stg3_r[6];



        y_r[4] <= stg3_r[0] - stg3_r[4];
        y_i[4] <= stg3_i[0] - stg3_i[4];



        y_r[6] <= stg3_r[2] - stg3_i[6];
        y_i[6] <= stg3_i[2] + stg3_r[6];
        // Twiddle for y1 (W1 = (1-j)/√2)
     
        ac = stg3_r[5] * par_a;
        bd = stg3_i[5] * par_a;
        ad = stg3_r[5] * par_a;
        bc = stg3_i[5] * par_a;
        y_r[1] <= stg3_r[1] + ((ac + bd) >>> 14);
        y_i[1] <= stg3_i[1] + ((bc - ad) >>> 14);

        y_r[5] <= stg3_r[1] - ((ac + bd) >>> 14);
        y_i[5] <= stg3_i[1] - ((bc - ad) >>> 14);

        ac_2 = stg3_r[7] * par_a;
        bd_2 = stg3_i[7] * par_a;
        ad_2 = stg3_r[7] * par_a;
        bc_2 = stg3_i[7] * par_a;
        
        y_r[3] <= stg3_r[3] + ((-ac_2 + bd_2) >>> 14);
        y_i[3] <= stg3_i[3] + ((-bc_2 - ad_2) >>> 14);
        
        y_r[7] <= stg3_r[3] - ((-ac_2 + bd_2) >>> 14);
        y_i[7] <= stg3_i[3] - ((-bc_2 - ad_2) >>> 14);


        // Similar for y3, y5, y7 ...
        // (fill in with the same style twiddle multiplies as your original)

        /*

        y_r[0] = stg2_r[0] + stg2_r[4];
        y_i[0] = stg2_i[0] + stg2_i[4];
        
        y_r[1] = (stg2_r[1] + out_r_1) ;
        y_i[1] = (stg2_i[1] + out_i_1) ;
        
        
        y_r[2] = stg2_r[2] + stg2_i[6];
        y_i[2] = stg2_i[2] - stg2_r[6];
        
        y_r[3] = stg2_r[3] + out_r_2;
        y_i[3] = stg2_i[3] + out_i_2;
        
        y_r[4] = stg2_r[0] - stg2_r[4];
        y_i[4] = stg2_i[0] - stg2_i[4];
        
        y_r[5] = stg2_r[1] - out_r_1;
        y_i[5] = stg2_i[1] - out_i_1;
        
        y_r[6] = stg2_r[2] - stg2_i[6];
        y_i[6] = stg2_i[2] + stg2_r[6];
        
        y_r[7] = stg2_r[3] - out_r_2;
        y_i[7] = stg2_i[3] - out_i_2;
                    */
        
                
            end
   // finish <= valid_pipe[4];
end

endmodule
