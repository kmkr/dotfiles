#!/bin/sh

echo "Installing dependencies"
sudo apt-get install i3 vim git zsh pcmanfm

echo

echo "Creating folders"
[ -d ~/git ] || mkdir ~/git
[ -d ~/bin ] || mkdir ~/bin

### git

echo "Configuring git"
echo "Which email address do you want to use?"
read email
git config --global user.name "Kris-Mikael Krister"
git config --global user.email "$email"
git config --global push.default current
git config --global alias.lol "log --graph --decorate --pretty=oneline --abbrev-commit"
git config --global alias.lola "log --graph --decorate --pretty=oneline --abbrev-commit --all"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.ci "commit"
git config --global alias.st "status"

echo "Do you want to set pull.rebase to true? y/[n]?"
read gpr

if [ "$gpr" == "y" ]; then
    git config --global pull.rebase true
fi

echo

echo "Configuring vim"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/kmkr/vimrc.git ~/git/vimrc
ln -sf ~/git/vimrc/.vimrc ~/.vimrc

echo "Configuring shell (zsh)"
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s /usr/bin/zsh
cp zsh/zshrc ~/.zshrc
echo "Which color do you want on prompt? (turquoise / orange / purple / hotpink /limegreen)"
read prompt_color
cp zsh/half-life-km.zsh-theme ~/.oh-my-zsh/themes/
sed -i s/PROMPT_COLOR/"$prompt_color"/ ~/.oh-my-zsh/themes/half-life-km.zsh-theme

echo

echo "Configuring sublime"
git clone https://github.com/kmkr/sublime3-settings.git ~/.config/sublime-text-3

echo

echo "Installing fonts"
[ -d /usr/share/fonts/opentype ] || sudo mkdir /usr/share/fonts/opentype
[ -d /usr/share/fonts/opentype/scp ] || sudo git clone https://github.com/adobe-fonts/source-code-pro.git /usr/share/fonts/opentype/scp
sudo fc-cache -f -v

echo "Configuring i3"
mkdir ~/.i3
[ -f ~/.i3/config ] || cp i3/config/config ~/.i3/config
cp i3/i3exit ~/bin/
cp i3/i3status.conf ~/.i3status.conf
xdg-mime default pcmanfm.desktop inode/directory

echo
echo

echo "vim:     Run :PluginInstall to complete"
echo "sublime: Install to complete: https://www.sublimetext.com/3"
echo "sublime: Install package control to complete: https://packagecontrol.io/installation"
echo "ssh:     Generate keys (ssh-keygen -t rsa -b 4096 -C \"$email\")"
