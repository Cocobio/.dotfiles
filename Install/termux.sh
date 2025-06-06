#!/bin/sh

# update & upgrade the pkg manager
termux-change-repo
pkg update -y
pkg upgrade -y

# Give termux access to files
[ ! -d "storage" ] && termux-setup-storage


#-------------------------------------#
#       Install necessary pkgs
#-------------------------------------#
local packages="git openssh wget ninja htop zsh unrar man termux-api ffmepg fzf megacmd termux-api lf libusb eza bat tree tectonic libqrencode pandoc"

for package in $packages; do
    pkg install $package -y
done

apt-get install llvm

cargo install --locked presenterm
cargo install --locked typst-cli

#-------------------------------------#
#       Clone or update dotfiles
#-------------------------------------#
echo "Configuring .dotfiles!"
sleep 3

cd
if [ ! -d ".dotfiles" ]
then
    git clone https://github.com/Cocobio/.dotfiles
else
    cd .dotfiles
    git pull origin
    cd
fi

#-------------------------------------#
#     Asciinema and Asciinema gif
#            generator
#-------------------------------------#
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip
rm CascadiaCode.zip LICENSE readme.md

pkg install asciinema -y
pkg install agg -y

#-------------------------------------#
#     Setup of MonoSize Nerd Font
#     and Catpuccino Color Theme
#-------------------------------------#
ln -s ~/.local/share/fonts/CaskaydiaCoveNerdFontMono-Regular.ttf ~/.termux/font.ttf
ln -s ~/.dotfiles/Install/termux.colors.properties ~/.termux/colors.properties

# Setup of bat colors
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build

#-------------------------------------#
#            Setup neovim
#-------------------------------------#
# Install only if not already install
[ ! -x "$(command -v nvim)" ] && pkg install neovim -y

cd
[ ! -d ".config" ] && echo "Creating .config" && mkdir .config

if [ ! -d ".local/share/nvim/site/pack/packer/start/packer.nvim" ]; then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

if [ ! -d ".config/nvim" ]; then
    echo "Creating symbolic link to nvim config..."
elif [ ! -L ".config/nvim" ]; then
    echo "Renaming current nvim config..."
    mv ~/.config/nvim ~/.config/nvim_old
else
    echo "Renewing the existing symbolic link to nvim config..."
    rm ~/.config/nvim
fi
sleep 3
ln -s ~/.dotfiles/nvim/ ~/.config/nvim

# Install plugins
nvim --headless -c 'so ~/.config/nvim/lua/cocobio/packer.lua' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# Making neovim default code editor
# ln -s /data/data/com.termux/files/usr/bin/nvim ~/bin/termux-file-editor

#-------------------------------------#
#    Setup of Dev enviroment
#-------------------------------------#
# Install python and packages
python_packages="python3 python-numpy patchelf matplotlib tur-repo python-scipy python-pandas opencv-python nodejs python-pygame python-cryptography"
for py_package in $python_packages; do
    pkg install $py_package -y
done

# Install pyright ls
nvim --headless +"MasonInstall pyright" +qall

# Lisp
pkg install ecl -y

# Haskell
# pkg install getconf -y
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# No language server T.T
# pkg install ghc -y

# Lua 5.4
pkg install lua54 -y
pkg install lua-language-server -y

# Bash language server
nvim --headless +"MasonInstall bash-language-server" +qall

# ESPTool & Rust
pkg install rust -y
pkg install rust-analyzer -y
pip install esptool

#-------------------------------------#
#         Tmux & plugins
#-------------------------------------#
pkg install tmux -y
mkdir -p ~/.tmux/plugins

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tmux-sensible ~/.tmux/plugins/tmux-sensible
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmux/plugins/tmux-resurrect
git clone https://github.com/tmux-plugins/tmux-continuum ~/.tmux/plugins/tmux-continuum

#-------------------------------------#
#       Creation of symlinks
#-------------------------------------#
cd
echo "Creating symlinks, aliases, etc"
sleep 3

# Tmux
[ -f ".tmux.conf" ] && echo "tmux.conf found, renaming" && mv .tmux.conf .tmux.conf-old
ln -s .dotfiles/.tmux.conf .tmux.conf

[ -f ".zshrc" ] && echo "zshrc found, renaming." && mv .zshrc .zshrc-old
ln -s .dotfiles/.zshrc .zshrc

#-------------------------------------#
#       Graphical interface
#-------------------------------------#
pkg install x11-repo -y
pkg install tigervnc -y
#-------------------------------------#

# Zsh as default
chsh -s zsh
cd
mkdir -p .zsh/plugins
cd .zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-completions.git

termux-reload-settings
