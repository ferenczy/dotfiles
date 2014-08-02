# Dawid Ferenczy 2014
# http://github.com/ferenczy/dotfiles

# ~/.zprofile: executed by zsh(1) for login shells.

# User dependent .zprofile file

# source common profile
if [ -f "${HOME}/.profile" ] ; then
  source "${HOME}/.profile"
fi
