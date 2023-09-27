@echo off
setlocal enabledelayedexpansion

REM README
REM 将该脚本放至fastboot刷机脚本同级目录，执行该脚本前仅替换设备SN即可
SET SN=xxxxxxx


set "input_file=update_allpkg.bat"
set "input_file1=.\fastboot_custpkg\update_custpkg.bat"
set "input_file2=.\fastboot_preloadpkg\update_preloadpkg.bat"
set "input_file31=..\fastboot_basepkg\update_basepkg.bat"
set "input_file32=.\fastboot_basepkg\update_basepkg.bat"


set "temp_file=update_allpkg.txt"
set "temp_file1=.\fastboot_custpkg\update_custpkg.txt"
set "temp_file2=.\fastboot_preloadpkg\update_preloadpkg.txt"
set "temp_file31=..\fastboot_basepkg\update_basepkg.txt"
set "temp_file32=.\fastboot_basepkg\update_basepkg.txt"

REM fastboot后紧跟空格；定义变量尽量用双引号引起来，避免其中的空格解析错误
set "search=fastboot "
set "replace=fastboot -s !SN! "
set "search_hdc=hdc "
set "replace_hdc=hdc -t !SN! "
set "search_adb=adb "
set "replace_adb=adb -s !SN! "

set "update_custpkg=update_custpkg.bat"
set "update_preloadpkg=update_preloadpkg.bat"
set "update_basepkg=update_basepkg.bat"

set "update_allpkg_SN=update_allpkg_!SN!.bat"
set "update_custpkg_SN=update_custpkg_!SN!.bat"
set "update_preloadpkg_SN=update_preloadpkg_!SN!.bat"
set "update_basepkg_SN=update_basepkg_!SN!.bat"

::if exist 1.txt del 1.txt

set "defset=@set "
set "lefeline=/"
set "rightline=\"

set "space=^^"

REM 读取bat脚本，@if not !ERRORLEVEL^!==0 若以文本形式实际显示需要转义ERRORLEVEL变量，否则，读取的是变量的值
set "errorlevel=^!ERRORLEVEL^!"

if exist %temp_file%  del %temp_file%
if exist %temp_file1%  del %temp_file1%
if exist %temp_file2%  del %temp_file2%
if exist %temp_file31%  del %temp_file31%
if exist %temp_file32%  del %temp_file32%

if exist %update_allpkg_SN%  del %update_allpkg_SN%
if exist .\fastboot_custpkg\%update_custpkg_SN%  del .\fastboot_custpkg\%update_custpkg_SN%
if exist .\fastboot_preloadpkg\%update_preloadpkg_SN%  del .\fastboot_preloadpkg\%update_preloadpkg_SN%
if exist ..\fastboot_basepkg\%update_basepkg_SN%  del ..\fastboot_basepkg\%update_basepkg_SN%
if exist .\fastboot_basepkg\%update_basepkg_SN%  del .\fastboot_basepkg\%update_basepkg_SN%



if exist %input_file% (
	for /f "tokens=* delims=" %%a in ('type "%input_file%"') do (
		set "line=%%a"
		::@echo !line!>> %update_allpkg_SN%
		if "!line:%search%=!" neq "!line!" (
			set "line=!line:%search%=%replace%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%update_custpkg%=!" neq "!line!" ( 
			set "line=!line:%update_custpkg%=%update_custpkg_SN%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%update_preloadpkg%=!" neq "!line!" ( 
			set "line=!line:%update_preloadpkg%=%update_preloadpkg_SN%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%update_basepkg%=!" neq "!line!" ( 
			set "line=!line:%update_basepkg%=%update_basepkg_SN%!"
			echo !line!>> .\%temp_file%
		) else if "!line:%defset%=!" neq "!line!" ( 
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				echo !defset! "!otherset!">> .\%temp_file%
			) else (
				echo !line!>> .\%temp_file%
			)	
		) else (
			@echo !line!>> .\%temp_file%
		)
	)
)


if exist %input_file1% (
	for /f "tokens=* delims=" %%c in ('type "%input_file1%"') do (
		set "line=%%c"
		if "!line:%search%=!" neq "!line!" (
			set "line=!line:%search%=%replace%!"
			echo !line!>> %temp_file1%
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			echo !line!>> %temp_file1%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			echo !line!>> %temp_file1%
		) else if "!line:%defset%=!" neq "!line!" ( 
			REM set变量带有反斜杠，嵌套在路径中会出现空格，判断加双引号
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				echo !defset! "!otherset!">> %temp_file1%
			) else (
				echo !line!>> %temp_file1%
			)	
		) else (
			@echo !line!>> %temp_file1%
		)
	)
)


if exist !input_file2! (
	for /f "tokens=* delims=" %%p in ('type "%input_file2%"') do (
		set "line=%%p"
		if "!line:%search%=!" neq "!line!" (
			set "line=!line:%search%=%replace%!"
			echo !line!>> %temp_file2%
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			echo !line!>> %temp_file2%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			echo !line!>> %temp_file2%
		) else if "!line:%defset%=!" neq "!line!" ( 
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				echo !defset! "!otherset!">> %temp_file2%
			) else (
				echo !line!>> %temp_file2%
			)	
		) else (
			@echo !line!>> %temp_file2%
		)
	)
)

