# Dawid Ferenczy 2014
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
FMAG="\[\033[35m\]" # foreground magenta
FCYN="\[\033[36m\]" # foreground cyan
BBCK="\[\033[40m\]" # background black


# - - - - - Prompt - - - - -

# update prompt according to the last command status
update_prompt ()
{
    STATUS=$?

    # reset colors
    PS1="${RST}"

    # display last command's status code, if it's not 0
    if [[ $STATUS -ne 0 ]]; then
        PS1+="${FRED}${HI}[${STATUS}]${RST}\n"
    fi

    # empty line after last output, date and time
    PS1+="\n${FCYN}[\D{%Y-%m-%d %H:%M.%S}]${RST} "

    # username, hostname and working directory
    PS1+="${HI}${FCYN}\u${RST}${FGRN}@${HI}\h${RST} ${FYLW}${HI}\w${RST}"

    # git - current branch
    type -t __git_ps1 > /dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        PS1+="${HI}${FMAG}$(__git_ps1 ' (%s)')${RST}"
    fi

    # set prompt sign color (green if the last command was successful, otherwise red)
    if [[ $STATUS -eq 0 ]]; then
        STATUS_COLOR="${FGRN}"
    else
        STATUS_COLOR="${FRED}"
    fi

    # prompt sign
    PS1+="\n${STATUS_COLOR}${BBCK}${HI}${INV}\$${RST} "

    # set window title
    case "$TERM" in
        cygwin|xterm*)
            PS1+="\[\033]0;\w\007\]"
    esac
}

PROMPT_COMMAND="update_prompt"


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
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:l[als]' # Ignore the ls command as well

# Whenever displaying the prompt, write the previous line to disk
export -n PROMPT_COMMAND+="; history -a"


# - - - - - Aliases - - - - -

# Common aliases
if [ -f "${HOME}/.aliases" ]; then
  source "${HOME}/.aliases"
fi

# Bash specific aliases
# if [ -f "${HOME}/.bash_aliases" ]; then
#   source "${HOME}/.bash_aliases"
# fi


# - - - - - Umask - - - - -

# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077


# - - - - - Functions - - - - -

# Common functions
if [ -f "${HOME}/.functions" ]; then
  source "${HOME}/.functions"
fi

# Some people use a different file for functions
if [ -f "${HOME}/.bash_functions" ]; then
  source "${HOME}/.bash_functions"
fi
