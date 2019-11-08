# Dawid Ferenczy 2014 - 2019
# http://github.com/ferenczy/dotfiles

# .zshrc: Z shell configuration files

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="ferenczy"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to disable command auto-correction.
# DISABLE_CORRECTION="true"

# Note the location of each command the first time it is executed, avoiding PATH search for subsequent invocations
setopt HASH_CMDS

# Allow comments even in an interactive shell
setopt INTERACTIVE_COMMENTS

# Enable substitution of parameters inside the prompt each time it's printed
setopt PROMPTSUBST


# - - - - - Auto-completion settings - - - - -

# Make the completion list smaller by printing the matches in columns with different widths
setopt LIST_PACKED

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# complete ".." etc.
zstyle ':completion:*' special-dirs true

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(bower colored-man-pages colorize composer extract gem git git-extras knife node nvm pip screen vagrant virtualenv web-search zsh-autosuggestions zsh-syntax-highlighting)

# source Prezto
if [[ "$ZSH_FRAMEWORK" == "zprezto" && -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# source oh-my-zsh
if [[ "$ZSH_FRAMEWORK" == "oh-my-zsh" && -s "$ZSH/oh-my-zsh.sh" ]]; then
  source $ZSH/oh-my-zsh.sh
fi


# - - - - - User configuration - - - - -

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# History settings
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY            # Write the history file in the ":start:elapsed;command" format.
unsetopt INC_APPEND_HISTORY        # Don't write history file after each command is entered, not when the shell exits.
setopt INC_APPEND_HISTORY_TIME     # Write history file after each command is finished to correctly record the time taken by the command.
unsetopt SHARE_HISTORY             # Don't share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS            # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS        # Delete old recorded entry if new entry is a duplicate.
setopt HIST_SAVE_NO_DUPS           # Don't write duplicate entries in the history file.
# setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE           # Don't record an entry starting with a space.
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY                 # Don't execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# zsh Syntax Highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

if [[ -n ${ZSH_HIGHLIGHT_STYLES} ]]; then
    typeset -A ZSH_HIGHLIGHT_STYLES
    ZSH_HIGHLIGHT_STYLES[alias]='fg=black,bg=cyan'
    ZSH_HIGHLIGHT_STYLES[assign]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
    ZSH_HIGHLIGHT_STYLES[command]='fg=black,bg=white'
    ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow,bold'
    ZSH_HIGHLIGHT_STYLES[function]='fg=black,bg=green'
    ZSH_HIGHLIGHT_STYLES[globbing]='fg=cyan'
    ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=black,bg=yellow'
    ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,bold'
    ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=black,bg=magenta'
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=magenta,bold'
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=magenta'
    ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
    ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold,bg=red'
fi

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



add-zsh-hook preexec execution_timer_preexec_hook
add-zsh-hook precmd execution_timer_precmd_hook

# Execution time start
execution_timer_preexec_hook() {
    COMMAND_EXECUTION_TIME_START=$(date +%s)
}

# Execution time end
execution_timer_precmd_hook() {
    [[ $SPACESHIP_EXEC_TIME_SHOW == false ]] && return
    [[ -n $COMMAND_EXECUTION_TIME_DURATION ]] && unset COMMAND_EXECUTION_TIME_DURATION
    # only continue if the start time has been recorded
    [[ -z $COMMAND_EXECUTION_TIME_START ]] && return
    local COMMAND_EXECUTION_TIME_STOP=$(date +%s)
    local COMMAND_EXECUTION_TIME_DURATION=$(( $COMMAND_EXECUTION_TIME_STOP - $COMMAND_EXECUTION_TIME_START ))
    unset COMMAND_EXECUTION_TIME_START

    COMMAND_EXECUTION_TIME_DURATION_TEXT=" (took $COMMAND_EXECUTION_TIME_DURATION s)"
}

