onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fft_dit_tb/clk
add wave -noupdate -color Gold /fft_dit_tb/finish
add wave -noupdate -color Yellow /fft_dit_tb/enable
add wave -noupdate -color White -expand -subitemconfig {{/fft_dit_tb/y_r[0]} {-color White} {/fft_dit_tb/y_r[1]} {-color White} {/fft_dit_tb/y_r[2]} {-color White} {/fft_dit_tb/y_r[3]} {-color White} {/fft_dit_tb/y_r[4]} {-color White} {/fft_dit_tb/y_r[5]} {-color White} {/fft_dit_tb/y_r[6]} {-color White} {/fft_dit_tb/y_r[7]} {-color White}} /fft_dit_tb/y_r
add wave -noupdate -expand /fft_dit_tb/x_r
add wave -noupdate -expand /fft_dit_tb/DUT/stg1_r
add wave -noupdate /fft_dit_tb/DUT/stg2_r
add wave -noupdate /fft_dit_tb/DUT/stg3_r
add wave -noupdate /fft_dit_tb/rst
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {105000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {54177 ps} {164017 ps}
