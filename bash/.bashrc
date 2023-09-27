#
# ~/.bashrc
#
if [ -f /etc/bash.bashr ]; then
    . /etc/bash.bashr
fi

. ~/software/dirs/dirs.sh

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
PATH=$PATH:~/.pipenv/bin:~/.julia/julia-1.9/bin
export PATH

export android_ndk=~/.android/android-ndk-r16b

export JULIA_LOAD_PATH=$JULIA_LOAD_PATH:$prmisdir:$prmisdir/machs:$prmisdir/general
export PYTHONPATH=$PYTHONPATH:~/software/tmp-open
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# [ -n "PS1" ] && [ -t 2 ] && clear
[ -n "PS1" ] && [ -t 2 ] && echo -n -e "\033[6 q"

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
