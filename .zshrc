# If you come from bash you might have to change your $PATH.
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH:${HOME}/.local/bin/

# Path to your oh-my-zsh installation.
export ZSH=/home/jbond/.oh-my-zsh
# fuck knows wht ssh agent is fucking up
export SSH_AGENT_PID=$(/usr/bin/pidof -x /usr/bin/startkde)
export SSH_AUTH_SOCK=$(ls /tmp/ssh-*/agent.${SSH_AGENT_PID})

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="gallois"
#ZSH_THEME="mh"
#ZSH_THEME="wedisagree"
ZSH_THEME="nanotech"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git catimg encode64 gem jsontools pass python rvm debian pip python sudo vagrant rbenv ssh-agent docker)
hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts <$HOME/.ssh/known_hosts.d/wmf-prod <$HOME/.ssh/known_hosts.d/wmf-cloud)"}:#[0-9]*}%%\ *}%%,*})
zstyle ':completion:*:hosts' hosts $hosts
zstyle :omz:plugins:ssh-agent agent-forwarding on
zstyle :omz:plugins:ssh-agent identities id_rsa id_ed25519_production

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"
# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias oneline="awk '{printf "'"'"%s "'"'",\$1}'"
alias spwgen='pwgen -sy 20 1'
alias pp='git pull -r'
alias s='git submodule sync && git submodule update'
alias bspec='bundle exec rake spec'
alias blint='bundle exec rake validate lint'
alias brubo='bundle exec rake rubocop'
alias bbeaker='BEAKER_set="docker/ubuntu-14.04" bundle exec rake beaker'
alias bstrings='bundler exec puppet strings generate --format markdown'
alias binstall='bundle install --path=${BUNDLE_PATH:-vendor/bundle}'
alias add-ssh='ssh-add ~/.ssh/id_ed25519_production ~/.ssh/id_rsa; SSH_AUTH_SOCK=/run/user/1000/ssh-cloud.socket ssh-add ~/.ssh/id_ed25519'

alias colourify="/usr/bin/grc -es --colour=auto"
alias configure='colourify ./configure'
alias diff='colourify diff'
alias make='colourify make'
alias gcc='colourify gcc'
alias g++='colourify g++'
alias as='colourify as'
alias gas='colourify gas'
alias ld='colourify ld'
alias netstat='colourify netstat'
alias ping='colourify ping'
alias traceroute='colourify /usr/sbin/traceroute'
alias head='colourify head'
alias tail='colourify tail'
alias dig='colourify dig'
alias mount='colourify mount'
alias ps='colourify ps'
alias mtr='colourify mtr'
alias df='colourify df'
#alias docker='sudo docker'

export PAGER=less
export EDITOR=vim
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ANSIBLE_NOCOWS=1
export ANSIBLE_SSH_PIPLINEING=1


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function c {
  date
  git commit -m"$*" -a
}
function p {
  BRANCH=$(git status | awk '{print $NF; exit}')
  if [[ "${BRANCH}" = 'production' ]] || [[ "${BRANCH}" = 'staging' ]]
  then
    echo '##############################'
    echo " NOT PUSHING branch=${BRANCH} "
    echo '##############################'
  else
    date
    git push origin "${BRANCH}" $*
  fi
}
function rdns {
  ip=${1}
  host=$2
  question=$(dig +noall +question -x ${ip} | tr -d ';' | awk '{print $1}')
  authority=$(dig +noall +authority -x ${ip} | awk '{print $1}')
  printf '%s\tIN\tPTR\t%s\n' ${question%"${authority}"} $host
}
function docker-debian {
  docker run -it debian:${1} /bin/bash 
}
function docker-killall {
  for i in $(docker ps --all | tail +2 | awk '{print $1}')
  do
    docker stop ${i} || docker kill ${i}
    docker rm ${i}
  done
}
function docker-bash {
  # Fuck knows how this works, zsh voodoo
  OPTIONS=("${(f)$(docker ps | tail +2)}")
  if [ -z ${1+x} ]
  then
    if [ -z ${OPTIONS} ]
    then
      echo "No containers running"
      return
    elif [ ${#OPTIONS[@]} -eq 1 ]
    then
      local CONTAINER=${${(z)OPTIONS[1]}[1]}
    else
      COUNT=1
      for line in ${OPTIONS}
      do 
        echo "[${COUNT}]:  ${line}"
        COUNT=$((COUNT+1))
      done
      echo "Please select container to connect too [1-${#OPTIONS[@]}]"
      read ans
      if [ ${ans} -gt ${#OPTIONS[@]} ]
      then
        echo "Invalid selection"
        return
      else
        local CONTAINER=${${(z)OPTIONS[${ans}]}[1]}
      fi
    fi
  else
    local CONTAINER=${1}
  fi
  docker exec -i -t ${CONTAINER} /bin/bash
}



fpath=(/usr/local/share/zsh-completions $fpath)
[[ -s '/etc/zsh_command_not_found' ]] && source '/etc/zsh_command_not_found'

# added by travis gem
[ -f /home/jbond/.travis/travis.sh ] && source /home/jbond/.travis/travis.sh
