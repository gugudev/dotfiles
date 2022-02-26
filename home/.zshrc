# === Zsh Settings === {{{
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

  # Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation.
  setopt EXTENDED_GLOB

  # If a pattern for filename generation has no matches, print an error.
  unsetopt nomatch

  # Enable colored output from `ls`.
  export CLICOLOR=1

  # Automatically cd into directories.
  setopt autocd

  # no beeping
  unsetopt beep

  # Enable colored output from `ls`.
  export CLICOLOR=1
# }}}

# === Helper Functions === {{{

  # Create a new named tmux session.
  # Without arguments, the session name is the basename of the current directory.
  tnew() { tmux new-session -s ${1:-$(basename $(pwd))} }

  ebash() { nvim ~/.zshrc }
  evim() { cd ~/.config/nvim && nvim . }
  etmux() { nvim ~/.tmux.conf }

  rbash() { source ~/.zshrc }
  sbash() { source ~/.zshrc }

  # Remove all emails from rails projects
  rletter() { rm -rf tmp/letter_opened }

  rmigrate() { ddo rake db:migrate }

  # Listing all branches and opens a prompt to pick one.
  function cof() {
    local branches branch
    branches=$(git branch) &&
    branch=$(echo "$branches" | fzf-tmux -d 15 +m) &&
    git checkout $(echo "$branch" | sed "s/.* //")
  }

  # Opens the last HTML screenshot from capybara in rails projects.
  function oph() {
    local fullCommand
    fullCommand=$(ls -t tmp/capybara | head -1 | sed -e 's/\.[^.]*$//')
    $(echo "open tmp/capybara/$fullCommand.html")
  }

  # Opens the last PNG screenshot from capybara in rails projects.
  function opi() {
    local fullCommand
    fullCommand=$(ls -t tmp/capybara | head -1 | sed -e 's/\.[^.]*$//')
    $(echo "open tmp/capybara/$fullCommand.png")
  }

  # Opens emails in HTML from letter opener in rails projects.
  function opeh() {
    local fullCommand
    fullCommand=$(ls -t tmp/letter_opener | head -1)
    $(echo "open tmp/letter_opener/$fullCommand/rich.html")
  }

  # Opens emails in TEXT from letter opener in rails projects.
  function opet() {
    local fullCommand
    fullCommand=$(ls -t tmp/letter_opener | head -1)
    $(echo "open tmp/letter_opener/$fullCommand/plain.html")
  }

  # E.g getRequest localhost:3006/api/v1/listings/search
  function getRequest() {
    curl -i -H "Accept: application/json" $1
  }
  # E.g postRequest localhost:3006/webhooks/twilio-incoming-sms-message '{"messageBody": "Hi"}'
  function postRequest() {
    curl \
      -i \
      -H "Accept: application/json" \
      -H "Content-type: application/json" \
      -X POST \
      --data $2 \
      $1
  }
# }}}

# === Environment Variables === {{{
# #Put it in .gugudevenv
  export PATH="$HOME/.rbenv/bin:$PATH"

  # Ripgrep
  export RIPGREP_ARGS="--no-ignore-vcs --hidden --follow --smart-case --ignore-file-case-insensitive --ignore-file $HOME/.rgignore"

  # Use Neovim as the default editor.
  export VISUAL="nvim"
  export EDITOR="nvim"

  # In ClickUp: Settings > Apps
  export CLICKUP_API_TOKEN=

  # https://id.getharvest.com/developers
  export HARVEST_ACCOUNT_ID=
  export HARVEST_ACCESS_TOKEN=
  export GITHUB_API_TOKEN=

  # Alego DB credentials
  export PG_USER=
  export PG_PASS=
# }}}

# === Aliases === {{{
alias c='clear'
alias ll='ls -alh'

# Companies
alias ws='cd ~/Projects/workspace'
alias alego='cd ~/Projects/alego'
alias hub3='cd ~/Projects/hub3'

# Ripgrep
alias rg="rg $RIPGREP_ARGS"

# Mydotfiles
alias dot='cd ~/dotfiles'
# }}}

# === Functions === {{{

# Hub3
#------------------------------------------------------------------------------
## docker commands
ddo() {
  docker-compose run --rm --use-aliases web $*
}

gtplm() {
  git pull origin master
}

ltrb() {
  ddo bin/lint rb --fix
}

ltjs() {
  bin/lint js --fix
}

ltcss() {
  bin/lint css --fix
}

ltts() {
  docker-compose run --rm --no-deps ci yarn run type-check
}

ltall() {
  ltrb && ltjs && ltcss
}

## projects
h3() {
  (cd ~/Projects/hub3/scripts/h3_cli && bundle exec ruby main.rb $*)
}

### Spoteasy
h3sp() {
  cd ~/Projects/hub3/spot_easy_website &&
    tmux split-window -h -p 30 \; \
      send-keys -t 1 'bin/docker_web_server' Enter \; \
      split-window -v -p 60 \; \
      send-keys -t 2 'bin/nextjs_dev_server' Enter \; \
      split-window -v -p 60 \; \
      send-keys -t 3 'bin/docker_sync' Enter \; \
      select-pane -t 0 \; \
      split-window -v -p 40 \; \
      send-keys -t 1 'ddo bash' Enter \; \
      split-window -v -p 50 \; \
      send-keys -t 2 'ddo rails c' Enter \; \
      split-window -v -p 50 \; \
      select-pane -t 0 \; \
      send-keys -t 0 'nvim .' Enter \;
}

### New wave
h3nw() {
  cd ~/Projects/hub3/new_wave_website &&
    tmux split-window -v -p 30 \; \
      split-window -h -p 50 \; \
      send-keys -t 2 'bin/docker_web_server' Enter \; \
      split-window -v -p 70 \; \
      send-keys -t 3 'bin/webpack_dev_server' Enter \; \
      split-window -v -p 50 \; \
      send-keys -t 4 'bin/docker_sync' Enter \; \
      select-pane -t 0;
}


# Docker
#------------------------------------------------------------------------------
removecontainers() {
    docker stop $(docker ps -aq)
    docker rm $(docker ps -aq)
}

armageddon() {
    removecontainers
    docker network prune -f
    docker rmi -f $(docker images --filter dangling=true -qa)
    docker volume rm $(docker volume ls --filter dangling=true -q)
    docker rmi -f $(docker images -qa)
}
# -----------------------------------------------------------------------------

mynotes() {
  cd ~/Documents/mynotes && nvim .
}

#}}}

# === Vendor === {{{

# Init rbenv
eval "$(rbenv init -)"

# Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}
