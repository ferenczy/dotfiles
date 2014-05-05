dotfiles
========

My configuration files for various *nix tools. Used in [Debian](http://www.debian.org), [Ubuntu](http://www.ubuntu.com), [Raspbian](http://www.raspbian.org) and [Cygwin](http://cygwin.com).

This repository contains only configuration files, so it won't work on its own. It's good rather as inspiration.


zsh
---

Zsh configuration expects, that you have [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) installed in directory `~/.oh-my-zsh`.


vim
---

Vim configuration is based on [Vundle.vim](https://github.com/gmarik/Vundle.vim) plugin manager, which should be located in directory `~/.vim/bundle/Vundle.vim`.


prompt
------

The one thing useful for others and also easily portable could be the prompt. You can see how it looks bellow:

![zsh prompt screenshot](http://ferenczy.cz/github/prompt-zsh.png)

The prompt consists from three lines. The first one is a blank line, so you can clearly and quickly see, where one command ends and another starts. The second one contains various status information (see bellow) and the last one is the command line, so there is always enough space for long commands. There are two versions of prompt configuration in the repository, for bash and zsh. They are almost the same, there is currently the only difference in the git prompt (see bellow).

If the last command returns non-zero code, there will be another line in the prompt, which comes before any other prompt lines, immediately after the last command's output. The only field on this line is the last command exit code in a square brackets. This field is displayed in red colour and also the prompt sign changes colour from green to red, so you can easily notice, that something goes wrong.

Format is as follows:

`
[exit_code]

[date time] username@host working_directory (git_branch git_status)
prompt_sign
`