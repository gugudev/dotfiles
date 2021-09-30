require 'fileutils'

DOTFILES_DIR = File.dirname(__FILE__)

def log(msg)
  puts "\n===> #{msg}"
end

# https://github.com/sindresorhus/pure#manually
task :install_pure_prompt do
  log "Installing Pure prompt..."

  zsh_path = File.join(Dir.home, '.zsh')
  FileUtils.mkdir(zsh_path) unless File.directory?(zsh_path)

  pure_path = File.join(zsh_path, 'pure')
  `git clone https://github.com/sindresorhus/pure.git "#{pure_path}"`
end

task :install_config_files => [:install_pure_prompt] do
  local_home_path = "#{DOTFILES_DIR}/home"

  config_paths = Dir.glob("#{local_home_path}/**/*", File::FNM_DOTMATCH)

  config_paths.sort! # directories first

  config_paths.each do |path|
    next if (/^(.|.DS_Store)$/ =~ File.basename(path)) == 0

    dest_path = path.sub(local_home_path, Dir.home)

    if File.directory?(path)
      FileUtils.mkdir_p(dest_path)
    else
      FileUtils.ln_s(path, dest_path, force: true)
    end
  end

  log "To apply the new .zshrc settings, execute `source ~/.zshrc`."
end

task :define_term_capabilities do
  `/bin/sh #{DOTFILES_DIR}/scripts/fix_term.sh`
  log "~/.terminfo/ created! Restart tmux and/or your shell."
end

desc 'Install all config files to $HOME and install Vim plugins forcefully.'
task :install => [:install_config_files]

desc 'Install all config files to $HOME and only update outdated Vim plugins.'
task :update => [:install_config_files]

task :default do
  puts 'Run rake -T for options.'
end
