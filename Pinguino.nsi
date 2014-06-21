;----------------------------------------------------
;Pinguino IDE Installation Script
;Public Domain License 2014
;Coded by Victor Villarreal <mefhigoseth@gmail.com>
;----------------------------------------------------
;Defines

!define FILE_NAME 'pinguino-ide'
!define FILE_VERSION '11'
!define FILE_INSTVERSION '11.20140619'
!define FILE_OWNER 'Pinguino Project'
!define FILE_URL 'http://www.pinguino.cc/'
!define MUI_ABORTWARNING
!define MUI_ICON "pinguino-logo-v2.ico"
!define MUI_UNICON "pinguino-logo-v2.ico"
!define MUI_INSTFILESPAGE_PROGRESSBAR "smooth"
!define MUI_WELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "Pinguino-welcomePage.bmp"
!define ADD_REMOVE "Software\Microsoft\Windows\CurrentVersion\Uninstall\${FILE_NAME}"
!define Python27 "python-2.7.7.msi"
!define PyPIP "get-pip.py"
!define PySide "PySide-1.2.2.win32-py2.7.exe"
!define pinguino-ide "pinguino-ide-master.zip"
!define pinguino-libraries "pinguino-libraries.zip"
!define pinguino-compilers "pinguino-compilers.zip"

;--------------------------------
;Includes

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "WinVer.nsh"

;--------------------------------
;General Settings

Name '${FILE_NAME} v${FILE_VERSION}'
OutFile '${FILE_NAME}-${FILE_VERSION}-setup.exe'
BrandingText '${FILE_OWNER}'
InstallDir 'C:\${FILE_NAME}'
;ShowInstDetails show
;Request Admin execution level. Needed to install drivers.
RequestExecutionLevel admin

VIAddVersionKey "ProductName" '${FILE_NAME}'
VIAddVersionKey "ProductVersion" '${FILE_VERSION}'
VIAddVersionKey "CompanyName" '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright" 'Copyright 2014 ${FILE_OWNER}'
VIAddVersionKey "FileDescription" '${FILE_NAME} Installer'
VIAddVersionKey "FileVersion" '${FILE_INSTVERSION}'
VIProductVersion '11.0.0.0'

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

LangString msg_not_detected ${LANG_ENGLISH} "not detected in your system. Installing it..."
LangString msg_not_detected ${LANG_SPANISH} "no detectado en el sistema. Instalando..."

LangString msg_download_and_install ${LANG_ENGLISH} "We'll install it for you, in 5 secs."
LangString msg_download_and_install ${LANG_SPANISH} "Lo instalaremos por ti, en 5 segundos."

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

LangString msg_your_system_is ${LANG_ENGLISH} "Your Operating System is at least"
LangString msg_your_system_is ${LANG_SPANISH} "Tu Sistema Operativo es al menos"

LangString msg_installing_drivers ${LANG_ENGLISH} "Installing the Pinguino Project device drivers"
LangString msg_installing_drivers ${LANG_SPANISH} "Instalando los controladores para el dispositivo Pinguino Project"

;------------------------------------------------------------------------
; Installer Sections
Section "Install"

  ;Default installation folder
  ;strCpy $InstallDest '$PROGRAMFILES' 2
  ;InstallDir '$InstallDest\${FILE_NAME}

  ;Seteamos el directorio de salida para las instrucciones FILE.
  SetOutPath "$INSTDIR\v${FILE_VERSION}"
  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ; Detect and install Python...
  Call InstallPython

  ; Detect and install Python dependencies...
  Call InstallPythonDeps

  ; Detect and install PySide...
  Call InstallPySide

  ;Install pinguino-ide package...
  Call InstallPinguinoIde

  ;Install pinguino-libraries package...
  Call InstallPinguinoLibraries

  ;Install pinguino-compilers package...
  Call InstallPinguinoCompilers

  ;Install device drivers...
  Call InstallDrivers

  ;Publish the project info to the system...
  Call PublishInfo
  
  ;Make shorcuts...
  Call MakeShortcuts

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\pinguino-uninstall.exe"

SectionEnd

;------------------------------------------------------------------------
; Uninstaller Section
Section "Uninstall"

  ;Tipo de instalacion: AllUsers.
  SetShellVarContext all

  ;Eliminamos todos los ficheros que instalamos...
  RMDir /r /REBOOTOK "$INSTDIR\v11"
  RMDir /r /REBOOTOK "$INSTDIR\libraries"
  RMDir /r /REBOOTOK "$INSTDIR\compilers"

  Delete "$DESKTOP\pinguino-ide.lnk"
  RMDir /r "$SMPROGRAMS\${FILE_OWNER}\"
  DeleteRegKey /ifempty HKCU "Software\Pinguino"
  DeleteRegKey HKLM "${ADD_REMOVE}"

