@echo off

::Get input from user
set /p mkvmerge="Copy and paste mkvmerge.exe path: "
::If no mkvmerge path provided, kill
if [%mkvmerge%] == [] GOTO error
if not exist %mkvmerge% GOTO filePathError 

set /p mediaFolder="Copy and paste media folder path: "
::If no media folder path provided, kill
if [%mediaFolder%] == [] GOTO error
if not exist %mkvmerge% GOTO filePathError

set /p mkvtoolnixCmd="Copy and paste mkvToolNix command: "
::If no mkvtoolnix commands provided, kill
if [%mkvtoolnixCmd%] == [] GOTO error

set /p seasonNumber="Set season number here: "
::If no seasonNumber provided, kill
if [%seasonNumber%] == [] GOTO error
SET "var="&for /f "delims=0123456789" %%i in ("%seasonNumber%") do set var=%%i
if defined var GOTO notNumberError

::gen output folder if not existing
if not exist "mkvmerge_out" (mkdir "mkvmerge_out")

if exist %mediaFolder%\*.%vidExt%(
    set vidExtToBeUsed = %vidExt%
)

if exist %mediaFolder%\*.%subExt%(
    set subExtToBeUsed = %subExt%
)

::If no subs provided, skip
if [%subExt%] == [] GOTO noSubs

::init counter for file rename
set /a count=0

:haveSubs
for %%f in (%mediaFolder%\*.%vidExtToBeUsed%) do (
    if not exist "mkvmerge_out\%%~nf.mkv"(
        %mkvmerge% --ui-language en --priority lower --output ^"D:\Downloads\Video\mkvmerge_out\%%~nf.mkv^" --language 0:und --language 1:und ^"^(^" ^"D:\Downloads\Video\%%f^" ^"^)^" --language 0:zh --track-name ^"0:Simplified Chinese^" ^"^(^" ^"D:\Downloads\Video\%%~nf.%subExtToBeUsed%^" ^"^)^" --language 0:en --track-name 0:English --default-track-flag 0:no ^"^(^" ^"D:\Downloads\Video\%%~nf_2.%subExtToBeUsed%^" ^"^)^" --track-order 0:0,0:1,1:0,2:0
    )
)
echo.
echo ============================
echo Done. Press any key to exit.
pause>nul
exit

:noSubs
echo Subs do not exist in this folder. Continuing will essentially remux the file from mp4 to mkv. Proceed? (y/n)
set /p proceed=""
if %proceed% == "y" GOTO noSubsProceed
if %proceed% == "Y" GOTO noSubsProceed

echo ============================
echo Done. Press any key to exit.
pause>nul
exit

:noSubsProceed
(
    for %%f in (%mediaFolder%\*.%vidExt%) do (
        if not exist "mkvmerge_out\%%~nf.mkv"(
            %mkvmerge% --ui-language en --priority lower --output ^"D:\Downloads\Video\mkvmerge_out\%%~nf.mkv^" --language 0:und --language 1:und ^"^(^" ^"D:\Downloads\Video\%%f^" ^"^)^" --track-order 0:0,0:1
        )
    )
    echo.
    echo ============================
    echo Done. Press any key to exit.
    pause>nul
    exit
)

:error
(
    echo Information needed was not supplied, press any key to exit.
    pause>nul
    exit
)

:notNumberError
(
    echo Input for Season Number was not a numeric, press any key to exit
    pause>nul
    exit
)

:filePathError
(
    echo File path provided is invalid, press any key to exit
    pause>nul
    exit
)

:commandError
(
    echo MkvToolNix command supplied is invalid, press any key to exit
    pause>nul
    exit
)