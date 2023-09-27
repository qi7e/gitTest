setlocal enabledelayedexpansion
hdc -t xxxxxxx shell reboot bootloader
adb -s xxxxxxx reboot bootloader
hdc -t xxxxxxx shell "echo c >/proc/sysrq-trigger"
if not exist ptable.img(
	@echo "ptable is not exist"
	if exist ./fastboot_basepkg/ptable.img(
		@copy /y .\fastboot_basepkg\ptable.img .\
	)else(
		if exist ../fastboot_basepkg/ptable.img(
			@copy /y ..\fastboot_basepkg\ptable.img .\
		)else(
			@echo "there is not no ptable.img anywhere"
			@goto error
		)
	)
)
@call ptable_merget.exe -b ptable.img -c .\fastboot_custpkg\PTABLE_CUST.mbn -p fastboot_preloadpkg\PTABLE_PRELOAD.mbn
@if  not !ERRORLEVEL!==0(
	@echo "FAIL to  update ptable.img"
	@del ptable.img
	@goto error
)
fastboot -s xxxxxxx flash ptable "%~dp0ptable.img"
if  not !ERRORLEVEL!==0(
	goto error
)
hdc
@call:exec_sub_bat fastboot_custpkg update_custpkg_xxxxxxx.bat
@call:exec_sub_bat fastboot_preloadpkg update_preloadpkg_xxxxxxx.bat
if exist ..\fastboot_basepkg(
	@call:exec_sub_bat ..\fastboot_basepkg update_basepkg_xxxxxxx.bat
)else(
	@call:exec_sub_bat .\fastboot_basepkg update_basepkg_xxxxxxx.bat	
)
@goto success
:exec_sub_bat
@if exist %1(
	@cd %1
	@if exist %2(
		call %2
		if  not !ERRORLEVEL!==0(
			@cd..
			goto error
		)
	)else(
		echo "%2% not exist" 
		@cd ..
		goto error
	)
	@cd ..
)
@goto:eof
:success
@echo "update allpkg success"
@pause
@EXIT 0
@EXIT 0
:error
@echo "update allpkg failed"
@pause
@EXIT 1