SectionEnd

;------------------------------------------------------------------------
; Python v2.7 detection and installation routine.
Function InstallPython

  IfFileExists "C:\Python27\python.exe" PythonAllreadyInstalled +1
  DetailPrint "Python v2.7 $(msg_not_detected)"
  Sleep 5000
  SetOutPath "$TEMP"
  File "..\${Python27}"
  ExecWait '"msiexec" /i "$TEMP\${Python27}"' $0
  ${if} $0 != "0"
    Abort "Python v2.7 $(msg_not_installed) $0!"
  ${endif}
  DetailPrint "Python v2.7 $(msg_installed)"
  
  PythonAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; Detect and install Python dependencies.
Function InstallPythonDeps

	; PIP module detection and installation routine.
	PyPIP:
		IfFileExists "C:\Python27\Scripts\pip.exe" Wheel +1
		DetailPrint "PyPIP $(msg_not_detected)"
		Sleep 5000
		SetOutPath "$TEMP"
		File "..\${PyPIP}"
		ExecWait '"C:\Python27\python" "$TEMP\get-pip.py"' $0
		${if} $0 != "0"
			Abort "PyPIP $(msg_not_installed) $0!"
		${endif}

	; Wheel module detection and installation routine.
	Wheel:
		IfFileExists "C:\Python27\Scripts\wheel.exe" Soup4 +1
		DetailPrint "Wheel $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install wheel'
		Pop $R0
		${if} $R0 != "0"
			Abort "Wheel $(msg_not_installed) $R0!"
		${endif}

	; BeautifullSoup4 module detection and installation routine.
	Soup4:
		IfFileExists "C:\Python27\Lib\site-packages\bs4\__init__.py" GITpython +1
		DetailPrint "BeautifullSoup4 $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install beautifulsoup4'
		Pop $R0
		${if} $R0 != "0"
			Abort "beautifulsoup4 $(msg_not_installed) $R0!"
		${endif}

	; GIT for Python module detection and installation routine.
	GITpython:
		IfFileExists "C:\Python27\Lib\site-packages\git\__init__.py" PyUSB +1
		DetailPrint "GITpython $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install gitpython'
		Pop $R0
		${if} $R0 != "0"
			Abort "GIT-Python $(msg_not_installed) $R0!"
		${endif}
	
	; PyUSB module detection and installation routine.
	PyUSB:
		IfFileExists "C:\Python27\Lib\site-packages\usb\__init__.py" PythonDepsAllreadyInstalled +1
		DetailPrint "PyUSB $(msg_not_detected)"
		nsExec::Exec '"C:\Python27\Scripts\pip.exe" install pyusb==1.0.0b1'
		Pop $R0
		${if} $R0 != "0"
			Abort "PyUSB $(msg_not_installed) $R0!"
		${endif}
	
	PythonDepsAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; Detect and install PySide.
Function InstallPySide

	IfFileExists "C:\Python27\Lib\site-packages\PySide\__init__.py" PySideAllreadyInstalled +1
	DetailPrint "PySide $(msg_not_detected)"
	Sleep 5000
	SetOutPath "$TEMP"
	File "..\${PySide}"
	ExecWait '"$TEMP\${PySide}"' $0
	${if} $0 != "0"
		Abort "PySide $(msg_not_installed) $0!"
	${endif}

	PySideAllreadyInstalled:
FunctionEnd

;------------------------------------------------------------------------
; pinguino-ide installation routine.
Function InstallPinguinoIde

	DetailPrint "pinguino-ide $(msg_not_detected)"
	SetOutPath "$TEMP"
	File "..\${pinguino-ide}"

	ClearErrors
	ZipDLL::extractall "$TEMP\${pinguino-ide}" "$TEMP"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) ${pinguino-ide}"

	ClearErrors

	CreateDirectory "$INSTDIR\v${FILE_VERSION}"
	CopyFiles "$TEMP\pinguino-ide-master\*.*" "$INSTDIR\v${FILE_VERSION}"
	IfErrors 0 +2
		Abort "${pinguino-ide}: $(msg_error_while_copying) $INSTDIR\v${FILE_VERSION}"

	RMDir /r "$TEMP\pinguino-ide-master"

	PinguinoIdeAllreadyInstalled:
FunctionEnd

