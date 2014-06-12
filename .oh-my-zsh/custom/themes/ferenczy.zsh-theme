# display last command's status code, if it's not 0
PROMPT=$'%{$reset_color%}%(?::%{$fg_bold[red]%}[$?]%{$reset_color%}\n)'

# put empty line after last output
PROMPT+=$'\n'

# date and time
PROMPT+=$'%{$fg[cyan]%}[%D{%Y-%m-%d %H:%M.%S}]%{$reset_color%} '

# username@hostname working_directory (git_branch)
PROMPT+=$'%{$fg_bold[cyan]%}%n%{$reset_color%}%{$fg[green]%}@%{$fg_bold[green]%}%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%}$(git_prompt_info)'

# prompt sign (green if the last command was successful, otherwise red)
PROMPT+=$'\n%{$bg[black]%}%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%})%{\e[7m%}\$%{$reset_color%} '


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[magenta]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg_bold[magenta]%})%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%}◒ "