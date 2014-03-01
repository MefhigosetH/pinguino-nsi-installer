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
!define MUI_ICON "pinguino-logo-v2.ico"
!define MUI_UNICON "pinguino-logo-v2.ico"
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILE_NAME}"
!define Python27 "http://python.org/ftp/python/2.7.6/python-2.7.6.msi"
!define PyPIP "https://raw.github.com/pypa/pip/master/contrib/get-pip.py"
!define IntelHex "http://www.bialix.com/intelhex/intelhex-1.5.zip"
!define PySIDE "http://download.qt-project.org/official_releases/pyside/PySide-1.2.1.win32-py2.7.exe"
!define pinguino-ide "https://github.com/PinguinoIDE/pinguino-ide/archive/master.zip"
!define pinguino-libraries "https://github.com/PinguinoIDE/pinguino-libraries/archive/2014.02.zip"
!define pinguino-compilers "https://github.com/PinguinoIDE/pinguino-compilers/releases/download/2014.02/win32.zip"

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

!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Spanish"

Function .onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

Function un.onInit

  !insertmacro MUI_LANGDLL_DISPLAY

FunctionEnd

LangString msg_not_detected ${LANG_ENGLISH} "not detected in your system."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema."

LangString msg_download_and_install ${LANG_ENGLISH} "We'll download and install it for you, in 5 secs."
LangString msg_download_and_install ${LANG_SPANISH} "Lo descargaremos e instalaremos por ti, en 5 segundos."

LangString msg_installed ${LANG_ENGLISH} "installed."
LangString msg_installed ${LANG_SPANISH} "instalado correctamente."

LangString msg_not_installed ${LANG_ENGLISH} "not installed. Error code was:"
LangString msg_not_installed ${LANG_SPANISH} "no instalado. El error fue:"

LangString msg_download_complete ${LANG_ENGLISH} "download complete."
LangString msg_download_complete ${LANG_SPANISH} "descargado correctamente."

LangString msg_download_error ${LANG_ENGLISH} "download failed. Error was:"
LangString msg_download_error ${LANG_SPANISH} "no se pudo descargar. El error fue:"

LangString msg_error_while_extracting ${LANG_ENGLISH} "An error ocurr while extracting files from"
LangString msg_error_while_extracting ${LANG_SPANISH} "Se ha producido un error mientras se descomprimia"

LangString msg_error_while_copying ${LANG_ENGLISH} "An error ocurr while copying files to"
LangString msg_error_while_copying ${LANG_SPANISH} "Se ha producido un error mientras se copiaban los archivos en el directorio"

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

  ; Python v2.7 detection and installation routine.
  IfFileExists "C:\Python27\python.exe" PyPIP +1
  DetailPrint "Python v2.7 $(msg_not_detected)"
  DetailPrint $(msg_download_and_install)
  Sleep 5000
  inetc::get ${Python27} $EXEDIR\python-2.7.6.msi
  Pop $R0
  StrCmp $R0 "OK" +2
  Abort "Python v2.7 $(msg_download_error) $R0!"
  DetailPrint "Python v2.7 $(msg_download_complete)"
  ExecWait '"msiexec" /i "$EXEDIR\python-2.7.6.msi"' $0
  ${if} $0 != "0"
    Abort "Python v2.7 $(msg_not_installed) $0!"
  ${endif}
  DetailPrint "Python v2.7 $(msg_installed)"

  PyPIP:
    ; PyPIP module detection and installation routine.
    IfFileExists "C:\Python27\Scripts\pip.exe" Wheel +1
    DetailPrint "PyPIP $(msg_not_detected)"
    DetailPrint $(msg_download_and_install)
    Sleep 5000
    inetc::get ${PyPIP} $EXEDIR\get-pip.py
    Pop $R0
    StrCmp $R0 "OK" +2
    Abort "PyPIP $(msg_download_error) $R0!"
    DetailPrint "PyPIP $(msg_download_complete)"
    ExecWait '"C:\Python27\python" "$EXEDIR\get-pip.py"' $0
    ${if} $0 != "0"
      Abort "PyPIP $(msg_not_installed) $0!"
    ${endif}
    DetailPrint "PyPIP $(msg_installed)"

  Wheel:
    ; Wheel module detection and installation routine.
    IfFileExists "C:\Python27\Scripts\wheel.exe" Soup4 +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install wheel'
    Pop $R0
    ${if} $R0 != "0"
      Abort "Wheel $(msg_not_installed) $R0!"
    ${endif}
    DetailPrint "wheel $(msg_installed)"

  Soup4:
    ; BeautifullSoup4 module detection and installation routine.
    IfFileExists "C:\Python27\Lib\site-packages\bs4\__init__.py" GITpython +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install beautifulsoup4'
    Pop $R0
    ${if} $R0 != "0"
      Abort "beautifulsoup4 $(msg_not_installed) $R0!"
    ${endif}
    DetailPrint "beautifulsoup4 $(msg_installed)"

  GITpython:
    ; python-git module detection and installation routine.
    IfFileExists "C:\Python27\Lib\site-packages\git\__init__.py" PyUSB +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install gitpython'
    Pop $R0
    ${if} $R0 != "0"
      Abort "GIT-Python $(msg_not_installed) $R0!"
    ${endif}
    DetailPrint "GIT-Python $(msg_installed)"

  PyUSB:
    ; PyUSB module detection and installation routine.
    IfFileExists "C:\Python27\Lib\site-packages\usb\__init__.py" PySIDE +1
    nsExec::Exec '"C:\Python27\Scripts\pip.exe" install pyusb==1.0.0b1'
    Pop $R0
    ${if} $R0 != "0"
      Abort "PyUSB $(msg_not_installed) $R0!"
    ${endif}
    DetailPrint "PyUSB $(msg_installed)"

  PySIDE:
    ; PySIDE libraries detection and installation routine.
    IfFileExists "C:\Python27\Lib\site-packages\PySide\__init__.py" PyModulesOk +1
    DetailPrint "PySIDE $(msg_not_detected)"
    DetailPrint $(msg_download_and_install)
    Sleep 5000
    inetc::get ${PySIDE} $EXEDIR\PySide-1.2.1.win32-py2.7.exe
    Pop $R0
    StrCmp $R0 "OK" +2
    Abort "PySIDE $(msg_download_error) $R0!"
    DetailPrint "PySIDE $(msg_download_complete)"
    ExecWait '"$EXEDIR\PySide-1.2.1.win32-py2.7.exe"' $0
    ${if} $0 != "0"
      Abort "PySIDE $(msg_not_installed) $0!"
    ${endif}
    DetailPrint "PySIDE $(msg_installed)"

  PyModulesOk:

  ;Install libUSB...
  Call libUSB

  ;Copy files...
  Call InstallFiles

  ;Publish the project info to the system...
  Call PublishInfo
  
  ;Make shorcuts...
  Call MakeShortcuts

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;--------------------------------
;Uninstaller Section

