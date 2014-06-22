Pinguino-IDE Windows Installer
==============================

v1.1.0-beta1 (NOT FOR PRODUCTION USE)

### Introduction

This installer is a smart program that detect and install all the software required
for run the Pinguino-IDE package in your system. Some goals achieved are:

* Automatically install all the required software for the Pinguino IDE.
* Try to avoid install software that is allready present on the machine.
* Many automatic control points and checks to ensure a clean installation.
* Installer size: 134 Mb.
* Multi-language: English and Spanish supported. More translations comming soon.
* Automatically pre-install the device drivers.

### Requirements

* 500Mb free space on disk for all the installed software.
* This installer should work on any Windows XP, Vista, 7 and 8 machine.
* Both platform supported: 32-bits and 64-bits.

NOTE: Windows XP 64-bits NOT supported yet.
NOTE2: Currently only Windows 32-bits is supported by this beta version of the installer.

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

### Help & Resources

* Pinguino Site: http://www.pinguino.cc
* Pinguino IDE v11 repo: https://github.com/PinguinoIDE
* Pinguino installer: https://github.com/MefhigosetH/PinguinoIDE-Win-Installer

Questions about this installer ? No problem! Drop me an email.

[mefhigoseth at gmail dot com]

### Developers

This installer is build with Nullsoft Scriptable Install System v2.46

Tested on:

* Windows 7 Ultimate 32-bit.