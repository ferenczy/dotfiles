# display last command's status code, if it's not 0
PROMPT=$'%{$reset_color%}%(?:%{$fg_bold[green]%}✔:%{$fg_bold[red]%}✘ [$?])%{$reset_color%}'

# print duration of the previous command
PROMPT+=$'%{$fg_bold[magenta]%}$COMMAND_EXECUTION_TIME_DURATION_TEXT%{$reset_color%}'

# put a horizontal line between commands
PROMPT+=$'\n%{$fg[blue]%}${(r:$COLUMNS::_:)}%{$reset_color%}\n\n'

# date and time
PROMPT+=$'%{$fg[cyan]%}[%D{%Y-%m-%d %H:%M.%S}]%{$reset_color%} '

# different color for SSH connections
if [[ -n $SSH_CLIENT ]]; then
    host_color=$fg_bold[magenta]
else
    host_color=$fg[magenta]
fi

# username@hostname working_directory Git_status
PROMPT+=$'%{$fg_bold[cyan]%}%n%{$reset_color%}%{$host_color%}@%{$fg_bold[green]%}%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%}$(git_prompt_info)'

# prompt sign (green if the last command was successful, otherwise red)
PROMPT+=$'\n%{$bg[black]%}%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%{\e[7m%}\$%{$reset_color%} '


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[magenta]%} "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔ %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}◒ "
