@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.2\\bin
call %xv_path%/xelab  -wto f3e0034ce3954b15b97111eca86f8d4b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot RAT_Wrapper_sim1_behav xil_defaultlib.RAT_Wrapper_sim1 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
