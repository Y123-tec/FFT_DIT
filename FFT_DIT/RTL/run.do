vlib work
vlog *.*v
vsim -voptargs=+acc work.fft_dit_tb
do wave.do
run -all