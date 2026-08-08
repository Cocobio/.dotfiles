HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000  # Save most-recent 1000 lines
# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
# _comp_options+=(globdots)     # Include hidden files.

# tab complete keybindings
# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


# vi mode
bindkey -v
export KEYTIMEOUT=1
export EDITOR=nvim

# FZF configs in TERMUX
# # Auto-completion
[[ $- == *i* ]] && source "$PREFIX/share/fzf/completion.zsh" 2> /dev/null
# Key bindings
# Ubuntu's keybindings
if [ -e "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
  source "/usr/share/doc/fzf/examples/key-bindings.zsh"
elif [ -e "$PREFIX/share/fzf/key-bindings.zsh" ]; then
  source "$PREFIX/share/fzf/key-bindings.zsh"
else
  . /usr/share/fzf/shell/key-bindings.zsh
fi

# For termux only
if [ -n "${TERMUX_VERSION}" ]; then
    export HOST="tab9u"
fi

source ~/.dotfiles/zsh/zsh.export
source ~/.dotfiles/zsh/zsh.alias
source ~/.dotfiles/zsh/zsh.prompt
source ~/.dotfiles/zsh/zsh.utils

# Config for zsh-completions
fpath=("/data/data/com.termux/files/home/.zsh/plugins/zsh-completions" $fpath)

source ~/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="$PATH:/snap/bin"
export PATH=$PATH:$HOME"/.cargo/bin"
export PATH=$PATH:$HOME"/.local/bin"
export THEME=tokyonight-storm

# Check crond, run if its not running
if [ -z $(pgrep cron) ];
then
    crond
fi
