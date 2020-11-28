# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/snap/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/root/.oh-my-zsh"
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias ll="ls -laihG"

source <(antibody init)

antibody bundle romkatv/powerlevel10k

ZSH_THEME="powerlevel10k"

LS_COLORS=$LS_COLORS:'di=0;33:' ; export LS_COLORS

export EDITOR=vim

if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
