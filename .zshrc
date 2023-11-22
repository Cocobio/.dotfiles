HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000  # Save most-recent 1000 lines

export EDITOR=nvim

# FZF configs in TERMUX
# # Auto-completion
[[ $- == *i* ]] && source "$PREFIX/share/fzf/completion.zsh" 2> /dev/null
# # Key bindings
source "$PREFIX/share/fzf/key-bindings.zsh"

source ~/.dotfiles/zsh/zsh.export
source ~/.dotfiles/zsh/zsh.alias
source ~/.dotfiles/zsh/zsh.prompt
source ~/.dotfiles/zsh/zsh.utils
