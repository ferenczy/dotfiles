# Dawid Ferenczy 2014
# http://github.com/ferenczy/dotfiles

# ~/.zprofile: executed by zsh(1) for login shells.

# User dependent .zprofile file

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ "$ZSH_FRAMEWORK" == "zprezto" && "$SHLVL" -eq 1 && ! -o LOGIN && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${HOME}/.zprezto/runcoms/zprofile"
fi

# source common profile
if [[ -f "${HOME}/.profile" ]] ; then
  source "${HOME}/.profile"
fi
