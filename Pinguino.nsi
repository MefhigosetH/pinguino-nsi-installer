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

  IfFileExists "c:\Python27\Python.exe" Python27Ok Python27Download

  Python27Download:
     DetailPrint "Python 2.7 not detected in your system."
     DetailPrint "We'll download and install it for you in 5 secs."
     Sleep 5000
     NSISdl::download ${PYTHON27URL} $EXEDIR\python-2.7.6.msi
     Pop $R0
     StrCmp $R0 "success" Python27Ok
     Abort "Download Python 2.7 failed: $R0!"

  Python27Ok:
     ExecWait $EXEDIR\python-2.7.6.msi $0
     DetailPrint "Python exit code: $0."

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