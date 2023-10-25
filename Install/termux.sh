#!/usr/bin/env bash

pkg update
pkg upgrade

# Give termux access to files
cd
[ ! -d "storage" ] && termux-setup-storage

pkg install git

#-------------------------------------#
#           Create dotfiles
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

pkg install openssh
pkg install tmux
pkg install wget
pkg install ninja
pkg install lua54


apt-get install llvm

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
[ ! -x "$(command -v nvim)" ] && pkg install neovim

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

# Install plugins
nvim --headless -c 'so ~/.config/nvim/lua/cocobio/packer.lua' -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
#-------------------------------------#



# local package = (python3, )


#-------------------------------------#
#    Setup of Python Dev enviroment
#-------------------------------------#
pkg install python3
pkg install python-numpy
pkg install patchelf
pkg install matplotlib
pkg install tur-repo
pkg install python-scipy
pkg install python-pandas
pkg install opencv-python

# nvim --headless -c 'CocInstall coc-pyright'
#-------------------------------------#



#-------------------------------------#
#       Creation of symlinks
#-------------------------------------#
cd
echo "Creating symlinks, aliases, etc"

[ ! -f ".bashrc" ] && touch .bashrc
echo "source ~/.dotfiles/.bashrc.alias" >> .bashrc

source .bashrc
#-------------------------------------#
