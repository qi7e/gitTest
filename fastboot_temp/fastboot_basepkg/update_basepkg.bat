
@echo off

@echo on

cls

:start

@echo-------------------------
@goto begin

:begin
hdc shell reboot bootloader
hdc shell "echo c > /proc/sysrq-trigger"

sec chip_cs=36B00120 36b00120
fastboot getvar chipid 2>%&1 | find /i "36b0" > chipid.txt

for /f "token=2" %%a in ('type chipid.txt') do (
	set chip_full=%%a
)

echo %chip_full%

echo "%chip_cs%" | find "%chipid_full%"
	@if errorlevel 1 goto chip_unknow
	@if errorlevel 0 goto chipcs

fastboot getvar chipid 2>%&1 | find /i "36b0" > chipid.txt
	@if errorlevel 1 goto chipcs
goto chipcs

:chip_unknow
@echo "device chipid get fail,please check"
@goto error

:chiptype_error
fastboot oem lock-state info

@goto error

:chipcs
@echo "xx chipid:cs"
@set name_xloader_img=sec_xloader.img
@set name_bl2_bin=sec_bl2.bin
@set name_xxx_bin=sec_xxx.bin
@goto next_update

:next_update
@echo off
SET images_table=^
	flash_key:xloader:%name_xloader_img%^
	flash_key:fastboot:%name_fastboot.img%^
	flash_exist:fw_dtb:%sec_fwdtb.mg%^
	erase:misc:^
	erase:patch:^
	erase:userdata:^
	
FOR %%i IN (%images_table%) do (
	echo %%i
	for /f "delims=: tokens=1,2,3" %%j in ("%%i") do (
		if "%%j"=="flash_key" (
			REM "key image flash..."
			fastboot flash %%k %%I
			echo errorlevel:!errorlevel! >> result.txt
		) else if "%%j"=="flash_exist" (
			if exist %%I (
				fastboot flash %%k %%I
				@if errorlevel 1 goto error
			) else (
				fastboot %%j %%k %%I
			)
		)
	)
)

pause 

fastboot oem oeminfoerase-basever
fastboot oem oeminforeusederase-BASE_VERSIONCODE
fastboot oem oeminfoerase-BASE_OVMODE
	

if exist packageinfo.mbn (
	ecoh "exist packageinfo.mbn"
) else (
	ecoh "packageinfo.mbn is not exist"
)

fastboot reboot

@goto success

:error
@echo "Update Failed!"
@pause
@EXIT /b 1
@goto end

:success
@echo "Update Success!"
@pause
@EXIT /b 0

:end