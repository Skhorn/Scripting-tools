@echo off

echo Instalaciòn y configuraciòn automatizada de SonarQube ---
pause
echo Creando carpeta Sonar
if not exist "C:\Sonar" mkdir C:\Sonar
echo Downloading SonarQube...
bitsadmin.exe /transfer SonarQube /download /priority normal https://sonarsource.bintray.com/Distribution/sonarqube/sonarqube-6.2.zip c:\Sonar\SonarQube.zip
echo Downloading SonarScanner
bitsadmin.exe /transfer SonarScanner /download /priority normal https://sonarsource.bintray.com/Distribution/sonar-scanner-cli/sonar-scanner-2.8.zip c:\Sonar\SonarScanner.zip
echo Descomprimiendo SonarQube.zip
jar xf C:\Sonar\SonarQube.zip
echo Descomprimiendo SonarScanner.zip
jar xf C:\Sonar\SonarScanner.zip

Set SonarQube HOME_PATH
echo Setting SonarQube Path...
set SONAR_QUBE=C:\Sonar\sonarqube-6.2\bin\windows-x86-64
set SONAR_QUBE2=C:\Sonar\sonarqube-6.2\bin\windows-x86-64
REM Set SonarScanner HOME_PATH
echo Setting SonarScanner Path...
set SONAR_SCANNER=C:\Sonar\sonar-scanner-2.8\bin
REM Append the new values to PATH
echo %PATH%
pause
set @PATH=%PATH%;%SONAR_SCANNER%;%SONAR_QUBE%;
echo %@PATH%
pause
REM Do whatever checks you want to do to confirm that those are set correctly
cd C:\Sonar
echo Setting environment variables to be persistent...
REM Now, save the current (local) values of the environment variables
REM to persistent storage (registry)
setx SONAR_QUBE %SONAR_QUBE%
setx SONAR_SCANNER %SONAR_SCANNER%
rem setx PATH %@PATH%
setx PATH "%PATH%;%SONAR_SCANNER%;%SONAR_QUBE%;%SONAR_QUBE%;" /M
