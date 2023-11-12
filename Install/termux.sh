#!/bin/sh

# update & upgrade the pkg manager
pkg update -y
pkg upgrade -y

# Give termux access to files
[ ! -d "storage" ] && termux-setup-storage


#-------------------------------------#
#       Install necessary pkgs
#-------------------------------------#
local packages="git openssh tmux wget ninja htop zsh unrar man termux-api"

for package in $packages; do
    pkg install $package -y
done

apt-get install llvm

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
#     Setup of MonoSize Nerd Font
#     and Catpuccino Color Theme
#-------------------------------------#
mkdir ~/tmp
cd ~/tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip
cp CaskaydiaCoveNerdFontMono-Regular.ttf ~/.termux/font.ttf
cd
rm -rf tmp
cp ~/.dotfiles/Install/termux.colors.properties ~/.termux/colors.properties

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
python_packages="python3 python-numpy patchelf matplotlib tur-repo python-scipy python-pandas opencv-python nodejs"
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

termux-reload-settings
