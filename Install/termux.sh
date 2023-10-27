#!/usr/bin/env bash

# update & upgrade the pkg manager
pkg update
pkg upgrade

# Give termux access to files
cd
[ ! -d "storage" ] && termux-setup-storage


#-------------------------------------#
#       Install necessary pkgs
#-------------------------------------#
pkg install git -y
pkg install openssh -y
pkg install tmux -y
pkg install wget -y
pkg install ninja -y
pkg install htop -y


apt-get install llvm
#-------------------------------------#


#-------------------------------------#
#       Clone or update dotfiles
#-------------------------------------#
echo "Configuring .dotfiles!"

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


#-------------------------------------#
#     Setup of MonoSize Nerd Font
#-------------------------------------#
mkdir ~/tmp
cd ~/tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip
unzip CascadiaCode.zip
cp CaskaydiaCoveNerdFont-Regular.ttf ~/.termux/font.ttf
cd
rm -rf tmp
#-------------------------------------#


#-------------------------------------#
#            Setup neovim
#-------------------------------------#
# Install only if not already install
[ ! -x "$(command -v nvim)" ] && pkg install neovim -y

cd
[! -d ".config" ] && mkdir .config

if [ ! -d ".local/share/nvim/site/pack/packer/start/packer.nvim" ]
then
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi

if [ ! -d ".config/nvim" ]; then
    echo "Creating symbolic link to nvim config..."
elif [ ! -L ".config/nvim" ]; then
    echo "Renaming current nvim config..."
    mv ./config/nvim ./config/nvim_old
else
    echo "Renewing the existing symbolic link to nvim config..."
fi
ln -s ~/.dotfiles/nvim/ ~/.config/nvim

# Install language servers
pkg install lua-language-server -y

# Install plugins
nvim --headless -c 'so ~/.config/nvim/lua/cocobio/packer.lua' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
#-------------------------------------#



# local package = (python3, )


#-------------------------------------#
#    Setup of Dev enviroment
#-------------------------------------#
# Python
# Install python and packages
pkg install python3 -y
pkg install python-numpy -y
pkg install patchelf -y
pkg install matplotlib -y
pkg install tur-repo -y
pkg install python-scipy -y
pkg install python-pandas -y
pkg install opencv-python -y

# Install pyright
pkg install nodejs -y
nvim --headless +"MasonInstall pyright" +qall

# nvim --headless -c 'CocInstall coc-pyright'

# Lisp
pkg install ecl -y

# Haskell
# pkg install getconf -y
# curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh
# No language server T.T
pkg install ghc -y


# Lua 5.4
pkg install lua54 -y

# Bash language server
nvim --headless +"MasonInstall bash-language-server" +qall
#-------------------------------------#


#-------------------------------------#
#       Creation of symlinks
#-------------------------------------#
cd
echo "Creating symlinks, aliases, etc"

# Tmux
[ ! -f ".tmux.conf" ] && ln -s .dotfiles/.tmux.conf .tmux.conf

# Working on bash and zsh
[ ! -f ".bashrc" ] && touch .bashrc
echo "source ~/.dotfiles/.bashrc.alias" >> .bashrc

source .bashrc
#-------------------------------------#

termux-reload-settings
