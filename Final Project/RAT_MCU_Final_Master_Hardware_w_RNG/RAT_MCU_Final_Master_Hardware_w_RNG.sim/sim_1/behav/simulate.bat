@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xsim RAT_Wrapper_sim1_behav -key {Behavioral:sim_1:Functional:RAT_Wrapper_sim1} -tclbatch RAT_Wrapper_sim1.tcl -view C:/Users/Michael/Desktop/RAT_MCU_working_int/RAT_Wrapper_sim1_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
