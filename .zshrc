
# Path to your oh-my-zsh installation.
export ZSH="/Users/gustavofe/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"


# === zsh Settings === }}}
 # completion
  autoload -U compinit
  compinit

 # Keep lots of history.
  export HISTFILE=~/.zsh_history
  export HISTSIZE=5000
  export SAVEHIST=5000

  setopt inc_append_history
  setopt hist_find_no_dups
  setopt hist_ignore_all_dups
  # Share history between terminals.
  setopt share_history
  # Don't record an entry starting with a space.
  setopt hist_ignore_space

  # Treat the ‚Äò#‚Äô, ‚Äò~‚Äô and ‚Äò^‚Äô characters as part of patterns for filename generation.
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error.
  unsetopt nomatch

  # Enable colored output from `ls`.
  export CLICOLOR=1

# }}}
#
# === Helper Functions === {{{

  # Create a new named tmux session.
  # Without arguments, the session name is the basename of the current directory.
  tnew() { tmux new-session -s ${1:-$(basename $(pwd))} }

# }}}

# === Environment Variables === {{{

  # Homebrew
  export PATH=/usr/local/bin:$PATH

  # Ripgrep
  export RIPGREP_ARGS="--no-ignore-vcs --hidden --follow --smart-case --ignore-file-case-insensitive --ignore-file $HOME/.rgignore"

  # Use Neovim as the default editor.
  export BU_EDITOR="nvim"
  export VISUAL=$BU_EDITOR
  export EDITOR=$BU_EDITOR

   # Ruby via Rbenv
  eval "$(rbenv init -)"

# }}}

# === Aliases === {{{
alias c='clear'
alias ll='ls -alh'

alias alego='cd ~/Projects/alego'
alias ws='cd ~/Projects/workspace'
alias hub3='cd ~/Projects/workspace/hub3'

# Ripgrep
alias rg="rg $RIPGREP_ARGS"

# }}}



export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm `bash_completion

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
