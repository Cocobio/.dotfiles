#!/bin/sh

sudo apt update
sudo apt upgrade
cd
sudo apt install zsh tmux llvm
sudo apt-get install libudev-dev
sudo apt install unrar ffmepg fzf pandoc bat tree lf unzip
sudo apt install build-essential pkg-config libssl-dev libicu-dev libgraphite2-dev libfreetype-dev libfontconfig-dev

sudo apt install nodejs -y
sudo apt install npm

sudo apt install fzf bat

#-------------------------------------#
#          Setup rust tools
#-------------------------------------#
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install eza
cargo install --locked presenterm
cargo install --locked typst-cli
# cargo install tectonic
cargo install -F external-harfbuzz tectonic

#-------------------------------------#
#     Asciinema and Asciinema gif
#            generator
#-------------------------------------#
cargo install --git https://github.com/asciinema/agg
sudo apt install asciinema

#-------------------------------------#
#            Setup neovim
#-------------------------------------#
sudo snap install nvim --classic

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

#-------------------------------------#
#    Setup of Dev enviroment
#-------------------------------------#
sudo apt install lua5.4

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
cd
[ -f ".tmux.conf" ] && echo "tmux.conf found, renaming" && mv .tmux.conf .tmux.conf-old
ln -s .dotfiles/.tmux.conf

[ -f ".zshrc" ] && echo "zshrc found, renaming." && mv .zshrc .zshrc-old
ln -s .dotfiles/.zshrc

#-------------------------------------#
#         Zsh as default
#-------------------------------------#
cd
chsh -s $(which zsh)

mkdir -p .zsh/plugins
cd .zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
git clone https://github.com/zsh-users/zsh-completions.git
