# Dawid Ferenczy 2015 - 2018
# http://github.com/ferenczy/dotfiles
#
# PowerShell 6 Core profile "Current User All Hosts"
#
# Location: %SystemDrive%\Users\<username>\Documents\PowerShell\profile.ps1
#

# print PowerShell version
Write-Host PowerShell $PSVersionTable.PSVersion $PSVersionTable.PSEdition -ForegroundColor Magenta
Write-Host


# - - - define aliases - - -
new-item alias:np -value "c:\Program Files (x86)\Notepad++\notepad++.exe" > $null
new-item alias:atom -value "C:\Users\ferenczy\AppData\Local\atom\atom.exe" > $null


# - - - import modules - - -
Import-Module posh-git

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}


# - - - configure modules - - -
# configure PSReadline module
Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash-like auto-complete
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadLineOption –HistoryNoDuplicates:$True
Set-PSReadLineOption -ExtraPromptLineCount:5
Set-PSReadLineOption -ShowToolTips:$True #show tooltips in the list of completions

# forward and backward history search using the text already entered before the cursor
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward


# - - - define variables - - -
# disable automatic addition of Python's virtualenv into prompt as it's implemented in the global:prompt function
$env:VIRTUAL_ENV_DISABLE_PROMPT = $True


# - - - define functions - - -
function global:prompt {
    $lastCommandStatus = $?
    $originalLastExitCode = $LastExitCode

    if ($lastCommandStatus) {
        $statusColor = 'Green'
        $statusSign = '✔ ';
    } else {
        $statusColor = 'Red'
        $statusSign = "✗ [$LastExitCode]";
    }

    $encoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    # print last command's status and exit code
    Write-Host $statusSign -ForegroundColor $statusColor
    Write-Host
    # print Python virtualenv, if active
    if ($env:VIRTUAL_ENV) {
        Write-Host "($(split-path $env:VIRTUAL_ENV -leaf)) " -nonewline -ForegroundColor DarkMagenta
    }
    # print current date and time
    Write-Host ("[" + $(Get-Date -UFormat "%Y-%m-%d %H:%M.%S") + "] ") -nonewline -ForegroundColor DarkCyan
    # print username
    Write-Host $env:username -nonewline -ForegroundColor Cyan
    Write-Host "@" -nonewline -ForegroundColor DarkMagenta
    # print hostname
    Write-Host $env:COMPUTERNAME.ToLower() -nonewline -ForegroundColor Green
    Write-Host " " -nonewline
    # print current working directory
    Write-Host $(Get-Location) -nonewline -ForegroundColor Yellow
    Write-VcsStatus
    Write-Host
    # print prompt sign in color according to last command's status
    Write-Host "$" -nonewline -ForegroundColor Black -BackgroundColor $statusColor
    [Console]::OutputEncoding = $encoding

    $LastExitCode = $originalLastExitCode

    return " "
}
