;----------------------------------------------------
;Pinguino IDE Installation Script
;Public Domain License 2014
;Coded by Victor Villarreal <mefhigoseth@gmail.com>
;----------------------------------------------------
;Defines

!define FILE_NAME 'pinguino-ide'
!define FILE_VERSION '11'
!define FILE_INSTVERSION '11.0.0.1'
!define FILE_OWNER 'Pinguino Project'
!define FILE_URL 'http://www.pinguino.cc/'
!define MUI_ABORTWARNING
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILE_NAME}"
!define PYTHON27URL "http://python.org/ftp/python/2.7.6/python-2.7.6.msi"
!define PyPIURL "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
!define IntelHex "http://www.bialix.com/intelhex/intelhex-1.5.zip"

;--------------------------------
;Includes

!include "MUI2.nsh"
!include "FileFunc.nsh"

;--------------------------------
;General Settings

Name '${FILE_NAME} v${FILE_VERSION}'
OutFile '${FILE_NAME}-${FILE_VERSION}-setup.exe'
BrandingText '${FILE_OWNER}'
InstallDir 'C:\${FILE_NAME}'
ShowInstDetails show

VIAddVersionKey "ProductName" '${FILE_NAME}'
VIAddVersionKey "ProductVersion" '${FILE_VERSION}'
VIAddVersionKey "CompanyName" '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright" 'Copyright 2014 ${FILE_OWNER}'
VIAddVersionKey "FileDescription" '${FILE_NAME} Installer'
VIAddVersionKey "FileVersion" '${FILE_INSTVERSION}'
VIProductVersion '${FILE_INSTVERSION}'

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Installer Sections

Section "Install"

  ;Default installation folder
  ;strCpy $InstallDest '$PROGRAMFILES' 2
  ;InstallDir '$InstallDest\${FILE_NAME}

  ;Seteamos el directorio de salida para las instrucciones FILE.
  SetOutPath "$INSTDIR\v${FILE_VERSION}"
  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  IfFileExists "C:\Python27\python.exe" Python27Ok Python27Download

  Python27Download:
     DetailPrint "Python 2.7 not detected in your system."
     DetailPrint "We'll download and install it for you, in 5 secs."
     Sleep 5000
     inetc::get ${PYTHON27URL} $EXEDIR\python-2.7.6.msi
     Pop $R0
     StrCmp $R0 "OK" +2
     Abort "Download Python 2.7 failed: $R0!"
     ExecWait '"msiexec" /i "$EXEDIR\python-2.7.6.msi"' $0
     ${if} $0 != "0"
       Abort "Python 2.7 instalation failed. Exit code was $0!"
     ${endif}
     DetailPrint "Python v2.7 installation success. Continue..."

  Python27Ok:
     IfFileExists "C:\Python27\Scripts\pip.exe" PyPIok PyPIDownload

  PyPIDownload:
     DetailPrint "PyPI module not detected in your system."
     DetailPrint "We'll download and install it for you, in 5 secs."
     Sleep 5000
     inetc::get ${PyPIURL} $EXEDIR\get-pip.py
     Pop $R0
     StrCmp $R0 "OK" +2
     Abort "Download PyPI module failed: $R0!"
     ExecWait '"C:\Python27\python" "$EXEDIR\get-pip.py"' $0
     ${if} $0 != "0"
       Abort "PyPI instalation failed. Exit code was $0!"
     ${endif}
     DetailPrint "PyPI installation success. Continue..."

  PyPIok:
     ;IfFileExists "C:\Python27\Scripts\pip.exe" PyPIok PyPIDownload
     nsExec::Exec '"C:\Python27\Scripts\pip.exe" install wheel'
     Pop $R0
     ${if} $R0 != "0"
       Abort "Wheel module installation failed. Exit code was $R0!"
     ${endif}
     DetailPrint "wheel installation success. Continue..."

     nsExec::Exec '"C:\Python27\Scripts\pip.exe" install ${IntelHex}'
     Pop $R0
     ${if} $R0 != "0"
       Abort "IntelHex module installation failed. Exit code was $R0!"
     ${endif}
     DetailPrint "IntelHex installation success. Continue..."

     nsExec::Exec '"C:\Python27\Scripts\pip.exe" install beautifulsoup4'
     Pop $R0
     ${if} $R0 != "0"
       Abort "beautifulsoup4 module installation failed. Exit code was $R0!"
     ${endif}
     DetailPrint "beautifulsoup4 installation success. Continue..."

  ;Install libUSB...
  Call libUSB

  Sleep 5000

  ;Copy files...
  Call InstallFiles

  ;Publish the project info to the system...
  Call PublishInfo
  
  ;Make shorcuts...
  Call MakeShortcuts

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\v${FILE_VERSION}\uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ;Eliminamos todos los ficheros que instalamos...
  ;Delete /REBOOTOK "$INSTDIR\*.*"
  RMDir /r /REBOOTOK $INSTDIR

  ;Delete "$DESKTOP\BarraITS.lnk"
  ;RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
  DeleteRegKey /ifempty HKCU "Software\Pinguino"
  DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;---------------------------------
; Functions

Function InstallFiles
  ;Copy all the files to the installation folder...
  DetailPrint "CopyFiles begin..."
  File /r /x .git ..\${FILE_NAME}\*.*
FunctionEnd

Function PublishInfo
  ;Publish info for the "Add & Remove Software" system tool...
  DetailPrint "PublishInfo begin..."
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${FILE_NAME} v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
FunctionEnd

Function MakeShortcuts
  ;Make shortcuts into desktop and start menu to our program...
  DetailPrint "MakeShortcuts begin..."
  ;CreateShortCut "$DESKTOP\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
  ;CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  ;CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
FunctionEnd

Function libUSB
  File "/oname=$SYSDIR\libusb0.dll" ..\libusb\libusb0_x86.dll
  File "/oname=$SYSDIR\drivers\libusb0.sys" ..\libusb\libusb0.sys
  File "/oname=$SYSDIR\testlibusb.exe" ..\libusb\testlibusb.exe

  nsExec::Exec '"$SYSDIR\testlibusb.exe"'
  Pop $R0
  ${if} $R0 != "0"
    Abort "libUSB installation failed. Exit code was $R0!"
  ${endif}
    DetailPrint "libUSB installation success. Continue..."
FunctionEnd