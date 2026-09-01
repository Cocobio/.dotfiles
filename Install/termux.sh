#!/usr/bin/env bash
# Termux setup: the terminal half of this system, as close as Android allows.
# Safe to re-run.
#
# Matches the CachyOS laptop where it makes sense -- same shell, same prompt,
# same aliases, same tmux, same fonts, same bat/fastfetch theming. Everything
# Wayland (hyprland, waybar, noctalia, hyprlock) obviously has no counterpart.
set -u

pkgi() { pkg install -y "$@"; }

# Symlink $HOME/$2 -> ~/.dotfiles/$1, moving any existing real file aside first.
# Same helper as cashyos.sh, and for the same reason: the old script wrote
# `ln -s .dotfiles/.tmux.conf .tmux.conf` with no guard, so a re-run failed once
# the link already existed.
link() {
    src="$HOME/.dotfiles/$1"; dst="$HOME/$2"
    [ -e "$src" ] || { echo "skip: $src not in the repo"; return 0; }
    if [ -L "$dst" ]; then rm -f "$dst"
    elif [ -e "$dst" ]; then mv -- "$dst" "$dst-old-$(date +%Y%m%d%H%M%S)"; fi
    mkdir -p -- "$(dirname -- "$dst")"
    ln -s -- "$src" "$dst"
    echo "linked $dst -> $src"
}

termux-change-repo
pkg update -y && pkg upgrade -y
[ -d "$HOME/storage" ] || termux-setup-storage

#-------------------------------------#
#            Packages
#-------------------------------------#
# `local packages=...` was invalid here -- local outside a function -- and
# "ffmepg" was misspelled, so ffmpeg was never actually installed.
pkgi git openssh wget curl man tree unrar libqrencode
pkgi zsh tmux fzf bat eza yazi lf ripgrep fd jq
pkgi neovim nodejs
pkgi htop ninja llvm rust rust-analyzer
pkgi termux-api megacmd cronie libusb ffmpeg pandoc tectonic
pkgi fastfetch                 # zshrc prints it on a new interactive terminal
pkgi asciinema agg

#-------------------------------------#
#         Clone or update dotfiles
#-------------------------------------#
cd "$HOME" || exit 1
if [ ! -d .dotfiles ]; then
    git clone https://github.com/Cocobio/.dotfiles
else
    git -C .dotfiles pull --ff-only origin || echo "warn: dotfiles pull failed, continuing"
fi

#-------------------------------------#
#         Fonts + agg
#-------------------------------------#
# CaskaydiaCove Nerd Font Mono: the terminal font, and the one the agg alias
# asks for. v3 matters -- the tmux and kitty configs use Material Design glyphs
# at U+F0000+, which only exist in Nerd Fonts v3.
mkdir -p "$HOME/.local/share/fonts"
if [ ! -f "$HOME/.local/share/fonts/CaskaydiaCoveNerdFontMono-Regular.ttf" ]; then
    (
        cd "$HOME/.local/share/fonts" || exit 1
        wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaCode.zip
        unzip -o CascadiaCode.zip >/dev/null
        rm -f CascadiaCode.zip LICENSE readme.md
    )
fi
mkdir -p "$HOME/.termux"
ln -sf "$HOME/.local/share/fonts/CaskaydiaCoveNerdFontMono-Regular.ttf" "$HOME/.termux/font.ttf"
ln -sf "$HOME/.dotfiles/Install/termux.colors.properties" "$HOME/.termux/colors.properties"

# zsh.alias asks for --font-dir ~/.config/agg/fonts and deliberately knows
# nothing about where fonts really live; this link is what resolves it. On the
# laptop the same link points at /usr/share/fonts/TTF.
mkdir -p "$HOME/.config/agg"
ln -sfn "$HOME/.local/share/fonts" "$HOME/.config/agg/fonts"

#-------------------------------------#
#              bat theme
#-------------------------------------#
mkdir -p "$(bat --config-dir)/themes"
[ -f "$(bat --config-dir)/themes/Catppuccin Mocha.tmTheme" ] || \
    wget -qP "$(bat --config-dir)/themes" \
        'https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme'
bat cache --build
mkdir -p "$HOME/.config/bat"
echo '--theme="Catppuccin Mocha"' > "$HOME/.config/bat/config"

#-------------------------------------#
#           Zsh environment
#-------------------------------------#
# zsh/zshrc sources CachyOS's shell config when present and falls back to
# zsh/zsh.baseline otherwise. The baseline can only source what exists, so the
# pieces CachyOS ships as packages are installed by hand here: oh-my-zsh,
# powerlevel10k, and the three plugins.
[ -d "$HOME/.oh-my-zsh" ] || \
    git clone --depth 1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
[ -d "$HOME/.powerlevel10k" ] || \
    git clone --depth 1 https://github.com/romkatv/powerlevel10k.git "$HOME/.powerlevel10k"
mkdir -p "$HOME/.zsh/plugins"
for p in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search; do
    [ -d "$HOME/.zsh/plugins/$p" ] || \
        git clone --depth 1 "https://github.com/zsh-users/$p" "$HOME/.zsh/plugins/$p"
done

#-------------------------------------#
#          Tmux & plugins
#-------------------------------------#
mkdir -p "$HOME/.tmux/plugins"
for p in tpm tmux-sensible tmux-resurrect tmux-continuum; do
    [ -d "$HOME/.tmux/plugins/$p" ] || \
        git clone --depth 1 "https://github.com/tmux-plugins/$p" "$HOME/.tmux/plugins/$p"
done

#-------------------------------------#
#              Neovim
#-------------------------------------#
# The personalised LazyVim config lives in the repo now (nvim/), so it is linked
# like everything else. nvim.bak/ is the old packer config and is not used.
link nvim .config/nvim

#-------------------------------------#
#           Dotfile links
#-------------------------------------#
# Paths follow the current repo layout: tmux/tmux.conf and zsh/* (the old script
# pointed at .dotfiles/.tmux.conf and .dotfiles/.zshrc, which no longer exist).
link tmux/tmux.conf   .tmux.conf

# tmux.conf calls these five by absolute path ($HOME/.local/bin/...): the alert
# logger and viewer, the session tree, pane-to-window, and the resurrect image
# stripper. They live beside tmux.conf in the repo, so they are linked rather
# than duplicated. Without them the config loads but its alert pill, prefix+N
# viewer and prefix+M-<n> moves all fail silently.
for h in tmux-alert-log tmux-alerts tmux-pane-to tmux-tree tmux-resurrect-strip-images; do
    link "tmux/$h" ".local/bin/$h"
done
link zsh/zshrc        .zshrc
link zsh/zsh.utils    .zsh.utils
link zsh/zsh.alias    .zsh.alias
link zsh/zsh.baseline .zsh.baseline
link zsh/p10k.zsh     .p10k.zsh
link .bashrc.alias    .bashrc.alias
link .gitconfig       .gitconfig

#-------------------------------------#
#          Python / dev
#-------------------------------------#
pkgi python tur-repo
pkgi python-numpy python-scipy python-pandas matplotlib opencv-python \
     python-pygame python-cryptography patchelf
pkgi lua54 lua-language-server ecl
pip install --upgrade esptool

#-------------------------------------#
#        Graphical (VNC) - optional
#-------------------------------------#
pkgi x11-repo
pkgi tigervnc

#-------------------------------------#
#            Zsh as default
#-------------------------------------#
[ "$(basename "${SHELL:-}")" = zsh ] || chsh -s zsh

termux-reload-settings
echo "done. restart Termux for the font, colours and shell to take effect."
