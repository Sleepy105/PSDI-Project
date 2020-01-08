onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /s6base_tb/reset_n
add wave -noupdate /s6base_tb/leds
add wave -noupdate /s6base_tb/rx
add wave -noupdate /s6base_tb/tx
add wave -noupdate /s6base_tb/uart_txen
add wave -noupdate /s6base_tb/uart_rxready
add wave -noupdate /s6base_tb/uart_txready
add wave -noupdate /s6base_tb/uart_din
add wave -noupdate /s6base_tb/uart_dout
add wave -noupdate /s6base_tb/wspeed
add wave -noupdate /s6base_tb/wangle
add wave -noupdate /s6base_tb/spdX
add wave -noupdate /s6base_tb/spdY
add wave -noupdate /glbl/GSR
add wave -noupdate /s6base_tb/s6base_top_1/P0out
add wave -noupdate /s6base_tb/s6base_top_1/P1out
add wave -noupdate /s6base_tb/s6base_top_1/P2out
add wave -noupdate /s6base_tb/s6base_top_1/P3out
add wave -noupdate /s6base_tb/s6base_top_1/P4out
add wave -noupdate /s6base_tb/s6base_top_1/P5out
add wave -noupdate /s6base_tb/s6base_top_1/P6out
add wave -noupdate /s6base_tb/s6base_top_1/P7out
add wave -noupdate /s6base_tb/s6base_top_1/P8out
add wave -noupdate /s6base_tb/s6base_top_1/P9out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {956193441100 ps} {956576831522 ps}
