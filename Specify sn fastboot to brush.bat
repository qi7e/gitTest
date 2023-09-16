@echo off
setlocal enabledelayedexpansion

if exist update_allpkg.bat (
	copy update_allpkg.bat update_allpkg.txt
)

set SN=444444
set input_file=update_allpkg.bat
set update_allpkg_SN=update_allpkg_%SN%.bat
set str1=hdc
set "str1_replace=hdc -t %SN% "
set str2=adb
set "str3=fastboot "
set "str3_replace=fastboot -s %SN% "
set update_custpkg=update_custpkg.bat
set update_preloadpkg=update_preloadpkg.bat


set errlevel=!errorlevel
set errno=!==0

del 1.txt

set "subStr=fastboot "
set "str=fastboot flash fastboot fastboot "

call:exec_count_subStr "!str!"
echo strlen:!strlen! >> 1.txt
set "str_len=!strlen!"
echo str_len:!str_len! >> 1.txt

call:exec_count_subStr "!subStr!"
set "subStr_len=!strlen!"
echo subStr_len:!subStr_len! >> 1.txt

::call:exec_count_subStr "!str!" "!subStr!" !strlen!

REM 若标签参数是字符串变量，存在空白字符，会被分割并当成多个字符参数传递，所以需双引号引起来；计算的字符串长度时-2，或传参接收时用%~1的形式去掉首尾双引号

:exec_length_subStr
set "param=%~1"
set "strlen=0"
REM 计算字符串长度注意空格未被忽略
for /L %%i in (0,1,100) do (
	set "char=!param:~%%i,1!"
	echo char:!char!
	if "!char!"==" " (
		set /a "strlen+=1"
	) else if not "!char!"=="" (
		set /a "strlen+=1"
	) else (
		goto :eof
	)
)

:done
echo 字符串长度：%strlen% >> 1.txt



:exec_count_subStr
set "param1=%~1"
set "param2=%~2"
set param3=%3
echo param1:!param1! >> 1.txt
echo param2:!param2! >> 1.txt
set count=0
for /L %%j in (0,1,100) do (
	set "char=!param1:~%%j,1!"
	if "!char!"=="" (
		goto :eof
	)
	if "!char!"=="!param2:~0,1!" (
		set sub=!param1:~%%j,%param3%!
		if "!sub!"=="!param2!" (
			set /a count+=1
		)
	)
)

:end
@echo 子串个数为：%count% >> 1.txt


call:%input_file%

pause





if exist %update_allpkg_SN% del %update_allpkg_SN%

for /f "tokens=* delims=" %%a in (%input_file%) do (
	set line=%%a
	::@echo !line! >> %update_allpkg%
	if "!line:%str1%=!" neq "!line!" (
		set "line=!line:%str1%=%str1_replace%!"
		echo !line! >> %update_allpkg_SN%
	) else if "!line:%str3%=!" neq "!line!" ( 
		set count=0
		echo count:!count! >> %update_allpkg_SN%
		if count == 1 (
			set "line=!line:%str3%=%str3_replace%!"
			echo !line! >> %update_allpkg_SN%
		) else (
			echo sss >> %update_allpkg_SN%
		)	
		
	) else (
		@echo !line! >> %update_allpkg_SN%
	)
)

endlocal

pause