if exist !input_file31! (
	for /f "tokens=* delims=" %%b in ('type "%input_file31%"') do (
		set "line=%%b"
		if "!line:%search%=!" neq "!line!" (
			REM 增加判断，避免替换命令行中过多子串，导致命令失效
			REM 示例：fastboot flash fastboot set_fastboott.img
			@call:exec_length_str "!search!"
			set "search_length=!strlen!"
			REM 将字符串中的双引号替换为单引号，避免调用标签传参是解析截断（使用单引号，解析视为字面值名称，不会进行变量替换或特殊字符转义）
			set "line_temp=!line:"='!"
			@call:exec_count_subStr "!line_temp!" "!search!" "!strlen!"
			REM 待替换子串个数大于等于2和等于1两种情况
			if !count! geq 2 (
				@call:exec_length_str "!line!"
				set "line_length=!strlen!"
				REM !line:~9! 代表截取line字符串从索引9到末尾的字符
				REM 变量嵌套，每增加一次嵌套加双倍的%引起来
				call call set "otherStr=%%%%line:~%%search_length%%%%%%"
				REM 一行数据重定向到文件中“>>”前不要加空格，因为如果遇到转义符^,会将空格转义识别成内容的一部分，导致无法正常解析
				REM dos中^也有连接两个命令依次执行的作用
				@echo !replace!!otherStr!>> %temp_file31%
			) else (
				set "line=!line:%search%=%replace%!"
				echo !line!>> %temp_file31%
			)
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			echo !line!>> %temp_file31%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			echo !line!>> %temp_file31%
		) else if "!line:%defset%=!" neq "!line!" ( 
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				echo !defset! "!otherset!">> %temp_file31%
			) else (
				echo !line!>> %temp_file31%
			)	
		) else (
			@echo !line!>> %temp_file31%
		)
	)
)

if exist !input_file32! (
	for /f "tokens=* delims=" %%b in ('type "%input_file32%"') do (
		set "line=%%b"
		if "!line:%search%=!" neq "!line!" (
			REM 增加判断，避免替换命令行中过多子串，导致命令失效
			REM 示例：fastboot flash fastboot set_fastboott.img
			@call:exec_length_str "!search!"
			set "search_length=!strlen!"
			REM 将字符串中的双引号替换为单引号，避免调用标签传参是解析截断（使用单引号，解析视为字面值名称，不会进行变量替换或特殊字符转义）
			set "line_temp=!line:"='!"
			@call:exec_count_subStr "!line_temp!" "!search!" "!strlen!"
			REM 待替换子串个数大于等于2和等于1两种情况
			if !count! geq 2 (
				@call:exec_length_str "!line!"
				set "line_length=!strlen!"
				REM !line:~9! 代表截取line字符串从索引9到末尾的字符
				REM 变量嵌套，每增加一次嵌套加双倍的%引起来
				call call set "otherStr=%%%%line:~%%search_length%%%%%%"
				@echo !replace!!otherStr!>> %temp_file32%
			) else (
				set "line=!line:%search%=%replace%!"
				echo !line!>> %temp_file32%
			)
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			echo !line!>> %temp_file32%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			echo !line!>> %temp_file32%
		) else if "!line:%defset%=!" neq "!line!" ( 
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				echo !defset! "!otherset!">> %temp_file32%
			) else (
				echo !line!>> %temp_file32%
			)	
		) else (
			@echo !line!>> %temp_file32%
		)
	)
)


REM 调试增加了一个中间变量，懒得改了，文件移动粘贴吧
if exist %temp_file%  move %temp_file% .\%update_allpkg_SN%>nul
if exist %temp_file1%  move %temp_file1% .\fastboot_custpkg\%update_custpkg_SN%>nul
if exist %temp_file2%  move %temp_file2% .\fastboot_preloadpkg\%update_preloadpkg_SN%>nul
if exist %temp_file31%  move %temp_file31% ..\fastboot_basepkg\%update_basepkg_SN%>nul
if exist %temp_file32%  move %temp_file32%  .\fastboot_basepkg\%update_basepkg_SN%>nul


pause

REM errorlevel设置成默认值，取消转义显示成变量名称
set "errorlevel=0"

::start "" !update_allpkg_SN!
::@echo 另一个批处理文件已启动 >nul

@call !update_allpkg_SN!
@echo 另一个批处理文件已启动 >nul




::由于是顺序执行，标签命令块创建在调用位置之后
::call :label arguments
::调用本文件内命令行，相当于子程序。被电泳的命令端以标签:label开头
::以命令goto :eof结尾
REM 若标签参数是字符串变量，存在空白字符，会被分割并当成多个字符参数传递，所以需双引号引起来，计算的字符长度时-2，或传参接收时用%~1的形式去掉首尾双引号

:exec_length_str
set "param=%~1"
set "strlen=0"
REM 计算字符串长度注意空格是否被忽略；暂时固定变量101次。。
for /L %%i in (0,1,100) do (
	set "char=!param:~%%i,1!"
	::echo char:!char!
	if "!char!"==" " (
		set /a "strlen+=1"
	) else if not "!char!"=="" (
		set /a "strlen+=1"
	) else (
		goto :end
	)
)


REM 如果变量的字符串有!,需要^转义才能识别为一位字符
REM 传参：param1：主字符串；param2；子字符串；param3:子字符串长度
REM 注释不要放到标签下的第一行，可能识别有误。。
:exec_count_subStr
set "param1=%~1"
set "param2=%~2"
set "param3=%~3"
::echo param1:!param1! >> 1.txt
::echo param2:!param2! >> 1.txt
set count=0
for /L %%j in (0,1,100) do (
	set "char=!param1:~%%j,1!"
	if "!char!"=="" (
		goto :end
	)
	if "!char!"=="!param2:~0,1!" (
		set sub=!param1:~%%j,%param3%!
		if "!sub!"=="!param2!" (
			set /a count+=1
		)
	)
)
:end
@echo 执行完毕，返回到调用位置>nul
goto :eof

pause

