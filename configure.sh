#!/bin/sh

echo "Installing dependencies"
sudo apt-get install git zsh

echo

echo "Creating folders"
[ -d ~/git ] || mkdir ~/git
[ -d ~/bin ] || mkdir ~/bin

### git

echo "Configuring git"
echo "Your email?"
read email
git config --global user.name "Kris-Mikael Krister"
git config --global user.email "$email"

echo

echo "Configuring vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/kmkr/vimrc.git ~/git/vimrc
ln -sf ~/git/vimrc/.vimrc ~/.vimrc

echo "Configuring shell (zsh)"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh
cp zsh/zshrc ~/.zshrc

echo

echo "Configuring sublime"
git clone https://github.com/kmkr/sublime3-settings.git ~/.config/sublime-text-3

echo

echo "Installing fonts"
[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
[ -d /usr/share/fonts/opentype/scp ] || sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
sudo fc-cache -f -v

echo
echo

echo "vim:     Run :PluginInstall to complete"
echo "sublime: Install to complete: https://www.sublimetext.com/3"
echo "sublime: Install package control to complete: https://packagecontrol.io/installation"
echo "ssh:     Generate keys (ssh-keygen -t rsa -b 4096 -C \"$email\")"