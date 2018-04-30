@echo off
REM use this file if ExecutionPolicy is set
Powershell.exe -ExecutionPolicy Bypass -noprofile -file "C:\Program Files (x86)\check_mk\plugins\win_printers.ps1"