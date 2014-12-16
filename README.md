Pinguino-IDE Windows Installer
==============================

v1.1.0-beta3 (NOT FOR PRODUCTION USE)

### Introduction

This installer is a smart program that detect and install all the software
required for run the Pinguino-IDE package in your system.

Some goals achieved are:

* Automatically install all the required software for the Pinguino IDE.
* Try to avoid install software that is allready present on the machine.
* Many automatic control points and checks to ensure a clean installation.
* Installer size: 57 Mb.
* Multi-language: Translated to 5 languages (English, French, Italian,
  Portuguese and Spanish).
* Automatically pre-install the Pinguino device drivers.

### Requirements

* This installer should work fine on the following Microsoft O.S.:
  + Windows XP (32-bits only).
  + Windows Vista (32 and 64-bits).
  + Windows 7 (32 and 64-bits).
  + Windows 8 (32 and 64-bits).
* 500Mb free space on disk for all the installed software.

NOTE: Windows XP 64-bits is NOT supported or tested yet.

### Task performed by the installer

It detect and install the following packages:

* Python v2.7.7
* PyPIP
* Wheel
* BeautifullSoup4
* python-git
* PyUSB
* PySIDE v1.2.2
* libUSB
* pinguino-ide package.
* pinguino-libraries package.
* pinguino-compilers package.
* Pinguino device drivers.

### Features
* PIC32 compilers and libraries added.
* Italian language translation, thanks to Pasquale Fersini.
* French language translation, thanks to Regis Blanchot.
* Download the proper Pinguino Compiler based on system architecture (32/64).
* Allows user to select the compilers to be installed (PIC8 and/or PIC32).

### Improvements
* The installer get the latest Pinguino packages from SourceForge.

### Fixes
* Fixed Windows Vista and later Pinguino device driver pre-install.

### Help & Resources

* Pinguino Site: http://www.pinguino.cc
* Pinguino IDE v11 repo: https://github.com/PinguinoIDE
* Pinguino installer: https://github.com/MefhigosetH/PinguinoIDE-Win-Installer

Questions about this installer ? No problem! Drop me an email.

[mefhigoseth at gmail dot com]

### Developers

This installer is build with Nullsoft Scriptable Install System v2.46

More Developer documentation, comming soon. Stay tuned!

Tested on:

* Windows XP Professional SP2 32-bit.
* Windows 7 Ultimate 32-bit.