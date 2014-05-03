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


# - - - - - Performance tunning - - - - -

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


# - - - - - Color definitions - - - - -

RST="\[\033[0m\]"   # reset
HI="\[\033[1m\]"    # hicolor
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
    PS1+="${HI}${FMAG}$(__git_ps1 ' (%s)')${RST}"

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

# Some people use a different file for functions
# if [ -f "${HOME}/.bash_functions" ]; then
#   source "${HOME}/.bash_functions"
# fi
#
# Some example functions:
#
# a) function settitle
# settitle ()
# {
#   echo -ne "\e]2;$@\a\e]1;$@\a";
# }
#
# b) function cd_func
# This function defines a 'cd' replacement function capable of keeping,
# displaying and accessing history of visited directories, up to 10 entries.
# To use it, uncomment it, source this file and try 'cd --'.
# acd_func 1.0.5, 10-nov-2004
# Petar Marinov, http:/geocities.com/h2428, this is public domain
# cd_func ()
# {
#   local x2 the_new_dir adir index
#   local -i cnt
#
#   if [[ $1 ==  "--" ]]; then
#     dirs -v
#     return 0
#   fi
#
#   the_new_dir=$1
#   [[ -z $1 ]] && the_new_dir=$HOME
#
#   if [[ ${the_new_dir:0:1} == '-' ]]; then
#     #
#     # Extract dir N from dirs
#     index=${the_new_dir:1}
#     [[ -z $index ]] && index=1
#     adir=$(dirs +$index)
#     [[ -z $adir ]] && return 1
#     the_new_dir=$adir
#   fi
#
#   #
#   # '~' has to be substituted by ${HOME}
#   [[ ${the_new_dir:0:1} == '~' ]] && the_new_dir="${HOME}${the_new_dir:1}"
#
#   #
#   # Now change to the new dir and add to the top of the stack
#   pushd "${the_new_dir}" > /dev/null
#   [[ $? -ne 0 ]] && return 1
#   the_new_dir=$(pwd)
#
#   #
#   # Trim down everything beyond 11th entry
#   popd -n +11 2>/dev/null 1>/dev/null
#
#   #
#   # Remove any other occurence of this dir, skipping the top of the stack
#   for ((cnt=1; cnt <= 10; cnt++)); do
#     x2=$(dirs +${cnt} 2>/dev/null)
#     [[ $? -ne 0 ]] && return 0
#     [[ ${x2:0:1} == '~' ]] && x2="${HOME}${x2:1}"
#     if [[ "${x2}" == "${the_new_dir}" ]]; then
#       popd -n +$cnt 2>/dev/null 1>/dev/null
#       cnt=cnt-1
#     fi
#   done
#
#   return 0
# }
#
# alias cd=cd_func
