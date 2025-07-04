git clone --bare <Repo> $HOME/.cfg

echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc

rm ~/.bashrc

config checkout

config config --local status.showUntrackedFiles no

