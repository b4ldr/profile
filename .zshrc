# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH:${HOME}/.local/bin/:${HOME}/.local/share/gem/ruby/3.1.0/bin/:/usr/local/go/bin
HISTSIZE='128000'
SAVEHIST='128000'
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY

ZLS_COLORS=''
ZLS_COLOURS=''
# Keep history of `cd` as in with `pushd` and make `cd -<TAB>` work.
DIRSTACKSIZE=16
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushd_minus
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt auto_cd


systemctl start --user ssh-agent@prod
systemctl start --user ssh-agent@cloud
zmodload zsh/complist
zmodload zsh/complete
zmodload zsh/net/tcp
autoload -Uz compinit
autoload -U up-line-or-search
autoload -U down-line-or-search
compinit
bindkey -e
bindkey "^R" history-incremental-pattern-search-backward
bindkey "${terminfo[kcud1]}" down-line-or-search
bindkey "${terminfo[kcuu1]}" up-line-or-search

zstyle ':completion:*' menu select
zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:hosts' known-hosts-files /home/jbond/.ssh/known_hosts /home/jbond/.ssh/known_hosts.d/wmf-cloud /home/jbond/.ssh/known_hosts.d/wmf-prod
# zstyle :omz:plugins:ssh-agent agent-forwarding on
#zstyle :omz:plugins:ssh-agent identities id_rsa id_ed25519_production

alias debcompare="${HOME}/git/debcompare/venv/bin/python -m debcompare.compare"
alias puppet-merge='ssh -t puppetmaster1001.eqiad.wmnet sudo -i puppet-merge'
alias pc='pass -c'
alias oneline="awk '{printf "'"'"%s "'"'",\$1}'"
alias spwgen='pwgen -sy 20 1'
alias pp='git pull -r'
alias s='git submodule sync && git submodule update'
alias bspec='RUBYOPT=-W0 bundle exec rake spec'
alias blint='RUBYOPT=-W0 bundle exec rake validate lint'
alias brubo='RUBYOPT=-W0 bundle exec rake rubocop'
alias bbeaker='RUBYOPT=-W0 BEAKER_set="docker/ubuntu-14.04" bundle exec rake beaker'
alias bstrings='RUBYOPT=-W0 bundler exec puppet strings generate --format markdown'
alias binstall='bundle config set --local path .bundle/vendor && bundle install'
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
alias mtr='colourify mtr --aslookup -t'
alias df='colourify df'
#alias docker='sudo docker'
alias sre-pad='echo https://etherpad.wikimedia.org/p/SRE-Foundations-$(date -I -dMonday)'
alias clipboard='xclip -selection c'
alias gpg-market='gpg  --no-default-keyring --keyring  darknet/trustedkeys.gpg'
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
alias cumin="ssh cumin1001.eqiad.wmnet sudo cumin"
alias ip="ip -c"
alias ca='git commit --amend --no-edit'
alias kubectl="minikube kubectl --"



[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

function sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER#$EDITOR }"
        LBUFFER="sudoedit $LBUFFER"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER#sudoedit }"
        LBUFFER="$EDITOR $LBUFFER"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

function s_client {
  openssl s_client -connect ${1:-localhost:443}  < /dev/null |& openssl x509 -noout -text
}

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
  docker run --rm -it debian:${1} /bin/bash
}
function docker-wmf {
  docker run --rm -it --user root --entrypoint bash "docker-registry.wikimedia.org/${1}:${2:-latest}"
}
function docker-releng {
  docker run --rm -it --user root --entrypoint bash "docker-registry.wikimedia.org/releng/${1}:${2:-latest}"
}
function docker-killall {
  for i in $(docker ps --all | tail +2 | grep $1 | awk '{print $1}')
  do
    docker stop ${i} || docker kill ${i}
    docker rm ${i}
  done
}
function pcc {
  cd ${HOME}/git/puppet
  ./utils/pcc.py last parse_commit
  cd -
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

function copy-profile {
  pushd /home/jbond/git/puppet
  scp -r modules/admin/files/home/jbond/.gitconfig modules/admin/files/home/jbond/.vim modules/admin/files/home/jbond/.vimrc modules/admin/files/home/jbond/.zshenv modules/admin/files/home/jbond/.zshrc ${1}:.
  popd
}

function rsed {
  find . \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -E -i $1
}

fpath=(/usr/local/share/zsh-completions $fpath)
[[ -s '/etc/zsh_command_not_found' ]] && source '/etc/zsh_command_not_found'

# added by travis gem
[ -f /home/jbond/.travis/travis.sh ] && source /home/jbond/.travis/travis.sh
 fpath=(~/.zsh/completion $fpath)
#eval "$(rbenv init -)"
source ~/git/powerlevel10k/powerlevel10k.zsh-theme
#source ~/.config/b4ldr.zsh-theme
source <(rtx activate zsh)
source <(dcl completion zsh)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/p10k.zsh ]] || source ~/.zsh/p10k.zsh
eval "$(/usr/local/bin/brew shellenv)"
