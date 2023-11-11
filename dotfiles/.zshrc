#
# dot.zshrc
#

# PROMPT
PROMPT="[%n@${HOST} %1~:%U%?%u]%(!.#.$) "

# PATH
export PATH=$PATH:/usr/sbin:/sbin

# History
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

# Pager
export PAGER=less

# Editor. Don't export.
EDITOR=vi

# Command Alias
alias ll='ls -l'
alias la='ls -la'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -F'
alias less='less -rf'
alias psa='ps auxwww'
alias h='history-all | tail -100'
alias -g L="| less"
alias -g LL='2>&1 | less'
alias -g G='| grep'
alias -g GG='2>&1 | grep'


#
# ZSH Options
#

# History Search
bindkey '^O' history-beginning-search-backward
bindkey '^Y' history-beginning-search-forward

# Show history with "cd -"
setopt auto_pushd

# append history with others
setopt append_history

# expand glob
setopt extended_glob

# show detail of history
function history-all() {
    history -E 1
}

# show command options with TAB key
autoload -U compinit
compinit 

# delete duplicated history
#setopt hist_ignore_dups

# share history
setopt share_history

# cd directly
setopt auto_cd

# show prompt on current line
setopt transient_rprompt

# show completion with color
#zstyle ':completion:*' list-colors ''

# disable beep
setopt No_beep

# disable ctrl-S/ctrl-Q
setopt NO_flow_control

# =command ==> which command
setopt equals

# show candidates like ls -F
setopt list_types

# recognize # as comment
setopt interactive_comments

# enable complement after --prefeix=
setopt magic_equal_subst

# show error code if ret != 0
#setopt print_exit_value

# Functions
function pst() {
  psa | head -n 1
  psa | sort -r -k2n | grep -v "ps -auxww" | grep -v grep | head -n 8
}

function psm() {
  psa | head -n 1
  psa | sort -r -k3n | grep -v "ps -auxww" | grep -v grep | head -n 8
}

function psg() {
  psa | head -n 1
  psa | grep $* | grep -v "ps -auxww" | grep -v grep
}

# Load local configuration
[ -r ~/.zshrc.local ] && source ~/.zshrc.local

