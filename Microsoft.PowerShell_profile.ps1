# Dawid Ferenczy 2015
# http://github.com/ferenczy/dotfiles
#
# PowerShell profile
#
# Location: %SystemDrive%\Users\<username>\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1

# import PowerTab module
#Import-Module "PowerTab" -ArgumentList "C:\Users\ferenczy\Documents\WindowsPowerShell\PowerTabConfig.xml"

# aliases
new-item alias:np -value "c:\Program Files (x86)\Notepad++\notepad++.exe" > $null

# print PowerShell and CLR versions
Write-Host PowerShell $PSVersionTable.PSVersion "|" CLR $PSVersionTable.CLRVersion -ForegroundColor Magenta
Write-Host

# get identity of currently logged in user
$CurrentIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$global:CurrentUser = $CurrentIdentity.Name.Split("\")[1]

# set function to print the prompt
function prompt {
    Write-Host
    Write-Host ("[" + $(Get-Date -UFormat "%Y-%m-%d %H:%M.%S") + "] ") -nonewline -ForegroundColor DarkCyan
    Write-Host $CurrentUser -nonewline -ForegroundColor Cyan
    Write-Host "@" -nonewline -ForegroundColor DarkMagenta
    Write-Host $env:COMPUTERNAME.ToLower() -nonewline -ForegroundColor Green
    Write-Host " " -nonewline
    Write-Host $(Get-Location) -nonewline -ForegroundColor Yellow
    Write-Host
    Write-Host "$" -nonewline -ForegroundColor Black -BackgroundColor Green
    return " "
}
