# 
# Synthesis run script generated by Vivado
# 

set_param xicom.use_bs_reader 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.cache/wt [current_project]
set_property parent.project_path C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language VHDL [current_project]
read_vhdl -library xil_defaultlib {
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/SCR_DATA_IN_MUX.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/SCR_ADDR_MUX.vhd
  {C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/RAT MCU Submodules [WORKING]/SCR.vhd}
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/REG_FILE_MUX.vhd
  {C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/RAT MCU Submodules [WORKING]/REG_FILE.vhd}
  {C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/RAT MCU Submodules [WORKING]/PC_MUX.vhd}
  {C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/RAT MCU Submodules [WORKING]/PC.vhd}
  {C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/RAT MCU Submodules [WORKING]/FLAGS.vhd}
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/ControlUnit.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/ALU_MUX.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Michael/experiment6platinum/experiment6platinum.srcs/sources_1/new/ALU.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/new/RAT_MCU.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Desktop/SP.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Downloads/INTERRUPT.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/VGA/ram2k_8.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/VGA/vgaDriverBuffer.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/VGA/VGAdrive.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/VGA/vga_clk_div.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/ETCHASKETCH_BASYS3_F2015/clock_div2.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Keyboard/RAT_Wrapper.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Keyboard/KeyboardDriver.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/SSEG/sseg_dec.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/Other/Pseudo_Random.vhd
  C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/sources_1/imports/FinalAssembly/prog_rom.vhd
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/constrs_1/imports/ETCHASKETCH_BASYS3_F2015/Basys3_Master.xdc
set_property used_in_implementation false [get_files C:/Users/Michael/Desktop/RAT_MCU_Final_Master_Hardware_w_RNG/RAT_MCU_Final_Master_Hardware_w_RNG.srcs/constrs_1/imports/ETCHASKETCH_BASYS3_F2015/Basys3_Master.xdc]


synth_design -top RAT_wrapper -part xc7a35tcpg236-1


write_checkpoint -force -noxdef RAT_wrapper.dcp

catch { report_utilization -file RAT_wrapper_utilization_synth.rpt -pb RAT_wrapper_utilization_synth.pb }
