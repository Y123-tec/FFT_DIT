Architecture is : 

3. Fully Parallel / Unrolled Pipeline FFT (what you are describing):

All N inputs arrive in parallel in one clock cycle.

All N outputs appear in parallel after pipeline latency.

Each stage of butterflies is completely instantiated.

Pipeline registers are placed between stages.

Throughput = 1 complete N-point FFT per clock cycle.

Latency = log₂(N) (number of stages), plus multiplier pipeline delays.

Sometimes called parallel FFT, fully spatial FFT, or array-based FFT.

latancy is : 4 clk cycle then output every clk 