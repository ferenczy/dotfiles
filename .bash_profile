# Dawid Ferenczy 2014 - 2017
# http://github.com/ferenczy/dotfiles

# base-files version 4.1-1
# ~/.bash_profile: executed by bash(1) for login shells.

# User dependent .bash_profile file

# Set user-defined locale
export LANG=$(locale -uU)
export LC_ALL=$(locale -uU)

# source common profile
if [[ -f "${HOME}/.profile" ]]; then
  source "${HOME}/.profile"
fi

# if running interactive, source the users .bashrc if it exists
if [[ $- == *i* && -f "${HOME}/.bashrc" ]]; then
  source "${HOME}/.bashrc"
fi

# Exclude long paths and Windows directories from the PATH environment variable
# PATH="/usr/local/bin:/usr/bin"

# Set PATH so it includes user's private bin if it exists
if [[ -d "${HOME}/bin" ]]; then
  PATH="${HOME}/bin:${PATH}"
fi

# Set MANPATH so it includes users' private man if it exists
# if [ -d "${HOME}/man" ]; then
#   MANPATH="${HOME}/man:${MANPATH}"
# fi

# Set INFOPATH so it includes users' private info if it exists
# if [ -d "${HOME}/info" ]; then
#   INFOPATH="${HOME}/info:${INFOPATH}"
# fi