Section "Uninstall"

  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ;Eliminamos todos los ficheros que instalamos...
  RMDir /r /REBOOTOK "$INSTDIR\v11"
  RMDir /r /REBOOTOK "$INSTDIR\libraries"
  RMDir /r /REBOOTOK "$INSTDIR\compilers"

  ;Delete "$DESKTOP\BarraITS.lnk"
  ;RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
  DeleteRegKey /ifempty HKCU "Software\Pinguino"
  DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;---------------------------------
; Functions

Function InstallFiles
  ;------------------------------------------------------------------------
  ;Try to download and install pinguino-ide repo files from GitHub...
  DetailPrint "pinguino-ide $(msg_not_detected)"
  DetailPrint $(msg_download_and_install)
  Sleep 5000

  IfFileExists "$EXEDIR\pinguino-ide.zip" +6 +1
  inetc::get ${pinguino-ide} "$EXEDIR\pinguino-ide.zip"
  Pop $R0
  StrCmp $R0 "OK" +2
  Abort "pinguino-ide $(msg_download_error) $R0!"
  DetailPrint "pinguino-ide $(msg_download_complete)"

  ClearErrors
  ZipDLL::extractall "$EXEDIR\pinguino-ide.zip" "$EXEDIR"
  IfErrors 0 +2
    Abort "An error ocurr while extract files from pinguino-ide.zip"

  ClearErrors
  CreateDirectory "$INSTDIR\v${FILE_VERSION}"
  CopyFiles "$EXEDIR\pinguino-ide-master\*.*" "$INSTDIR\v${FILE_VERSION}"
  IfErrors 0 +2
    Abort "pinguino-ide.zip: $(msg_error_while_copying) $INSTDIR\v${FILE_VERSION}"

  RMDir /r "$EXEDIR\pinguino-ide-master"
  DetailPrint "pinguino-ide $(msg_installed)"

  ;------------------------------------------------------------------------
  ;Try to download and install pinguino-libraries repo files from GitHub...
  DetailPrint "pinguino-libraries $(msg_not_detected)"
  DetailPrint $(msg_download_and_install)
  Sleep 5000

  IfFileExists "$EXEDIR\pinguino-libraries.zip" +6 +1
  inetc::get ${pinguino-libraries} "$EXEDIR\pinguino-libraries.zip"
  Pop $R0
  StrCmp $R0 "OK" +2
  Abort "pinguino-libraries $(msg_download_error) $R0!"
  DetailPrint "pinguino-libraries $(msg_download_complete)"

  ClearErrors
  ZipDLL::extractall "$EXEDIR\pinguino-libraries.zip" "$EXEDIR"
  IfErrors 0 +2
    Abort "$(msg_error_while_extracting) pinguino-libraries.zip"

  ClearErrors
  CreateDirectory "$INSTDIR\libraries\p8"
  CopyFiles "$EXEDIR\pinguino-libraries-2014.02\p8\*.*" "$INSTDIR\libraries\p8"
  IfErrors 0 +2
    Abort "pinguino-libraries.zip: $(msg_error_while_copying) p8"

  ClearErrors
  CreateDirectory "$INSTDIR\libraries\p32"
  CopyFiles "$EXEDIR\pinguino-libraries-2014.02\p32\*.*" "$INSTDIR\libraries\p32"
  IfErrors 0 +2
    Abort "pinguino-libraries.zip: $(msg_error_while_copying) p32"

  ClearErrors
  CreateDirectory "$INSTDIR\v${FILE_VERSION}\examples"
  CopyFiles "$EXEDIR\pinguino-libraries-2014.02\examples\*.*" "$INSTDIR\v${FILE_VERSION}\examples"
  IfErrors 0 +2
    Abort "pinguino-libraries.zip: $(msg_error_while_copying) examples"

  ClearErrors
  CreateDirectory "$INSTDIR\v${FILE_VERSION}\graphical_examples"
  CopyFiles "$EXEDIR\pinguino-libraries-2014.02\graphical_examples\*.*" "$INSTDIR\v${FILE_VERSION}\graphical_examples"
  IfErrors 0 +2
    Abort "pinguino-libraries.zip: $(msg_error_while_copying) graphical_examples"

  ClearErrors
  CreateDirectory "$INSTDIR\v${FILE_VERSION}\source"
  CopyFiles "$EXEDIR\pinguino-libraries-2014.02\source\*.*" "$INSTDIR\v${FILE_VERSION}\source"
  IfErrors 0 +2
    Abort "pinguino-libraries.zip: $(msg_error_while_copying) source"

  RMDir /r "$EXEDIR\pinguino-libraries-2014.02"
  DetailPrint "pinguino-libraries $(msg_installed)"

  ;------------------------------------------------------------------------
  ;Try to download and install pinguino-compilers repo files from GitHub...
  DetailPrint "pinguino-compilers $(msg_not_detected)"
  DetailPrint $(msg_download_and_install)
  Sleep 5000

  IfFileExists "$EXEDIR\pinguino-compilers.zip" +6 +1
  inetc::get ${pinguino-compilers} "$EXEDIR\pinguino-compilers.zip"
  Pop $R0
  StrCmp $R0 "OK" +2
  Abort "pinguino-compilers $(msg_download_error) $R0!"
  DetailPrint "pinguino-compilers $(msg_download_complete)"

  ClearErrors
  ZipDLL::extractall "$EXEDIR\pinguino-compilers.zip" "$EXEDIR"
  IfErrors 0 +2
    Abort "$(msg_error_while_extracting) pinguino-compilers.zip"

  ClearErrors
  CreateDirectory "$INSTDIR\compilers"
  CopyFiles "$EXEDIR\win32\*.*" "$INSTDIR\compilers"
  IfErrors 0 +2
    Abort "pinguino-compilers.zip: $(msg_error_while_copying) compilers"

  RMDir /r "$EXEDIR\win32"
  DetailPrint "pinguino-compilers $(msg_installed)"
FunctionEnd

Function PublishInfo
  ;Publish info for the "Add & Remove Software" system tool...
  DetailPrint "PublishInfo begin..."
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${FILE_NAME} v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
FunctionEnd

Function MakeShortcuts
  ;Make shortcuts into desktop and start menu to our program...
  DetailPrint "MakeShortcuts begin..."
  CreateShortCut "$DESKTOP\pinguino-ide.lnk" "C:\Python27\python.exe" "$INSTDIR\v${FILE_VERSION}\pinguino.py" 
  ;CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  ;CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
FunctionEnd

Function libUSB
  ; LibUSB libraries detection and installation routine.
  File "/oname=$SYSDIR\libusb0.dll" ..\libusb\libusb0_x86.dll
  File "/oname=$SYSDIR\drivers\libusb0.sys" ..\libusb\libusb0.sys
  File "/oname=$SYSDIR\testlibusb.exe" ..\libusb\testlibusb.exe

  nsExec::Exec '"$SYSDIR\testlibusb.exe"'
  Pop $R0
  ${if} $R0 != "0"
    Abort "libUSB $(msg_not_installed) $R0!"
  ${endif}
    DetailPrint "libUSB $(msg_installed)"
FunctionEnd