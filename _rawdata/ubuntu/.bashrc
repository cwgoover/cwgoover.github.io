# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# add by tcao for color mark
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cdl="cd /local"
alias cdlp="cd /local/projects"
alias cdp="cd /data/projects"
alias ab="sudo /local/tools/sdk/platform-tools/adb"
alias ar='adb reboot'
alias adbl='/local/tools/android_studio/sdk/platform-tools/adb'
alias ars='adb shell stop;adb shell start'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

########################################
#### add tools
export PATH=/home/tcao/Integrity/IntegrityClient11/bin:$PATH:/local/bin
## add systrace
export PATH=$PATH:/local/tools/android_studio/sdk/platform-tools/systrace
#export PATH=$PATH:/local/tools/sdk/platform-tools

# this will make fastboot fail, cause it must use project building's fastboot
#export PATH=$PATH:/local/tools/android_studio/sdk/platform-tools:/local/tools/android_studio/sdk/tools

# add for scm tools
export PATH=$PATH:/local/tools/scm_tools/scm_tools/tools

# add for android studio
#export PATH=$PATH:/local/tools/android_studio/android-studio/bin

# add by tcao for jdk1.6
### CHANGE JAVA VERSION, please comment the next below line
#export PATH=/local/tools/jdk/jdk1.6.0_45/bin:$PATH
#export JAVA_HOME=/local/jdk/jdk1.6.0_45/

#export JRE_Home=$JAVA_HOME/jre
#export CLASSPATH=$CLASSPATH:$JAVA_HOME/lib:$JAVA_HOME/jre/lib

# add for parser apk
#export PATH=$PATH:/local/tools/AndroidToos/apktool/


######## Add for bash prompt ###########
#export PS1='${debian_chroot:+($debian_chroot)}\[\e[0;31m\]\u\[\e[m\][\[\033[1;34m\]\T \d\[\e[m\]]:\[\e[1;33m\]\w\[\e[m\]\$\[\e[m\] '
#export PS1='${debian_chroot:+($debian_chroot)}\[\e[1;31m\]\u\[\e[m\]\[\e[01m\][\[\033[1;33m\]\T \d\[\e[m\]\[\e[01m\]]:\[\e[1;36m\]\w\[\e[01m\]\$\[\e[m\] '
export PS1='${debian_chroot:+($debian_chroot)}\[\e[1;31m\]\u\[\e[m\]\[\e[01m\][\[\033[1;33m\]\T \d\[\e[m\]\[\e[01m\]]:\[\e[1;36m\]\w\[\e[01m\]\[\e[m\]\n\[\e[0;32m\]~\$ '


# add for building android with ccache
export USE_CCACHE=1


# add for installing Go programming language
export PATH=$PATH:/user/local/go/bin
export GOPATH=$HOME/go_work
