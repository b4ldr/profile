# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH:${HOME}/.local/bin/:/usr/local/go/bin:${HOME}/Library/Python/3.12/bin:${HOME}/.gem/ruby/2.7.0/bin:/usr/local/opt/binutils/bin:/opt/puppetlabs/pdk/bin
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
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

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
# zstyle :omz:plugins:ssh-agent agent-forwarding on
#zstyle :omz:plugins:ssh-agent identities id_rsa id_ed25519_production

alias pinentry='pinentry-mac'
alias debcompare="${HOME}/git/debcompare/venv/bin/python -m debcompare.compare"
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

alias clipboard='xclip -selection c'
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
function check_production {
  BRANCH=$(git status | awk '{print $NF; exit}')
  if [[ "${BRANCH}" = 'production' ]] || [[ "${BRANCH}" = 'staging' ]]
  then
    echo '##############################'
    echo " NOT PUSHING branch=${BRANCH} "
    echo '##############################'
    return false
  else
    return true
  fi
}
function p {
    check_production && date && git push origin "${BRANCH}" $*
}
function fp {
    check_production && date && git fpush origin "${BRANCH}" $*
}
function rdns {
  ip=${1}
  host=$2
  question=$(dig +noall +question -x ${ip} | tr -d ';' | awk '{print $1}')
  authority=$(dig +noall +authority -x ${ip} | awk '{print $1}')
  printf '%s\tIN\tPTR\t%s\n' ${question%"${authority}"} $host
}
function docker-ubuntu {
  docker run --rm -it ubuntu:${1} /bin/bash
}
function docker-debian {
  docker run --rm -it debian:${1} /bin/bash
}
function docker-killall {
  for i in $(docker ps --all | tail +2 | awk '{print $1}')
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

function rsed {
  find . \( -type d -name .git -prune \) -o -type f -print0 | xargs -0 sed -E -i $1
}

function doc-find {
  find /Users/john.bond/git/documents -iname \*${1}\*
}

function ansible-role {
  ansible -b --module-name include_role --args name="${1}" "${2}" $3
}

fpath=(/usr/local/share/zsh-completions $fpath)
[[ -s '/etc/zsh_command_not_found' ]] && source '/etc/zsh_command_not_found'

fpath=(~/.zsh/completion $fpath)
#eval "$(rbenv init -)"
source ~/git/powerlevel10k/powerlevel10k.zsh-theme
#source ~/.config/b4ldr.zsh-theme
#source <(mise activate zsh)
#source <(dcl completion zsh)
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.zsh/p10k.zsh ]] || source ~/.zsh/p10k.zsh
# the source eblow seems to have no effect not sure why, something something mac
# source "$(brew --prefix)/etc/grc.zsh"
# for cmd in g++ gas head make ld ping6 tail traceroute6 $( ls /usr/share/grc/ ); do
#   cmd="${cmd##*conf.}"
#   type "${cmd}" >/dev/null 2>&1 && echo alias "${cmd}"="$( which grc ) --colour=auto ${cmd}"
# done
alias g++="/usr/local/bin/grc --colour=auto g++"
alias head="/usr/local/bin/grc --colour=auto head"
alias make="/usr/local/bin/grc --colour=auto make"
alias ld="/usr/local/bin/grc --colour=auto ld"
alias ping6="/usr/local/bin/grc --colour=auto ping6"
alias tail="/usr/local/bin/grc --colour=auto tail"
alias traceroute6="/usr/local/bin/grc --colour=auto traceroute6"
alias curl="/usr/local/bin/grc --colour=auto curl"
alias df="/usr/local/bin/grc --colour=auto df"
alias diff="/usr/local/bin/grc --colour=auto diff"
alias dig="/usr/local/bin/grc --colour=auto dig"
alias du="/usr/local/bin/grc --colour=auto du"
alias env="/usr/local/bin/grc --colour=auto env"
alias fdisk="/usr/local/bin/grc --colour=auto fdisk"
alias gcc="/usr/local/bin/grc --colour=auto gcc"
alias id="/usr/local/bin/grc --colour=auto id"
alias ifconfig="/usr/local/bin/grc --colour=auto ifconfig"
alias ip="/usr/local/bin/grc --colour=auto ip"
alias jobs="/usr/local/bin/grc --colour=auto jobs"
alias kubectl="/usr/local/bin/grc --colour=auto kubectl"
alias last="/usr/local/bin/grc --colour=auto last"
alias log="/usr/local/bin/grc --colour=auto log"
alias ls="/usr/local/bin/grc --colour=auto ls"
alias lsof="/usr/local/bin/grc --colour=auto lsof"
alias mount="/usr/local/bin/grc --colour=auto mount"
alias netstat="/usr/local/bin/grc --colour=auto netstat"
alias ping="/usr/local/bin/grc --colour=auto ping"
alias ps="/usr/local/bin/grc --colour=auto ps"
alias showmount="/usr/local/bin/grc --colour=auto showmount"
alias stat="/usr/local/bin/grc --colour=auto stat"
alias sysctl="/usr/local/bin/grc --colour=auto sysctl"
alias tcpdump="/usr/local/bin/grc --colour=auto tcpdump"
alias traceroute="/usr/local/bin/grc --colour=auto traceroute"
alias ulimit="/usr/local/bin/grc --colour=auto ulimit"
alias uptime="/usr/local/bin/grc --colour=auto uptime"
alias whois="/usr/local/bin/grc --colour=auto whois"
alias ssh=/usr/local/bin/ssh
eval "$(mise activate zsh)"

# Amazon Q post block. Keep at the bottom of this file.
# [[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
