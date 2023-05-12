@echo off
echo "Update Coorte Script for Windows by Messas"

set updateAPI=y
set /p updateAPI="Update Coorte-API? [y/n] (default - %updateAPI%) ?: "

if "%updateAPI%"=="y" (
  set /p APITag="Enter new API tag: "
)

set updateWEB=y
set /p updateWEB="Update Coorte-WEB? [y/n] (default - %updateWEB%) ?: "

if "%updateWEB%"=="y" (
  set /p WEBTag="Enter new WEB tag: "
)

@echo off

if "%updateAPI%" == "y" (
  call :updateAPI
) else (
  call echo Skipping API
)

if "%updateWEB%"=="y" (
  call :updateWEB
) else (
  call echo Skipping WEB
)

exit /b 0

:updateAPI
call echo Updating API
call :prepareCommandsFileAPI
call dos2unix apiCommands
call echo Commands to be executed on Coorte Production Server:
call type apiCommands
call pause
call ssh -tt cloud@coortesz.com.br < apiCommands
exit /b 0

:prepareCommandsFileAPI
call echo Preparing API Commands
call echo cd coorte-api > apiCommands
call echo git fetch >> apiCommands
call echo git checkout %APITag% >> apiCommands
call echo npm install >> apiCommands
call echo npm run build >> apiCommands
call echo pm2 restart 0 >> apiCommands
call echo pm2 list >> apiCommands
call echo exit >> apiCommands
exit /b 0

:updateWEB
call echo Updating WEB
call :prepareCommandsFileWEB
call dos2unix webCommands
call echo Commands to be executed on Coorte Production Server:
call type webCommands
call pause
call ssh -tt cloud@coortesz.com.br < webCommands
exit /b 0

:prepareCommandsFileWEB
call echo Preparing WEB Commands
call echo cd coorte-web > webCommands
call echo git fetch >> webCommands
call echo git checkout %WEBTag% >> webCommands
call echo npm install >> webCommands
call echo npm run build:prod >> webCommands
call echo npm run start:prod >> webCommands
call echo exit >> webCommands
exit /b 0

call echo Finished!

call pause