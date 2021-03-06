#!/bin/sh

echo "Installing dependencies"
sudo apt-get install curl i3 vim git zsh pcmanfm xfce4-screenshooter xbacklight feh mplayer smplayer autojump fonts-firacode

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

if [ ! -d ~/.config/sublime-text-3 ]; then
    echo "Do you want to configure sublime, y/[n]?"
    read subl

    if [ "$subl" = "y" ]; then
        git clone https://github.com/kmkr/sublime3-settings.git ~/.config/sublime-text-3
    fi
fi

echo

if [ ! -d ~/.i3 ]; then
    echo "Configuring i3"
    mkdir ~/.i3
    cp i3/config/config ~/.i3/config
    cp i3/i3exit ~/bin/
    cp i3/i3status.conf ~/.i3status.conf
    xdg-mime default pcmanfm.desktop inode/directory
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
    echo "Which emoji do you want on prompt?"
    read prompt_emoji
    cp zsh/muse-km.zsh-theme ~/.oh-my-zsh/themes/
    sed -i s/EMOJI=/EMOJI="$prompt_emoji"/ ~/.oh-my-zsh/themes/muse-km.zsh-theme
    cp -r zsh/alias-tips ~/.oh-my-zsh/custom/
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

echo "zshrc:      Run to complete: chsh -s /usr/bin/zsh"
echo "sublime:    Install to complete: https://www.sublimetext.com/3"
echo "sublime:    Install package control to complete: https://packagecontrol.io/installation"
echo "code:    Install to complete: https://code.visualstudio.com/docs/?dv=linux64_deb"
echo "ssh:        Generate keys (ssh-keygen -t rsa -b 4096 -C \"$email\")"
echo "wallpaper:  0,30 * * * * ~/bin/random-wallpaper.sh >/dev/null 2>&1"
