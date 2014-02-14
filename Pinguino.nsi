;----------------------------------------------------
;Pinguino IDE Installation Script
;Public Domain License 2014
;Coded by Victor Villarreal <mefhigoseth@gmail.com>
;----------------------------------------------------
;Defines

!define FILE_NAME 'Pinguino-IDE'
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

;--------------------------------
;Includes

!include "MUI2.nsh"
!include "FileFunc.nsh"

;--------------------------------
;General Settings

Name '${FILE_NAME} v${FILE_VERSION}'
OutFile '${FILE_NAME}-${FILE_VERSION}-setup.exe'
VIAddVersionKey "ProductName" '${FILE_NAME}'
VIAddVersionKey "ProductVersion" '${FILE_VERSION}'
VIAddVersionKey "CompanyName" '${FILE_OWNER}'
VIAddVersionKey "LegalCopyright" 'Copyright 2014 ${FILE_OWNER}'
VIAddVersionKey "FileDescription" '${FILE_NAME} Installer'
VIAddVersionKey "FileVersion" '${FILE_INSTVERSION}'
VIProductVersion '${FILE_INSTVERSION}'
BrandingText '${FILE_OWNER}'

InstallDir 'C:\${FILE_NAME}'

;--------------------------------
;Pages

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

!insertmacro MUI_LANGUAGE "Spanish"

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

  ;Copiamos los archivos a la carpeta de instalacion...
  File /r /x .git ..\${FILE_NAME}\*.*

  ;Publicamos en "Agregar o Crear Programas".
  WriteRegStr HKCU "Software\Pinguino" "" "$INSTDIR\v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "DisplayName" "${FILE_NAME} v${FILE_VERSION}"
  WriteRegStr HKLM "${ADD_REMOVE}" "UninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\""
  WriteRegStr HKLM "${ADD_REMOVE}" "QuietUninstallString" "$\"$INSTDIR\v${FILE_VERSION}\uninstall.exe$\" /S"
  WriteRegStr HKLM "${ADD_REMOVE}" "HelpLink" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "URLInfoAbout" "${FILE_URL}"
  WriteRegStr HKLM "${ADD_REMOVE}" "Publisher" "${FILE_OWNER}"
  
  ;Creamos accesos directos.
  ;CreateShortCut "$DESKTOP\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"
  ;CreateDirectory "$SMPROGRAMS\${FILE_OWNER}\"
  ;CreateShortCut "$SMPROGRAMS\${FILE_OWNER}\BarraITS.lnk" "$INSTDIR\${FILE_NAME}\barraITS.exe"

  ;Creamos el Unistaller.
  WriteUninstaller "$INSTDIR\v${FILE_VERSION}\Uninstall.exe"

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