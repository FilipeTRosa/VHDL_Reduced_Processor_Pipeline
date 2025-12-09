onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /tb/clock_sg
add wave -noupdate -radix decimal /tb/reset_sg
add wave -noupdate -divider Processador
add wave -noupdate -radix decimal /tb/inst_processador_pipe/clock
add wave -noupdate -radix decimal /tb/inst_processador_pipe/reset
add wave -noupdate -radix decimal /tb/inst_processador_pipe/inst
add wave -noupdate -radix decimal /tb/inst_processador_pipe/pc
add wave -noupdate -radix binary /tb/inst_processador_pipe/opcode
add wave -noupdate -radix decimal /tb/inst_processador_pipe/reg0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/reg1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/regDest
add wave -noupdate -radix decimal /tb/inst_processador_pipe/imm
add wave -noupdate -radix decimal /tb/inst_processador_pipe/IF_ID
add wave -noupdate -radix decimal /tb/inst_processador_pipe/controle_ID_EX
add wave -noupdate -radix decimal /tb/inst_processador_pipe/controle_EX_MEM
add wave -noupdate -radix decimal /tb/inst_processador_pipe/controle_MEM_WB
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brOut0ID_EX
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brOut1ID_EX
add wave -noupdate -radix decimal /tb/inst_processador_pipe/immID_EX
add wave -noupdate -radix decimal /tb/inst_processador_pipe/immEX_MEM
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brOut0EX_MEM
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaOutEX_MEM
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaOutMEM_WB
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memDataOutMEM_WB
add wave -noupdate -radix decimal /tb/inst_processador_pipe/immMEM_WB
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memInst
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_opcode
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_brEnable
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_ulaOp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/muxUlaIn1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/muxBrData
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_jump
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_memIn
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_branch
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_memToReg
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ctl_branchNe
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaOut
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaIn0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaIn1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaOp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaComp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memDataEnd
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memDatain
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memDataOut
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memEnable
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memToReg
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brReg0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brReg1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brRegDest
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brData
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brEnable
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brOut0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/brOut1
add wave -noupdate -divider ULA
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/ulaOp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/ulaIn_0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/ulaIn_1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/ulaOut
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/ulaComp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/comp
add wave -noupdate -radix decimal /tb/inst_processador_pipe/ulaProcess/multi
add wave -noupdate -divider CONTROLE
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_opcode
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_brEnable
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_ulaOp
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/muxUlaIn1
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/muxBrData
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_jump
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_memIn
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_branch
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_memToReg
add wave -noupdate -radix binary /tb/inst_processador_pipe/controleProcess/ctl_branchNe
add wave -noupdate -divider {B REGISTRADORES}
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brReg0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brReg1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brRegDest
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brData
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brEnable
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/clock
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brOut0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/brOut1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/br_o
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/endBr0
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/endBr1
add wave -noupdate -radix decimal /tb/inst_processador_pipe/bregistradoresProcess/endRegDest
add wave -noupdate -divider {MEMORIA DADOS}
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/memDataEnd
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/memDataOut
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/opcode
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/memDataIn
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/memEnable
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/memToReg
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/clock
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/mem_ram
add wave -noupdate -radix decimal /tb/inst_processador_pipe/memoriaProcess/endInt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 297
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {46300 ps}
