# display last command's status code, if it's not 0
PROMPT=$'%{$reset_color%}%(?::%{$fg_bold[red]%}[$?]%{$reset_color%}\n)'

# put empty line after last output
PROMPT+=$'\n'

# date and time
PROMPT+=$'%{$fg[cyan]%}[%D{%Y-%m-%d %H:%M.%S}]%{$reset_color%} '

# username, hostname and working directory
PROMPT+=$'%{$fg_bold[cyan]%}%n%{$reset_color%}%{$fg[green]%}@%{$fg_bold[green]%}%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%}'

# prompt sign (green if the last command was successful, otherwise red)
PROMPT+=$'\n%{$bg[black]%}%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%{\e[7m%}\$%{$reset_color%} '


ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
