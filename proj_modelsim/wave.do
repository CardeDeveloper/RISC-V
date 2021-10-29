onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /RISC_V_Single_Cycle_TB/clk_tb
add wave -noupdate -radix decimal /RISC_V_Single_Cycle_TB/DUV/ALU_UNIT/A_i
add wave -noupdate -radix decimal /RISC_V_Single_Cycle_TB/DUV/ALU_UNIT/B_i
add wave -noupdate -radix decimal /RISC_V_Single_Cycle_TB/DUV/ALU_UNIT/ALU_Result_o
add wave -noupdate /RISC_V_Single_Cycle_TB/DUV/PROGRAM_COUNTER/Next_PC
add wave -noupdate -radix decimal /RISC_V_Single_Cycle_TB/DUV/PROGRAM_COUNTER/PC_Value
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {32 ps}
