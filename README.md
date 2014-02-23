Windows installer for the Pinguino project
==========================================

This is the Windows installer for the Pinguino IDE v11 @ Pinguino project.

### Introduction

This installer is a smart program that detect, download and install all the software
dependences for run the Pinguino IDE out of the box. Some goals achieved are:

* Download and install all the third party software dependences for the Pinguino IDE.
* Try to avoid download software that is allready installed on the machine.
* Many control points and check to ensure correct data.
* Installer size: Only 300Kb !

### Requirements

* A fast Internet conection.
* 250Mb free space on disk for all the downloaded/installed software.
* This installer should work on any Windows XP, Vista, 7 and 8 machine.
* Actually, only x86 platform supported. 64-bit OS NOT supported.

### Task performed by the installer

It detect, download and install the following packages:

* Python v2.7
* PyPIP
* Wheel
* IntelHex
* BeautifullSoup4
* python-git
* PyUSB
* PySIDE
* libUSB
* pinguino-ide package.
* pinguino-libraries package.
* pinguino-compilers package.

All the Pinguino project related files are download directly
from the official repos at GitHub, ensuring updated stuff all the time.

All the files downloaded by this installer from Internet, are store in the same
folder that the installer. If the installer detect that a software need to be
installed on the machine BUT the needed file is in this folder, it is used instead
of download twice the same file.

NOTE: This software does not install (yet) the drivers for the Microchip PIC!

### Help & Resources

* GitHub repo: https://github.com/MefhigosetH/PinguinoIDE-Win-Installer
* Pinguino IDE v11 repo: https://github.com/PinguinoIDE
* Pinguino Site: http://www.pinguino.cc

Questions about this installer ? No problem! Drop me an email.

MefhigosetH [mefhigoseth at gmail dot com]

### Developers

This installer is build with Nullsoft Scriptable Install System v2.46

Tested on Windows 7 Ultimate 32-bit machine.