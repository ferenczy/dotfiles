﻿# Dawid Ferenczy 2015 - 2018
# http://github.com/ferenczy/dotfiles
#
# PowerShell profile "Current User All Hosts"
#
# Location: %SystemDrive%\Users\<username>\Documents\WindowsPowerShell\profile.ps1
#

# print PowerShell and CLR versions
Write-Host PowerShell $PSVersionTable.PSVersion "|" CLR $PSVersionTable.CLRVersion -ForegroundColor Magenta
Write-Host


# - - - define aliases - - -
new-item alias:np -value "c:\Program Files (x86)\Notepad++\notepad++.exe" > $null
new-item alias:atom -value "C:\Users\ferenczy\AppData\Local\atom\atom.exe" > $null


# - - - import modules - - -
Import-Module posh-git
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"


# - - - configure modules - - -
# configure PSReadline module
Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash-like auto-complete
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord


# - - - define functions - - -
function global:prompt {
    $lastCommandStatus = $?
    if ($lastCommandStatus) {
        $statusColor = 'Green'
        $statusSign = '✔ ';
    } else {
        $statusColor = 'Red'
        $statusSign = '✗ ';
    }

    $encoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    Write-Host $statusSign -ForegroundColor $statusColor
    Write-Host
    Write-Host ("[" + $(Get-Date -UFormat "%Y-%m-%d %H:%M.%S") + "] ") -nonewline -ForegroundColor DarkCyan
    Write-Host $env:username -nonewline -ForegroundColor Cyan
    Write-Host "@" -nonewline -ForegroundColor DarkMagenta
    Write-Host $env:COMPUTERNAME.ToLower() -nonewline -ForegroundColor Green
    Write-Host " " -nonewline
    Write-Host $(Get-Location) -nonewline -ForegroundColor Yellow
    Write-Host
    Write-Host "$" -nonewline -ForegroundColor Black -BackgroundColor $statusColor
    [Console]::OutputEncoding = $encoding

    return " "
}