ZSH_THEME=""

# === Path variables === {{{

MY_NOTES_PATH=/Users/gustavofe/Notes

# }}}

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

# === Prompt === {{{

export PURE_GIT_PULL=0
fpath+=$HOME/.zsh/pure
autoload -U promptinit && promptinit

# show the branch name with green color.
zstyle :prompt:pure:git:branch color green

# turn on git stash status
zstyle :prompt:pure:git:stash show yes

prompt pure

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

  # Get a notification when some command complete.
  notify() {
    osascript -e 'display notification "Your command completed!"'
  }

  # My notes
  function gg() {
    dir=$(ls -d ~/Notes/**/*/ | fzf)
    date=$(date +%m-%d-%Y)
    printf 'Enter Note Title: '
    read -r note_title
    note_filename=${note_title// /_} # Replace spaces with dashes
    note_filename=$(echo $note_filename | tr '[:upper:]' '[:lower:]') # Convert to lower case
    note_filepath="$dir$note_filename.md"
    touch $note_filepath
    echo $note_title >> $note_filepath
    echo "=" >> $note_filepath
    echo "Created note: $note_filepath"
    nvim $note_filepath
  }

# }}}

# === Environment Variables === {{{
# Put it in .gugudevenv
source ~/.gugudevenv

# Rbenv
export PATH="$HOME/.rbenv/bin:$PATH"

# Openssl 1.0 - to install old ruby versions
export PATH="/usr/local/opt/openssl@1.0/bin:$PATH"

#For compilers to find openssl@1.0 you may need to set:
# export LDFLAGS="-L/usr/local/opt/openssl@1.0/lib"
# export CPPFLAGS="-I/usr/local/opt/openssl@1.0/include"

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

# Allow latest macOS versions to run multithreading.
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# Increase memory usage for Node
export NODE_OPTIONS=--max_old_space_size=4096

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

alias on='nvim $(find /Users/nate/Notes | grep md | fzf)'

# Homebrew for x86 - must run under Rosetta
alias ibrew='arch -x86_64 /usr/local/bin/brew'

## Projects
alias workspace='cd ~/Projects'

alias gh='cd ~/Projects/github'
alias labs='cd ~/Projects/labs'
alias backstage='cd ~/Projects/backstage'
alias sharegrid='cd ~/Projects/backstage/sharegrid'

## Toptal
alias toptal='cd ~/Projects/toptal'

## Open new note
alias on='nvim $(find /Users/gustavofe/Notes | grep md | fzf)'

## Localhost rubocop
alias lltrb='rubocop --format=simple --auto-correct'

# }}}

# === Functions === {{{

# Backstage
#------------------------------------------------------------------------------
## projects

### Sharegrid
runshare() {
  cd ~/Projects/backstage/sharegrid &&
    tmux split-window -h -p 30 \; \
      send-keys -t 1 'elasticsearch' Enter \; \
      split-window -v -p 90 \; \
      send-keys -t 2 'docker-compose -f ./docker/docker-compose-dev.yml up' Enter \; \
      split-window -v -p 90 \; \
      send-keys -t 3 'bundle exec sidekiq -C ./config/sidekiq_queues.yml -e development' Enter \; \
      split-window -v -p 90 \; \
      send-keys -t 4 'nvm use v16.5.0; yarn dev' Enter \; \
      split-window -v -p 50 \; \
      send-keys -t 5 'REACT_DEVTOOLS=1 bundle exec rails s -p 3000' Enter \; \
      select-pane -t 0 \; \
      split-window -v -p 40 \; \
      split-window -v -p 50 \; \
      send-keys -t 2 'rails c' Enter \; \
      split-window -v -p 50 \; \
      select-pane -t 0 \; \
      send-keys -t 0 'nvim .' Enter \;
}

source /Users/gustavofe/Projects/backstage/sharegrid/.env.development

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
  cd $MY_NOTES_PATH && nvim .
}

#}}}

# === Vendor === {{{

# Init rbenv
eval "$(rbenv init -)"

# Fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# }}}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