;--------------------------------------------------------------------------
; pinguino-libraries installation routine.
Function InstallPinguinoLibraries

	DetailPrint "pinguino-libraries $(msg_not_detected)"
	SetOutPath "$TEMP"
	File "..\${pinguino-libraries}"

	ClearErrors
	ZipDLL::extractall "$TEMP\${pinguino-libraries}" "$TEMP"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) ${pinguino-libraries}"

	ClearErrors
	CreateDirectory "$INSTDIR\libraries\p8"
	CopyFiles "$TEMP\pinguino-libraries\p8\*.*" "$INSTDIR\libraries\p8"
	IfErrors 0 +2
		Abort "${pinguino-libraries}: $(msg_error_while_copying) p8"

	ClearErrors
	CreateDirectory "$INSTDIR\v${FILE_VERSION}\examples"
	CopyFiles "$TEMP\pinguino-libraries\examples\*.*" "$INSTDIR\v${FILE_VERSION}\examples"
	IfErrors 0 +2
		Abort "${pinguino-libraries}: $(msg_error_while_copying) examples"

	ClearErrors
	CreateDirectory "$INSTDIR\v${FILE_VERSION}\graphical_examples"
	CopyFiles "$TEMP\pinguino-libraries\graphical_examples\*.*" "$INSTDIR\v${FILE_VERSION}\graphical_examples"
	IfErrors 0 +2
		Abort "${pinguino-libraries}: $(msg_error_while_copying) graphical_examples"

	ClearErrors
	CreateDirectory "$INSTDIR\v${FILE_VERSION}\source"
	CopyFiles "$TEMP\pinguino-libraries\source\*.*" "$INSTDIR\v${FILE_VERSION}\source"
	IfErrors 0 +2
		Abort "${pinguino-libraries}: $(msg_error_while_copying) source"

	RMDir /r "$TEMP\pinguino-libraries"
FunctionEnd

;------------------------------------------------------------------------
; pinguino-compilers installation routine.
Function InstallPinguinoCompilers

	DetailPrint "pinguino-compilers $(msg_not_detected)"
	SetOutPath "$TEMP"
	File "..\${pinguino-compilers}"

	ClearErrors
	CreateDirectory "$INSTDIR\compilers"
	ZipDLL::extractall "$TEMP\${pinguino-compilers}" "$INSTDIR\compilers"
	IfErrors 0 +2
		Abort "$(msg_error_while_extracting) ${pinguino-compilers}"

	Delete "$TEMP\${pinguino-compilers}"
FunctionEnd

Function PublishInfo
  ;Publish info for the "Add & Remove Software" system tool...
  DetailPrint "PublishInfo begin..."
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${FILE_NAME} v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\pinguino-uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
FunctionEnd

Function MakeShortcuts
  ;Make shortcuts into desktop and start menu to our program...
  DetailPrint "MakeShortcuts begin..."
  File "/oname=$INSTDIR\v${FILE_VERSION}\pinguino-logo-v2.ico" pinguino-logo-v2.ico
  CreateShortCut "$DESKTOP\pinguino-ide.lnk" "$INSTDIR\v${FILE_VERSION}\pinguino.bat" "" "$INSTDIR\v${FILE_VERSION}\pinguino-logo-v2.ico"
  CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\pinguino-ide.lnk" "$INSTDIR\v${FILE_VERSION}\pinguino.bat" "" "$INSTDIR\v${FILE_VERSION}\pinguino-logo-v2.ico"
FunctionEnd

Function InstallDrivers
  Var /GLOBAL os_platform
  StrCpy $os_platform "32"
  Var /GLOBAL os_version

  DetailPrint "$(msg_installing_drivers)..."

  SetOutPath "$INSTDIR\drivers"
  File /r "..\drivers\*.*"

  StrCmp $PROGRAMFILES $PROGRAMFILES64 +2
  StrCpy $os_platform "64"

  ${If} ${AtLeastWinVista}
    StrCpy $os_version "Vista"

  ${Else}
    StrCpy $os_version "XP"

    ; LibUSB libraries detection and installation routine.
    CopyFiles "$INSTDIR\drivers\Vista\x86\libusb0_x86.dll" "$SYSDIR\libusb0.dll"
    CopyFiles "$INSTDIR\drivers\Vista\x86\libusb0.sys" "$SYSDIR\drivers\libusb0.sys"
    CopyFiles "$INSTDIR\drivers\testlibusb.exe" "$SYSDIR\testlibusb.exe"

    nsExec::Exec '"$SYSDIR\testlibusb.exe"'
    Pop $R0
    ${if} $R0 != "0"
      Abort "libUSB $(msg_not_installed) $R0!"
    ${endif}
      DetailPrint "libUSB $(msg_installed)"

  ${EndIf}

  DetailPrint "$(msg_your_system_is) Microsoft Windows $os_version ($os_platform bits)."
  DetailPrint "$INSTDIR\drivers\DPInst$os_platform.exe /LM /SW /PATH $INSTDIR\drivers\$os_version\"
  nsExec::Exec '$INSTDIR\drivers\DPInst$os_platform.exe /LM /SW /PATH $INSTDIR\drivers\$os_version\'
  Sleep 5000
FunctionEnd