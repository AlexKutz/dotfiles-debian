# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Add .local/bin to PATH if not in
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH

# Make alias output colorful
myalias() {
  if [ $# -eq 0 ]; then
    command alias | bat --language=sh --style=plain
  else
    command alias "$@"
  fi
}

alias alias='myalias'

# Default editor
export EDITOR='nvim'

# ls aliaces
alias lsg='(ls -Fhl --color=auto --group-directories-first -d .[^.]*; ls -Fhl --color=auto --group-directories-first)'

alias ls='LC_COLLATE=C ls -Fh --color=auto --group-directories-first'
alias ll='ls -l'
alias lla="ll -a"
alias lsa="ll -a"
alias ls.='ll -d .*'

# alias cat='bat'

alias bathelp='bat --plain --language=help'
help() {
    "$@" --help 2>&1 | bathelp
}

# bash prompt
PS1='\[\033[1;32m\][\u \w]\[\033[0m\]\$ '

alias poweroff="sudo poweroff"
alias reboot="sudo reboot"

alias vim="nvim"

# fzf-nova на Alt+M
bind -x '"\em": fzf-nova'


# Git dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lsconfig='config ls-files -z | xargs -0 ls -la --color=auto --group-directories-first'

alias wttr="curl 'wttr.in/Stara+Syniava?lang=uk&F'"
alias wttrnow="curl 'wttr.in/Stara+Syniava?lang=uk&0pqF'"
alias wttr2="curl v2.wttr.in/Stara+Syniava?lang=uk"

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    # alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    # alias fgrep='fgrep --color=auto'
    # alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# 1. Сортировка как в LC_COLLATE=C (точки сверху)
export LC_COLLATE=C

# 2. Говорим bash-completion сортировать директории первыми
bind 'set completion-ignore-case on'   # игнорировать регистр
bind 'set mark-directories on'         # добавлять / к директориям
bind 'set show-all-if-ambiguous on'    # сразу показывать варианты
bind 'set colored-completion-prefix on'


# 3. Кастомная функция сортировки (dirs first, скрытые dirs первыми, затем скрытые файлы)
_complete_ls() {
    local IFS=$'\n'
    COMPREPLY=( $(compgen -f -- "$2" | LC_COLLATE=C sort -t/ -k1,1) )
}
complete -F _complete_ls ls

