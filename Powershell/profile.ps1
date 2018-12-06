# Dawid Ferenczy 2015 - 2018
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

    $encoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    # set status sign and color according to last command's exit code
    $statusSign = if ($lastCommandStatus)  { '✔' } else { "✗ [$LastExitCode]" }
    $statusColor = if ($lastCommandStatus) { 'Green' } else { 'Red' }

    # get previously executed command, will be Null if it's freshly opened shell
    $lastCommand = Get-History -Count 1
    # print last command's status, exit code and time taken
    if ($lastCommand) {
        Write-Host $statusSign -ForegroundColor $statusColor -nonewline

        $timeTaken = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime)
        Write-Host " (took $(formatTimeTaken($timeTaken)) s)" -ForegroundColor Magenta
    }

    # print horizontal line
    Write-Host ("_" * $Host.UI.RawUI.WindowSize.Width) -ForegroundColor DarkBlue

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

    # set console window title to current working directory
    if (-Not $global:originalWindowTitle) {
        $global:originalWindowTitle = $Host.UI.RawUI.WindowTitle
    }
    $Host.UI.RawUI.WindowTitle = "[$global:originalWindowTitle] $(Get-Location)"

    [Console]::OutputEncoding = $encoding
    $LastExitCode = $originalLastExitCode

    return " "
}

function formatTimeTaken {
    Param($timeTaken)

    $format = if ($timeTaken.TotalSeconds -le 60) { "s\.fff" } else {
        if ($timeTaken.TotalMinutes -le 60) { "m\:ss\.fff" } else { "h\:mm\:ss\.fff" }
    }

    return $timeTaken.ToString($format)
}
