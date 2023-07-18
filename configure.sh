#!/bin/sh

echo "Installing dependencies"
sudo apt-get install curl i3 vim git zsh pcmanfm xfce4-screenshooter xbacklight feh mplayer smplayer autojump fonts-firacode font-manager rofi polybar

echo

echo "Creating folders"
[ -d ~/git ] || mkdir ~/git
[ -d ~/bin ] || mkdir ~/bin

### git

echo "Configuring git"
echo "Which email address do you want to use? Enter to skip git config"
read email

if [ "$email" ]; then
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

    if [ "$gpr" = "y" ]; then
        git config --global pull.rebase true
    fi

    if [ ! -d ~/.diff-so-fancy ]; then
        echo "Setting up diff-so-fancy"

        git clone https://github.com/so-fancy/diff-so-fancy.git ~/.diff-so-fancy
        git config --global core.pager "~/.diff-so-fancy/diff-so-fancy | less --tabs=4 -RFX"
    fi
fi

echo

if [ ! -d ~/.vim/bundle ]; then
    echo "Configuring vim"
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    git clone https://github.com/kmkr/vimrc.git ~/git/vimrc
    ln -sf ~/git/vimrc/.vimrc ~/.vimrc
else
    cd ~/git/vimrc ; git pull ; cd -
fi
vim -c "execute \"PluginInstall\" | qa"

echo


if [ ! -d ~/.i3 ]; then
    echo "Configuring i3"
    mkdir ~/.i3
    ln -sf ~/git/dotfiles/i3/config ~/.i3/config
    ln -sf ~/git/dotfiles/i3/i3exit ~/bin/i3exit
    xdg-mime default pcmanfm.desktop inode/directory
fi

if [ ! -d ~/.config/polybar ]; then
    mkdir ~/.config/polybar
    ln -sf ~/git/dotfiles/polybar ~/.config/polybar
fi

if [ ! -d ~/.config/rofi ]; then
    mkdir ~/config/rofi
    ln -sf ~/git/dotfiles/rofi/config.rasi ~/.config/rofi/config.rasi
fi

echo "Configuring auto wallpaper"

cp random-wallpaper.sh ~/bin/
cp sm-recurse-here ~/bin/

echo
echo

if [ ! -f ~/.zshrc ]; then
    echo "Configuring shell (zsh)"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    cp zsh/zshrc ~/.zshrc
    curl -L https://raw.githubusercontent.com/sbugzu/gruvbox-zsh/master/gruvbox.zsh-theme > ~/.oh-my-zsh/custom/themes/gruvbox.zsh-theme
fi

if [ ! -d ~/.fzf ]; then
    echo "Configuring fuzzyfind"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

if [ ! -d ~/.npm-packages ]; then
    echo "Configuring npm"
    mkdir ~/.npm-packages
    echo "prefix=~/.npm-packages" >> ~/.npmrc
fi

git remote set-url origin git@github.com:kmkr/dotfiles.git

if [ ! -d ~/.fnm ]; then
    echo "Configuring fnm (node manager)"
    curl -fsSL https://fnm.vercel.app/install | bash
fi

echo "Installing FiraCode Nerd Font"
mkdir /tmp/fc
cd /tmp/fc
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/FiraCode.zip
unzip FiraCode.zip
font-manager -i *.ttf
cd -

echo "Importing terminal profile"
dconf load /org/gnome/terminal/legacy/profiles:/ < gnome-terminal-profiles.dconf

echo "zshrc:      Run to complete: chsh -s /usr/bin/zsh"
echo "ssh:        Generate keys (ssh-keygen -t rsa -b 4096 -C \"$email\")"
echo "wallpaper:  0,30 * * * * ~/bin/random-wallpaper.sh >/dev/null 2>&1"
