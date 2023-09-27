@echo off
REM ����ANSI�����ʽ
chcp 1252

setlocal enabledelayedexpansion

REM README
REM ���ýű�����fastbootˢ���ű�ͬ��Ŀ¼��ִ�иýű�ǰ���滻�豸SN����
SET SN=xxxxxxx


set "input_file=update_allpkg.bat"
set "input_file1=.\fastboot_custpkg\update_custpkg.bat"
set "input_file2=.\fastboot_preloadpkg\update_preloadpkg.bat"
set "input_file31=..\fastboot_basepkg\update_basepkg.bat"
set "input_file32=.\fastboot_basepkg\update_basepkg.bat"

::set "temp_file=update_allpkg.txt"
::set "temp_file1=.\fastboot_custpkg\update_custpkg.txt"
::set "temp_file2=.\fastboot_preloadpkg\update_preloadpkg.txt"
::set "temp_file31=..\fastboot_basepkg\update_basepkg.txt"
::set "temp_file32=.\fastboot_basepkg\update_basepkg.txt"

REM fastboot������ո񣻶������������˫�������������������еĿո��������
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

if exist result.txt del result.txt

set "defset=@set "
set "lefeline=/"
set "rightline=\"

set "space=^^"

REM ��ȡbat�ű���@if not !ERRORLEVEL^!==0 �����ı���ʽʵ����ʾ��Ҫת��ERRORLEVEL���������򣬶�ȡ���Ǳ�����ֵ
set "errorlevel=^!ERRORLEVEL^!"

if exist %update_allpkg_SN%  del %update_allpkg_SN%
if exist .\fastboot_custpkg\%update_custpkg_SN%  del .\fastboot_custpkg\%update_custpkg_SN%
if exist .\fastboot_preloadpkg\%update_preloadpkg_SN%  del .\fastboot_preloadpkg\%update_preloadpkg_SN%
if exist ..\fastboot_basepkg\%update_basepkg_SN%  del ..\fastboot_basepkg\%update_basepkg_SN%
if exist .\fastboot_basepkg\%update_basepkg_SN%  del .\fastboot_basepkg\%update_basepkg_SN%

if exist %input_file% @call:exec_replace_field %input_file% ".\%update_allpkg_SN%"
if exist %input_file1% @call:exec_replace_field %input_file1% ".\fastboot_custpkg\%update_custpkg_SN%"
if exist %input_file2% @call:exec_replace_field %input_file2% ".\fastboot_preloadpkg\%update_preloadpkg_SN%"
if exist %input_file31% (
	@call:exec_replace_field %input_file31% "..\fastboot_basepkg\%update_basepkg_SN%"
) else (
	@call:exec_replace_field %input_file32% ".\fastboot_basepkg\%update_basepkg_SN%"
)


REM errorlevel���ó�Ĭ��ֵ��ȡ��ת����ʾ�ɱ�������
set "errorlevel=0"

::start "" !update_allpkg_SN!
::@echo ��һ���������ļ������� >nul

if exist !update_allpkg_SN! (
	@call !update_allpkg_SN!
	if not !errorlevel!=0 (
		@goto error
	)
)
@echo ��һ���������ļ������� >nul


REM �����滻�ļ����ض��ֶεı�ǩ��
REM ���Σ�param1�������ļ���param2������ļ�
:exec_replace_field
set "input_filex=%1"
set "temp_filex=%2"
::echo !input_filex!>>result.txt
::echo !temp_filex!>>result.txt
if exist !input_filex! (
	for /f "tokens=* delims=" %%b in ('type "%input_filex%"') do (
		set "line=%%b"
		if "!line:%search%=!" neq "!line!" (
			REM �����жϣ������滻�������й����Ӵ�����������ʧЧ
			REM ʾ����fastboot flash fastboot set_fastboott.img
			@call:exec_length_str "!search!"
			set "search_length=!strlen!"
			REM ���ַ����е�˫�����滻Ϊ�����ţ�������ñ�ǩ�����ǽ����ضϣ�ʹ�õ����ţ�������Ϊ����ֵ���ƣ�������б����滻�������ַ�ת�壩
			set "line_temp=!line:"='!"
			@call:exec_count_subStr "!line_temp!" "!search!" "!strlen!"
			REM ���滻�Ӵ��������ڵ���2�͵���1�������
			if !count! geq 2 (
				@call:exec_length_str "!line!"
				set "line_length=!strlen!"
				REM !line:~9! �����ȡline�ַ���������9��ĩβ���ַ�
				REM ����Ƕ�ף�ÿ����һ��Ƕ�׼�˫����%������
				call call set "otherStr=%%%%line:~%%search_length%%%%%%"
				REM һ�������ض����ļ��С�>>��ǰ��Ҫ�ӿո���Ϊ�������ת���^,�Ὣ�ո�ת��ʶ������ݵ�һ���֣������޷���������
				REM dos��^Ҳ������������������ִ�е�����
				@echo !replace!!otherStr!>> %temp_filex%
			) else (
				set "line=!line:%search%=%replace%!"
				echo !line!>> %temp_filex%
			)
		) else if "!line:%search_hdc%=!" neq "!line!" ( 
			set "line=!line:%search_hdc%=%replace_hdc%!"
			@echo !line!>> %temp_filex%
		) else if "!line:%search_adb%=!" neq "!line!" ( 
			set "line=!line:%search_adb%=%replace_adb%!"
			@echo !line!>> %temp_filex%
		) else if "!line:%update_custpkg%=!" neq "!line!" ( 
			set "line=!line:%update_custpkg%=%update_custpkg_SN%!"
			@echo !line!>> .\%temp_filex%
		) else if "!line:%update_preloadpkg%=!" neq "!line!" ( 
			set "line=!line:%update_preloadpkg%=%update_preloadpkg_SN%!"
			@echo !line!>> .\%temp_filex%
		) else if "!line:%update_basepkg%=!" neq "!line!" ( 
			set "line=!line:%update_basepkg%=%update_basepkg_SN%!"
			@echo !line!>> .\%temp_filex%
		) else if "!line:%defset%=!" neq "!line!" ( 
			REM set�������з�б�ܣ�Ƕ����·���л���ֿո��жϼ�˫����
			if "!line:%rightline%=!" neq "!line!" (
				set "otherset=!line:*%defset%=!"
				@echo !defset! "!otherset!">> %temp_filex%
			) else (
				@echo !line!>> %temp_filex%
			)	
		) else (
			@echo !line!>> %temp_filex%
		)
	)
)
goto :eof


::������˳��ִ�У���ǩ����鴴���ڵ���λ��֮��
::call :label arguments
::���ñ��ļ��������У��൱���ӳ��򡣱���Ӿ��������Ա�ǩ:label��ͷ
::������goto :eof��β
REM ����ǩ�������ַ������������ڿհ��ַ����ᱻ�ָ���ɶ���ַ��������ݣ�������˫������������������ַ�����ʱ-2���򴫲ν���ʱ��%~1����ʽȥ����β˫����

:exec_length_str
set "param=%~1"
set "strlen=0"
REM �����ַ�������ע��ո��Ƿ񱻺��ԣ���ʱ�̶�����101�Ρ���
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


REM ����������ַ�����!,��Ҫ^ת�����ʶ��Ϊһλ�ַ�
REM ���Σ�param1�����ַ�����param2�����ַ�����param3:���ַ�������
REM ע�Ͳ�Ҫ�ŵ���ǩ�µĵ�һ�У�����ʶ�����󡣡�
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
@echo ִ����ϣ����ص�����λ��>nul
goto :eof

:error
@echo "call update_allpkg fail"
@pause
@EXIT 1

pause

