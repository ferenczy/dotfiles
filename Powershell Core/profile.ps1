# Dawid Ferenczy 2015 - 2021
# http://github.com/ferenczy/dotfiles
#
# PowerShell Core profile "Current User All Hosts"
#
# Location: %SystemDrive%\Users\<username>\Documents\PowerShell\profile.ps1
#

# print PowerShell version
Write-Host PowerShell $PSVersionTable.PSVersion $PSVersionTable.PSEdition -ForegroundColor Magenta
Write-Host


# - - - define aliases - - -
new-item alias:np -Force -Value "c:\Program Files (x86)\Notepad++\notepad++.exe" > $null


# - - - import modules - - -
Import-Module posh-git

$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}


# - - - configure modules - - -

# configure PSReadline module
#Set-PSReadlineKeyHandler -Key Tab -Function Complete # bash-like auto-complete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key Alt+Backspace -Function ShellBackwardKillWord
Set-PSReadlineKeyHandler -Key Ctrl+d -Function ViExit # alternatively DeleteCharOrExit
Set-PSReadlineKeyHandler -Key Ctrl+g -Function Abort # e.g. abort incremental history search
Set-PSReadlineKeyHandler -Key Ctrl+Shift+Delete -Function ViDeleteBrace # find matching brace and delete everything inbetween
Set-PSReadlineKeyHandler -Key Alt+Delete -Function ViReplaceLine # delete the whole line
Set-PSReadlineKeyHandler -Key Ctrl+] -Function GotoBrace # go to the matching brace
Set-PSReadlineKeyHandler -Key Ctrl+/ -Function ShowKeyBindings
Set-PSReadlineKeyHandler -Key Ctrl+shift+? -Function WhatIsKey
Set-PSReadLineOption -PredictionSource History # enable predictive IntelliSense, set to None to disable
Set-PSReadLineOption –HistoryNoDuplicates:$True
Set-PSReadLineOption –HistorySearchCursorMovesToEnd:$True
Set-PSReadLineOption -ExtraPromptLineCount:5
Set-PSReadLineOption -ShowToolTips:$True #show tooltips in the list of completions

# forward and backward history search using the text already entered before the cursor
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

# configure posh-git
$GitPromptSettings.BeforeText = '  '
$GitPromptSettings.BeforeForegroundColor = [ConsoleColor]::Magenta
$GitPromptSettings.AfterText = ''
$GitPromptSettings.BranchForegroundColor = [ConsoleColor]::Magenta

# - - - define environment variables - - -
# disable automatic addition of Python's virtualenv into prompt as it's implemented in the global:prompt function
$env:VIRTUAL_ENV_DISABLE_PROMPT = $True


# - - - define functions - - -
function global:prompt {
    # capture status and exit code of the previously executed command
    $lastCommandStatus = $?
    $originalLastExitCode = $LastExitCode

    # save current console encoding and set it to UTF-8
    $encoding = [Console]::OutputEncoding
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

    # set status sign and color according to last command's exit code
    $statusSign = if ($lastCommandStatus)  { '✔' } else { "✗ [$LastExitCode]" }
    $statusColor = if ($lastCommandStatus) { [ConsoleColor]::Green } else { [ConsoleColor]::Red }

    # get previously executed command, will be Null if it's freshly opened shell
    $lastCommand = Get-History -Count 1
    # if there's any previously executed command
    if ($lastCommand) {
        # print last command's status and exit code
        Write-Host $statusSign -ForegroundColor $statusColor -nonewline

        # calculate the time taken by the execution of the previous command
        $timeTaken = ($lastCommand.EndExecutionTime - $lastCommand.StartExecutionTime)
        $timeTakenMsg = " (took $(formatTimeTaken($timeTaken)) s" +
            ", finished on $($lastCommand.EndExecutionTime.ToString('yyyy-MM-dd'))" +
            " at $($lastCommand.EndExecutionTime.ToString('HH:mm.ss')))"
        # print the time taken by the execution of the previous command
        Write-Host $timeTakenMsg -ForegroundColor Magenta
    }

    # print a horizontal line over the full width of the console
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

    # restore the original console encoding and the previous command's exit code
    [Console]::OutputEncoding = $encoding
    $LastExitCode = $originalLastExitCode

    return " "
}


# - - - - - Function Definitions - - - - -

# format timestamp as a human-readable string ([[h:]m:]s.fff)
function formatTimeTaken {
    Param($timeTaken)

    $format = if ($timeTaken.TotalSeconds -le 60) { "s\.fff" } else {
        if ($timeTaken.TotalMinutes -le 60) { "m\:ss\.fff" } else { "h\:mm\:ss\.fff" }
    }

    return $timeTaken.ToString($format)
}

# print PATH environment variable split by new lines
function path {
    echo $env:PATH.split(';')
}

# include local function definitions
$localFunctions = $PSScriptRoot + "\local-functions.ps1"
if (Test-Path $localFunctions) {
    . $localFunctions
}

# include local configuration
$localProfile = $PSScriptRoot + "\local.ps1"
if (Test-Path $localProfile) {
    . $localProfile
}
