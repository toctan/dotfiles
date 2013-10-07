# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
alias t='_ZSH_TMUX_FIXED_CONFIG=~/.oh-my-zsh/plugins/tmux/tmux.extra.conf
_zsh_tmux_plugin_run'
alias rj='sudo ~/Public/rj/rjsupplicant.sh -d0 -uyy163141 -p687286 & && sudo /etc/init.d/network-manager start'
alias sp='export http_proxy=http://localhost:8087'
alias lc='sudo updatedb && locate'

alias vi='vim'
alias dw='axel -a -n 10'
alias p='ping -c 4'
alias p6='ping6 -c 4'

alias e='emacsclient'
alias E="SUDO_EDITOR=\"emacsclient -t -a emacs\" sudoedit"

alias b='bundle'
alias s='rails s'
alias s1='rails s -p 3001'

function explain {
  url="http://explainshell.com/explain/$1?args="
  shift;
  for i in "$@"; do
    url=$url"$i""+"
  done
  xdg-open $url
}

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Customize to your needs...
# export PATH
# export RI="--format ansi --width 70"
# export RACK_ENV="development"

export EDITOR="emacsclient"
export ALTERNATE_EDITOR=
export TERM=xterm-256color

# eval `dircolors ~/.dircolors`
setopt histignorealldups

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git archlinux systemd gem heroku bundler rvm rails spring github
    extract colored-man command-not-found autojump tmux)

source $ZSH/oh-my-zsh.sh

# PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
