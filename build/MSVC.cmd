@chcp 65001
@cd /d %~dp0

:: 设置Qt版本、编译器版本代号
SET QT_VERSION=%1
SET QT_TYPE=%2
SET COMPILER_VERSION=%3
SET QT_RP=%4

:: 设置Qt路径
set PATH=D:\a\buildRedPanda-CPP\%QT_VERSION%-%QT_TYPE%\%COMPILER_VERSION%%QT_RP%\bin;%PATH%

:: 设置源代码路径、build文件夹路径、安装文件夹路径(即使路径含空格也不加引号)
set SRC_DIR=D:\a\buildRedPanda-CPP\RedPanda-CPP
set BUILD_DIR=D:\a\buildRedPanda-CPP\build
set INSTALL_DIR=D:\a\buildRedPanda-CPP\RedPanda-CPP-Qt%QT_VERSION%-%QT_TYPE%-%COMPILER_VERSION%%QT_RP%

:: 仅 MSVC 工具链需要设置
set VS_INSTALL_PATH=C:\Program Files\Microsoft Visual Studio\2022\Enterprise
:: 仅 MSVC 工具链需要设置；amd64 或 x86
if msvc2022_32==%COMPILER_VERSION% (set VC_ARCH=x86)
if msvc2022_64==%COMPILER_VERSION% (set VC_ARCH=amd64)
echo COMPILER_VERSION=%COMPILER_VERSION%
echo VC_ARCH=%VC_ARCH%
:: 仅 MSVC 工具链需要；如果未安装 Qt Creator 则不要设置
set QT_CREATOR_DIR=

:: 创建并定位到构建目录：
mkdir "%BUILD_DIR%" && cd /d "%BUILD_DIR%"

:: 配置、构建、安装。对于 MSVC 工具链：
call "%VS_INSTALL_PATH%\Common7\Tools\VsDevCmd.bat" -arch=%VC_ARCH%
qmake PREFIX="%INSTALL_DIR%" "%SRC_DIR%\Red_Panda_CPP.pro"

set JOM=%QT_CREATOR_DIR%\bin\jom\jom.exe
if "%QT_CREATOR_DIR%" neq "" (
   "%JOM%" -j%NUMBER_OF_PROCESSORS%
   "%JOM%" install
) else (
   nmake
   nmake install
)
:: windeployqt "%INSTALL_DIR%\RedPandaIDE.exe"
