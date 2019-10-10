# Dawid Ferenczy 2014 - 2019
# http://github.com/ferenczy/dotfiles

# base-files version 4.1-1
# ~/.bashrc: executed by bash(1) for interactive (non-login) shells.

# User dependent .bashrc file

# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

# - - - - - Shell Options - - - - -

# See man bash for more options...

# Don't wait for job termination notification
# set -o notify

# Don't use ^D to exit
# set -o ignoreeof

# Use case-insensitive filename globbing
# shopt -s nocaseglob

# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# auto-complete executables without .exe extension
shopt -s completion_strip_exe


# - - - - - Performance tuning - - - - -

# check the hash before searching the PATH directories
  shopt -s checkhash

# do not search the path when .-sourcing a file
  shopt -u sourcepath


# - - - - - Completion options - - - - -

# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion


# - - - - - Colour definitions - - - - -

RST="\[\033[0m\]"   # reset
HI="\[\033[1m\]"    # bright colour
INV="\[\033[7m\]"   # inverse background and foreground
FRED="\[\033[31m\]" # foreground red
FGRN="\[\033[32m\]" # foreground green
FYLW="\[\033[33m\]" # foreground yellow
FBLU="\[\033[34m\]" # foreground blue
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
FWHT="\[\033[37m\]" # foreground white
BBCK="\[\033[40m\]" # background black


# - - - - - Prompt - - - - -

# update prompt according to the last command status
update_prompt ()
{
    # store last command exit code
    local STATUS=$?

    local LAST_COMMAND_DURATION=$(calculate_last_command_duration)

    # detect if this is the first time prompt is printed in the current session
    local FIRST_RUN=false
    if [ -z ${PROMPT_INITIALIZED+x} ]; then
        FIRST_RUN=true
        PROMPT_INITIALIZED=true
    fi

    # set prompt sign color (green if the last command was successful, otherwise red) and the last command status sign
    local STATUS_COLOR
    local STATUS_CHAR
    if [[ $STATUS -eq 0 ]]; then
        STATUS_COLOR="${FGRN}"
        STATUS_CHAR="✔"
    else
        STATUS_COLOR="${FRED}"
        STATUS_CHAR="✘"
    fi

    # reset colors
    PS1="${RST}"

    if [ $FIRST_RUN == false ]; then
        # print the last command status character
        PS1+="${STATUS_COLOR}${HI}${STATUS_CHAR}${RST}"

        # print the last command's status code, if it's not 0
        if [[ $STATUS -ne 0 ]]; then
            PS1+=" ${FRED}${HI}[${STATUS}]${RST}"
        fi

        # print the last command duration
        PS1+=" ${FMAG}${HI}(${LAST_COMMAND_DURATION})${RST}\n"

        # print a horizontal line over the full width of the console
        PS1+="${FBLU}$(printf '%*s\n' "$(tput cols)" | tr ' ' -)\n"
    fi

    # empty line after last output, date and time
    PS1+="\n${FCYN}[\D{%Y-%m-%d %H:%M.%S}]${RST} "

    # different color for SSH connections
    local HOST_COLOR=""
    if [[ $SSH_CLIENT ]]; then
        HOST_COLOR=$HI
    fi

    # username, hostname and working directory
    PS1+="${HI}${FCYN}\u${RST}${FMAG}${HOST_COLOR}@${HI}${FGRN}\h${RST} ${FYLW}${HI}\w${RST}"

    # git - current branch
    type -t __git_ps1 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        PS1+="${HI}${FMAG}$(__git_ps1 ' (%s)')${RST}"
    fi

    # prompt sign
    PS1+="\n${STATUS_COLOR}${BBCK}${HI}${INV}\$${RST} "

    # set window title
    case "$TERM" in
        cygwin|xterm*)
            PS1+="\[\033]0;\w\007\]"
    esac

    # write history to the disk
    # history -a
}

PROMPT_COMMAND="update_prompt"

calculate_last_command_duration() {
    # only continue if the start time has been recorded
    [[ -z $COMMAND_EXECUTION_TIME_START ]] && return

    # calculate how many milliseconds the last command took
    local COMMAND_EXECUTION_TIME_END=$(date +%s%3N)
    local DURATION_MS=$(( $COMMAND_EXECUTION_TIME_END - $COMMAND_EXECUTION_TIME_START ))

    # convert milliseconds into hours, minutes, seconds and milliseconds
    local DURATION_TEXT
    local HOURS=$((DURATION_MS / 1000 / 60 / 60))
    local MINUTES=$((DURATION_MS / 1000 / 60 % 60))
    local SECONDS=$((DURATION_MS / 1000 % 60))
    local MS=$(printf '%03d' $((DURATION_MS % 1000)))

    # construct duration text in format [[h:]m:]s.ms
    (( $HOURS > 0 )) && DURATION_TEXT+="$HOURS:"
    (( $MINUTES > 0 )) && DURATION_TEXT+="$MINUTES:"

    # get last command end date and time
    local END_TIME_SEC=$((COMMAND_EXECUTION_TIME_END / 1000))
    local COMMAND_END_DATE=$(date -d @$END_TIME_SEC +%F)
    local COMMAND_END_TIME=$(date -d @$END_TIME_SEC +%T)

    # construct final string
    DURATION_TEXT+="took $SECONDS.$MS s, finished on $COMMAND_END_DATE at $COMMAND_END_TIME"

    unset COMMAND_EXECUTION_TIME_START

    echo $DURATION_TEXT
}

# store start time of every command executed
preexec_capture_start_time () {
    [ -n "$COMP_LINE" ] && return  # do nothing if completing
    [ "$BASH_COMMAND" = "$PROMPT_COMMAND" ] && return # don't cause a preexec for $PROMPT_COMMAND

    COMMAND_EXECUTION_TIME_START=$(date +%s%3N)
}
trap 'preexec_capture_start_time' DEBUG


# - - - - - History Options - - - - -

# Make bash append rather than overwrite the history on disk
shopt -s histappend

# Don't put duplicate lines  or lines starting with space in the history.
export HISTCONTROL=ignoreboth:erasedups

# setting history length
HISTSIZE=1000
HISTFILESIZE=2000

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:l[als]:pwd' # Ignore the ls command as well


# - - - - - Umask - - - - -

# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077


# - - - - - Aliases - - - - -

# Common aliases
if [[ -f "${HOME}/.aliases" ]]; then
  source "${HOME}/.aliases"
fi


# - - - - - Functions - - - - -

# Common functions
if [[ -f "${HOME}/.functions" ]]; then
  source "${HOME}/.functions"
fi


# - - - - - Local setting - - - - -

# Put your custom setting there
if [[ -f "${HOME}/.localrc" ]]; then
  source "${HOME}/.localrc"
fi

# add "bin" directory in user's home to the PATH
export PATH=$PATH:~/bin
