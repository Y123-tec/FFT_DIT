# Corrected run.do file for QuestaSim 2021.1
vlog fft_dit_pipeline.sv fft_dit_tb.sv +cover
vsim work.fft_dit_tb -coverage
coverage save -onexit cov.ucdb
run -all
coverage report -details -output cov_report.txt
exit