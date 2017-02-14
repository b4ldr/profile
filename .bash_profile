PS1_NO_COLOR="\[\033[0m\]"
PS1_BLACK="\[\033[0;30m\]"
PS1_RED="\[\033[0;31m\]"
PS1_LIGHT_RED="\[\033[1;31m\]"
PS1_GREEN="\[\033[0;32m\]"
PS1_LIGHT_GREEN="\[\033[1;32m\]"
PS1_BROWN="\[\033[0;33m\]"
PS1_LIGHT_BROWN="\[\033[1;33m\]"
PS1_BLUE="\[\033[0;34m\]"
PS1_LIGHT_BLUE="\[\033[1;34m\]"
PS1_PURPLE="\[\033[0;35m\]"
PS1_LIGHT_PURPLE="\[\033[1;35m\]"
PS1_CYAN="\[\033[0;36m\]"
PS1_LIGHT_CYAN="\[\033[1;36m\]"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
  . $(brew --prefix)/etc/bash_completion
fi

if [ -f $(brew --prefix)/etc/grc.bashrc ]; then 
  . $(brew --prefix)/etc/grc.bashrc
fi

umask 002 
shopt -s histappend
export PROMPT_COMMAND='printf "\033]0;%s:%s\007" ${HOSTNAME%%.*} "${PWD/$HOME/~}"'
export HISTCONTROL="&:ls:[bf]g:exit"
alias unixt='date -ur'
alias svn="date; svn"
alias oneline="awk '{printf "'"'"%s "'"'",\$1}'"
alias spwgen='pwgen -sy 20 1'
alias pp='git pull -r'
alias s='git submodule sync && git submodule update'
alias bspec='bundle exec rake spec'
alias blint='bundle exec rake validate lint'
alias brubo='bundle exec rake rubocop'
alias bbeaker='BEAKER_set="docker/ubuntu-14.04" bundle exec rake beaker'
function c {
  date
  git commit -m"$*" -a
}
function p {
  BRANCH=$(git status | awk '{print $NF; exit}')
  if [ "${BRANCH}" == 'production' -o "${BRANCH}" == 'staging' ]
  then
    echo '##############################'
    echo " NOT PUSHING branch=${BRANCH} "
    echo '##############################'
  else 
    date
    git push origin "${BRANCH}" $*
  fi
}
function git_branch {
  local git_branch=$(git status 2> /dev/null | awk '{print $NF; exit}')
  if [ -n "${git_branch}" ]
  then
    printf " (%s)" ${git_branch}
  fi 
}

export -f git_branch
export PS1="\[\e]0;(\j)[\!] \w\a\]${PS1_BROWN}(\j)${PS1_CYAN}[\!]${PS1_PURPLE}\w${PS1_LIGHT_PURPLE}\$(git_branch)${PS1_NO_COLOR} \$ "
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export ANSIBLE_NOCOWS=1
export ANSIBLE_SSH_PIPLINEING=1
export GOPATH=~/go
export PATH=$PATH:/usr/local/opt/go/libexec/bin:/usr/local/sbin::/usr/local/bin:$GOPATH/bin:/usr/local/mysql/bin
export PAGER=less
export EDITOR=vim

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

test -e ${HOME}/.iterm2_shell_integration.bash && source ${HOME}/.iterm2_shell_integration.bash
#eval $(docker-machine env)
