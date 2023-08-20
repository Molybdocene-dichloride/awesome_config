#
# /etc/bash.bashrc
#

export android_ndk=~/.android/android-ndk-r16b/

export TeXLivePATH=~/texlive

export TeXMFPATH=$TeXLivePATH/texmf-dist

export AsyPATH=$TeXMFPATH/asymptote

export PATH=$PATH:$TeXLivePATH/bin/x86_64-linux/:~/.luarocks/bin

export LUA_PATH='/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;~/.luarocks/share/lua/5.4/?.lua;~/.luarocks/share/lua/5.4/?/init.lua'
export LUA_CPATH='/usr/lib/lua/5.4/?.so;/usr/lib/lua/5.4/loadall.so;./?.so;~/.luarocks/lib/lua/5.4/?.so'

export MANPATH=$MANPATH:$TeXMFPATH/doc/man/

export INFOPATH=$INFOPATH:$TeXMFPATH/doc/info/

export TERMINAL="urxvt"

export EDITOR="emacs -nw"

export UIEDITOR="emacs"

export IMAGEEDITOR="gimp"

export DOCVIEWER="zathura"

export BROWSER="firefox"

export KEYMANAGER="keepassxc"

export proccessmanager="htop"

export FILEMANAGER="vifm"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ $DISPLAY ]] && shopt -s checkwinsize

PS1='[\u@\h \W]\$ '

case ${TERM} in
  Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
    PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')

    ;;
  screen*)
    PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
esac

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi
