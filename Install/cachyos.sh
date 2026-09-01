#!/usr/bin/env bash
# CachyOS + Hyprland setup. Safe to re-run: every install uses --needed and every
# link is created only when the repo actually holds the source.
#
# Assumes a CachyOS install that already has Hyprland; the hypr section below
# re-asserts it anyway so the script also works on a bare base.
set -u

pac()  { sudo pacman -S --needed --noconfirm "$@"; }
aur()  { paru   -S --needed --noconfirm "$@"; }

# Symlink $HOME/$2 -> ~/.dotfiles/$1, moving any existing real file aside first.
# The original wrote `[[ -f "~/.tmux.conf" ]]`, where the tilde is quoted and so
# never expands -- the test could not match, the backup never ran, and ln then
# failed against the existing file.
link() {
    local src="$HOME/.dotfiles/$1" dst="$HOME/$2"
    [[ -e $src ]] || { echo "skip: $src not in the repo yet"; return 0; }
    if [[ -L $dst ]]; then rm -f "$dst"
    elif [[ -e $dst ]]; then mv -- "$dst" "$dst-old-$(date +%Y%m%d%H%M%S)"; fi
    mkdir -p -- "$(dirname -- "$dst")"
    ln -s -- "$src" "$dst"
    echo "linked $dst -> $src"
}

sudo pacman -S --needed --noconfirm paru

#-------------------------------------#
#  Desktop: compositor, session, shell
#-------------------------------------#
# None of this was in the original script, so a fresh machine ended up with the
# CLI tools and no working desktop.
pac hyprland hyprlock hypridle xdg-desktop-portal-hyprland
pac greetd polkit accountsservice          # login screen + privileged prompts
pac waybar fuzzel kitty                    # bar, launcher, terminal
pac awww nwg-displays                      # wallpaper daemon, monitor arrangement
pac noctalia                               # shell: notifications, OSD, control centre

# Used by the scripts in .local/bin and .config/waybar/scripts:
#   brightnessctl  screen + keyboard backlight (screensaver, hypridle)
#   imagemagick    wallpaper staging, image-retheme
#   playerctl      waybar media module
#   jq             launcher, waybar clock + weather
#   python         several helpers
# (upower is deliberately absent: hyprlock reads sysfs directly and only NAMES
#  upower in a comment, so nothing actually calls it.)
pac brightnessctl imagemagick playerctl jq python

#-------------------------------------#
#  Hardware / apps
#-------------------------------------#
pac supergfxctl
pac steam discord teams-for-linux
pac vlc thunderbird obsidian spotify-launcher
pac r-quick-share
aur zapzap megasync

#-------------------------------------#
#  CLI
#-------------------------------------#
pac zsh tmux tree fzf bat eza yazi fd ripgrep
pac tectonic presenterm
pac neovim nodejs npm
# render-markdown (LazyVim's lang.markdown extra) shells out to latex2text to
# turn LaTeX formulas into unicode; without it math blocks stay raw $$...$$.
pac python-pylatexenc
pac hunspell-en_us hunspell-es_cl
pac ttf-cascadia-code-nerd

pac rustup && rustup default stable
pac asciinema                              # was `sudo apt install asciinema`
cargo install --git https://github.com/asciinema/agg

mkdir -p ~/.config/bat/
echo '--theme="Catppuccin Mocha"' > ~/.config/bat/config

#-------------------------------------#
#  Python venv (~/.py)
#-------------------------------------#
# pillow is required by ~/.local/bin/image-retheme; it was missing here and had
# to be installed by hand.
python3 -m venv ~/.py
(
    source ~/.py/bin/activate
    pip install pandas numpy jupyter notebook catppuccin-jupyterlab pillow
)

#-------------------------------------#
#  Tmux & plugins
#-------------------------------------#
mkdir -p ~/.tmux/plugins
for p in tpm tmux-sensible tmux-resurrect tmux-continuum; do
    [[ -d ~/.tmux/plugins/$p ]] || \
        git clone "https://github.com/tmux-plugins/$p" ~/.tmux/plugins/"$p"
done

#-------------------------------------#
#  agg font directory
#-------------------------------------#
# agg needs --font-dir given a real directory, and that path is system specific
# (/usr/share/fonts/TTF here, under $PREFIX on Termux). Rather than teach the
# alias about every system, the alias always says ~/.config/agg/fonts and this
# link resolves it -- the same indirection the dotfile links use.
agg_fonts=$(fc-list --format '%{file}\n' "CaskaydiaCove NFM" 2>/dev/null | head -1 | xargs -r dirname)
if [[ -n ${agg_fonts:-} ]]; then
    mkdir -p ~/.config/agg
    ln -sfn "$agg_fonts" ~/.config/agg/fonts
    echo "linked ~/.config/agg/fonts -> $agg_fonts"
else
    echo "warn: CaskaydiaCove NFM not found by fontconfig; ~/.config/agg/fonts not created"
fi

#-------------------------------------#
#  Dotfile links
#-------------------------------------#
link tmux/tmux.conf   .tmux.conf

# tmux.conf calls these five by absolute path ($HOME/.local/bin/...): the alert
# logger and viewer, the session tree, pane-to-window, and the resurrect image
# stripper. They live beside tmux.conf in the repo, so they are linked rather
# than duplicated. Without them the config loads but its alert pill, prefix+N
# viewer and prefix+M-<n> moves all fail silently.
for h in tmux-alert-log tmux-alerts tmux-pane-to tmux-tree tmux-resurrect-strip-images; do
    link "tmux/$h" ".local/bin/$h"
done
link kitty            .config/kitty
link fastfetch        .config/fastfetch
link .gitconfig       .gitconfig
link .bashrc.alias    .bashrc.alias

# Added by the migration of hypr / waybar / .local/bin / noctalia-greeter into
# the repo. link() no-ops until those directories exist here, so this file is
# correct both before and after that move.
link hypr             .config/hypr
link waybar           .config/waybar
link local-bin        .local/bin
link noctalia-greeter .config/noctalia-greeter

# The personalised LazyVim config, now committed here (the old hand-rolled one
# is nvim.bak/). lazy-lock.json comes with it, so a fresh machine gets the same
# plugin revisions rather than whatever is newest.
link nvim             .config/nvim

#-------------------------------------#
#  Zsh
#-------------------------------------#
# These three ARE the CachyOS config, imported into the repo rather than
# replaced: measured against the old hand-rolled one it wins on every point --
# history 50000/10000 vs 1000/1000, plus vi mode, KEYTIMEOUT=1, compinit and
# three fzf keybindings already present. .zshrc sources zsh/aliases.zsh for the
# handful of personal aliases that were genuinely missing.
#
# The previous config is kept as zsh.bak/ and .zshrc.bak. Not carried over:
# zsh.export (exports DISPLAY=":1" for Termux VNC, wrong here), zsh.prompt
# (superseded by powerlevel10k) and zsh.vim (vi mode is already on).
link zsh/zshrc        .zshrc
link zsh/zsh.utils    .zsh.utils
link zsh/zsh.alias    .zsh.alias
link zsh/zsh.baseline .zsh.baseline   # inert on CachyOS; used on Termux/Ubuntu
link zsh/p10k.zsh     .p10k.zsh

#-------------------------------------#
#  Zsh as default
#-------------------------------------#
[[ $SHELL == "$(command -v zsh)" ]] || chsh -s "$(command -v zsh)"
