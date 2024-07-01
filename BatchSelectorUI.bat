@echo off
 set tsv_useParameter=%1
 set tsv_UITextFile=%2
 set tsv_UIHintFile=%3
 set tsv_moveKeyUp=%4
 set tsv_moveKeyDown=%5
 set tsv_moveKeySelect=%6
 set tsv_noCls=%7
 set tsv_showMoveInfo=%8
 if not defined tsv_useParameter set tsv_useParameter=false
 if %tsv_useParameter% == true goto sof

 rem ---�ݒ�---

 rem UI�̑I�����t�@�C�����w�肵�Ă��������B �ϐ����p�B
 set tsv_UITextFile=null

 rem UI�̃q���g�t�@�C�����w�肵�Ă��������B �ϐ����p�B
 set tsv_UIHintFile=null

 rem �ړ��L�[(��)���w�肵�Ă��������B
 set tsv_moveKeyUp=w

 rem �ړ��L�[(��)���w�肵�Ă��������B
 set tsv_moveKeyDown=s

 rem �Z���N�g(�I��)�L�[���w�肵�Ă��������B
 set tsv_moveKeySelect=p

 rem UI�X�V���Ƃ�Cls�����s���Ȃ����ǂ������w�肵�Ă��������B ��{�� false �����B
 set tsv_noCls=false

 rem ���݂̈ʒu�Ⓖ�O�̍s�����e�Ȃǂ�\�����邩�ǂ������w�肵�Ă��������B �f�o�b�O���ȊO�� false �����B
 set tsv_showMoveInfo=false

 rem ---�����---

 :sof
 rem BatchSelectorUI - v1.0.2
 rem (c) 2024 akikawa9616

 set tsv_place=a1
 set tsv_place1=%tsv_place:~0,1%
 set tsv_place2=%tsv_place:~1,1%
 set tsv_place=%tsv_place1%%tsv_place2%

 if not exist %temp%\.BatchSelectorUI\exist.tscf (md %temp%\.BatchSelectorUI & echo;>%temp%\.BatchSelectorUI\exist.tscf)
 :setText
 setlocal enabledelayedexpansion
 for /f "usebackq" %%a in ("%tsv_UITextFile%") do (
  set tsv_Count=%%a
  if "!tsv_Count:~0,1!" == "#" ( set tsv_title=!tsv_Count:~1!)
 )
 for /f "usebackq skip=1" %%a in ("%tsv_UITextFile%") do (
  set tsv_Count=%%a
  if "!tsv_Count:~0,1!" == "@" ( set tsv_maxPlace=!tsv_Count:~1!)
 )
 set tsv_Count=0
 for /f "usebackq skip=2" %%a in ("%tsv_UITextFile%") do (
  set /a tsv_Count=!tsv_Count! + 1
  set tsv_a!tsv_Count!=%%a
 )
 set tsv_>%temp%\.BatchSelectorUI\UItemp.txt
 endlocal
 for /f %%a in (%temp%\.BatchSelectorUI\UITemp.txt) do (
  set %%a
 )
 del %temp%\.BatchSelectorUI\UITemp.txt
 :setTextColor
 echo set tsv_%tsv_place1%%tsv_place2%=%%tsv_%tsv_place1%%tsv_place2%%% ��>%temp%\.BatchSelectorUI\placeCommand.bat
 call %temp%\.BatchSelectorUI\placeCommand.bat
 
 :selector
 rem --UI--
 set tsv_place=%tsv_place1%%tsv_place2%
 echo;
 if %tsv_showMoveInfo% == true (if %ERRORLEVEL% == 0 echo User Input:  , ERRORLEVEL:%ERRORLEVEL% , invalidDestination: %tsv_invalidDestination%, Place:%tsv_place% , Place1:%tsv_place1% , Place2: %tsv_place2%)
 if %tsv_showMoveInfo% == true (if %ERRORLEVEL% == 1 echo User Input:w , ERRORLEVEL:%ERRORLEVEL% , invalidDestination: %tsv_invalidDestination%, Place:%tsv_place% , Place1:%tsv_place1% , Place2: %tsv_place2%)
 if %tsv_showMoveInfo% == true (if %ERRORLEVEL% == 2 echo User Input:s , ERRORLEVEL:%ERRORLEVEL% , invalidDestination: %tsv_invalidDestination%, Place:%tsv_place% , Place1:%tsv_place1% , Place2: %tsv_place2%)
 echo %tsv_title%
 echo;
 for /l %%a in (1,1,%tsv_maxPlace%) do (
  echo echo %%tsv_a%%a%% >%temp%\.BatchSelectorUI\hoge.bat
  call %temp%\.BatchSelectorUI\hoge.bat
 )
 del %temp%\.BatchSelectorUI\hoge.bat
 echo -----
 for /f "usebackq skip=%tsv_place2% tokens=1-2 delims=:" %%a in ("%tsv_UIHintFile%") do (
  if %%a == %tsv_place2% (echo %%b))
 echo -----
 choice /c %tsv_moveKeyUp%%tsv_moveKeyDown%%tsv_moveKeySelect% /n /m "�L�[���͎�t���B �㉺�ړ�: %tsv_moveKeyUp%/%tsv_moveKeyDown% , �Z���N�g: %tsv_moveKeySelect%"
 rem ------
 
 :tp
 if %ERRORLEVEL% == 1 call :ui_up
 if %ERRORLEVEL% == 2 call :ui_down
 if %ERRORLEVEL% == 3 exit /b
 if %ERRORLEVEL% == 0 goto selector
 if %ERRORLEVEL% == 255 goto error_choice
 if %tsv_invalidDestination% == true goto selector
 goto setTextColor

rem -- UI teleport --
 :ui_up
  set tsv_place1=%tsv_place:~0,1%
  set tsv_place2=%tsv_place:~1,1%
  if %tsv_place2% == 1 ( call :error_cantMove & exit /b )
  echo set tsv_%tsv_place1%%tsv_place2%=%%tsv_%tsv_place1%%tsv_place2%:~0,-2%%>%temp%\.BatchSelectorUI\placeCommand.bat
  call %temp%\.BatchSelectorUI\placeCommand.bat
  set /a tsv_place2=%tsv_place2% - 1
  set tsv_invalidDestination=false
  if not %tsv_noCls% == true cls
  echo;
  exit /b
 
 :ui_down
  set tsv_place1=%tsv_place:~0,1%
  set tsv_place2=%tsv_place:~1,1%
  if %tsv_place2% == %tsv_maxPlace% ( call :error_cantMove & exit /b )
  echo set tsv_%tsv_place1%%tsv_place2%=%%tsv_%tsv_place1%%tsv_place2%:~0,-2%%>%temp%\.BatchSelectorUI\placeCommand.bat
  call %temp%\.BatchSelectorUI\placeCommand.bat
  set /a tsv_place2=%tsv_place2% + 1
  set tsv_invalidDestination=false
  if not %tsv_noCls% == true cls
  echo;
  exit /b
rem -- error --
 :error_choice
 if not %tsv_noCls% == true cls
 echo Choice�ɂ��A�G���[�󋵂����o����܂����B
 set tsv_invalidDestination=true
 exit /b
 
 :error_cantMove
 if not %tsv_noCls% == true cls
 if %ERRORLEVEL% == 1 echo �I�����̈�ԏ�ɓ��B���܂����B
 if %ERRORLEVEL% == 2 echo �I�����̈�ԉ��ɓ��B���܂����B
 set tsv_invalidDestination=true
 exit /b
 