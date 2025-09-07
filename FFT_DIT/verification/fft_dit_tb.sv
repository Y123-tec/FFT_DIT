`timescale 1ns/1ps
`include "coverage.sv"

module fft_dit_tb();

    // Parameters
    parameter clock_period   = 10.0;
    parameter TOTAL_VECTORS  = 80; 
    parameter FFT_SIZE       = 8;
    reg [1024:0] cout_pass, cout_failed;

    // DUT I/O
    reg  signed [15:0] x_r [0:FFT_SIZE-1];
    reg  signed [15:0] x_i [0:FFT_SIZE-1];
    reg                rst;
    reg                clk;
    reg                enable;
    wire               finish;
    wire signed [16:0] y_r [0:FFT_SIZE-1];
    wire signed [16:0] y_i [0:FFT_SIZE-1];
    
    // Storage
    reg signed [15:0] all_in_r  [0:TOTAL_VECTORS-1];
    reg signed [15:0] all_in_i  [0:TOTAL_VECTORS-1];
    reg signed [16:0] all_exp_r [0:TOTAL_VECTORS-1];
    reg signed [16:0] all_exp_i [0:TOTAL_VECTORS-1];

    // Chunked expected values
    reg signed [16:0] expected_r [0:FFT_SIZE-1];
    reg signed [16:0] expected_i [0:FFT_SIZE-1];

    // Coverage
    cg_val my_cov;
    

    /////////////////// instantiation ////////////////////////////
    fft_dit_pipeline DUT (   // <<< FIX: use pipelined DUT
        .clk(clk),
        .rst(rst),
        .x_r(x_r),
        .x_i(x_i),
        .enable(enable),
        .finish(finish),
        .y_r(y_r),
        .y_i(y_i)
    );

    /////////////////// clock generation /////////////////////////
    always #(clock_period / 2.0) clk = ~clk;

    /////////////////// initial block ////////////////////////////
    initial begin
        my_cov = new(x_r[0], x_i[0]); 
        initialize();
        reset();
        
        // Read all vectors
        $readmemb("fft_input_real_binary.txt", all_in_r);
        $readmemb("fft_input_imag_binary.txt", all_in_i);
        $readmemb("fft_output_real_binary.txt", all_exp_r);
        $readmemb("fft_output_imag_binary.txt", all_exp_i);

        // Apply input chunks
        for (int offset = 0; offset < TOTAL_VECTORS; offset += FFT_SIZE) begin
          //  @(posedge clk);
            load_chunk(offset);

           // Start pipeline
        //@(posedge clk);
        enable = 1'b1;
        @(posedge clk);
        enable = 1'b0;

        // Wait for pipeline finish + check results
        //check_results(offset);
            if(finish)
             begin
                for (int i = 0; i < FFT_SIZE; i++) begin
            expected_r[i] = all_exp_r[offset-16-8-8 + i];
            expected_i[i] = all_exp_i[offset-16 -8-8 + i];
        end
               check_results(offset); 
            end
        end

        #(clock_period*50);
        $display("the count pass is : %0d ", cout_pass);
        $display("the count fail is : %0d ", cout_failed);
        $stop();
    end


    initial begin
        

    end

    /////////////////// task initialize //////////////////////////
    task initialize();
        clk    = 0;
        rst    = 1;
        enable = 0;
        cout_pass = 0;
        cout_failed = 0;
        for (int i = 0; i < FFT_SIZE; i++) begin
            x_r[i] = 0;
            x_i[i] = 0;
        end
    endtask

    /////////////////// task reset ///////////////////////////////
    task reset();
        #(clock_period);
        rst = 1'b0;
        #(clock_period);
        rst = 1'b1;
        #(clock_period);
    endtask

    /////////////////// task load_chunk //////////////////////////
    task load_chunk(input int offset);
        for (int i = 0; i < FFT_SIZE; i++) begin
            x_r[i] = all_in_r[offset + i];
            x_i[i] = all_in_i[offset + i];
        end
        my_cov.sample(); // <<< FIX: sample after loading
    endtask



    /////////////////// task check_results ///////////////////////
   task check_results(input int offset);

         //wait(finish);
        for (int i = 0; i < 8; i++)
         begin
             //#(clock_period);
            $display("Output[%0d]: RTL Real=%b (%.4f), Img=%b (%.4f) | Expected Real=%b (%.4f), Img=%b (%.4f)",
                i,
                y_r[i], $itor(y_r[i])/(1<<17),
                y_i[i] , $itor(y_i[i])/(1<<17),
                expected_r[i], $itor(expected_r[i])/(1<<17),
                expected_i[i], $itor(expected_i[i])/(1<<17));

            if ((y_r[i] - expected_r[i] > 1) || (expected_r[i] - y_r[i] > 1) ||
                (y_i[i] - expected_i[i] > 1) || (expected_i[i] - y_i[i] > 1)) 
            begin
                $display("[FAILED] --> MISMATCH at index %0d! (Tolerance exceeded)", offset + i);
            cout_failed = cout_failed +1;
            
            end
          else 
            begin
             $display("the test case NUM [%0d] is  [PASSED]  ",offset + i);  
             cout_pass = cout_pass +1; 
            end
            if(i== 7 || i== 15|| i== 23|| i== 31|| i== 39|| i== 47|| i== 55|| i== 63|| i== 71|| i== 79)begin
                  $display("*****************************************");
                  $display("***   the 8 element check is done   *** " );
                  $display("****************************************"); 
            end   
        end
    endtask

endmodule
