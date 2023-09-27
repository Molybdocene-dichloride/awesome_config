#
# /etc/bash.bashrc
#

export psert=""

if [ -n "$TERMUX_APK_RELEASE" ]; then
   export psert=/data/data/com.termux/files
fi

if ! [ -n "$TERMUX_APK_RELEASE" ]; then #To Do
   export IPFS_PATH=/var/.ipfs

   export TEXMFROOT=/opt/texlive
   
   export TeXLivePATH=$TEXMFROOT

   export PATH=$PATH:$TeXLivePATH/bin/x86_64-linux

   export MANPATH=$MANPATH:$TeXMFDISTPATH/doc/man

   export INFOPATH=$INFOPATH:$TeXMFDISTPATH/doc/info
else
   export TeXLivePATH=$TEXMFROOT
   export pseudoroot=~/..
fi

export TeXMFDISTPATH=$TeXLivePATH/texmf-dist

export AsyPATH=$TeXMFDISTPATH/asymptote

export sfipfdir=$pseudoroot/opt/kubo
export PATH=$PATH:$sfipfdir

#export PATH=:$PATH:~/.luarocks/bin
#export LUA_PATH='/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;~/.luarocks/share/lua/5.4/?.lua;~/.luarocks/share/lua/5.4/?/init.lua'
#export LUA_CPATH='/usr/lib/lua/5.4/?.so;/usr/lib/lua/5.4/loadall.so;./?.so;~/.luarocks/lib/lua/5.4/?.so'


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

shopt -s histappend
shopt -s histverify
export HISTCONTROL=ignoreboth

[[ $DISPLAY ]] && shopt -s checkwinsize

# Default command line prompt.
#PROMPT_DIRTRIM=2
#PS1='\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '

# Handles nonexistent commands.
# If user has entered command which invokes non-available
# utility, command-not-found will give a package suggestions.
#if [ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]; then
#        command_not_found_handle() {
#                /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
#        }
#fi

PS1='[\u@\h \W]\$ '

case ${TERM} in
  Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|tmux*|xterm*)
    PROMPT_COMMAND+=('printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')

    ;;
  screen*)
    PROMPT_COMMAND+=('printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"')
    ;;
esac

if [[ -r $psert/usr/share/bash-completion/bash_completion ]]; then
  . $psert/usr/share/bash-completion/bash_completion
fi
