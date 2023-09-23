export XDG_CONFIG_HOME=$HOME/.config

export EDITOR="nvim"
export VISUAL="nvim"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export HISTFILE="$ZDOTDIR/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export TMUXP_CONFIGDIR=$XDG_CONFIG_HOME/tmuxp
export DISABLE_AUTO_TITLE='true'

export PYENV_ROOT=$HOME/.pyenv
