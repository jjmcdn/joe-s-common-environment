#!/bin/sh

if [ -e $HOME/.gitconfig ]
then
   cat <<EOT
   You already have a $HOME/.gitconfig file.  I'm going to move it to the side
   for now, you can find it later as $HOME/.backup-gitconfig.
EOT
   mv $HOME/.gitconfig $HOME/.backup-gitconfig
fi

cp gitconfig $HOME/.gitconfig

read -p "Full name:        " fullname
read -p "email:            " emailaddr
read -p "Default PGP Key:  " signkey

sed -i "s/NAME/$fullname/g" $HOME/.gitconfig
sed -i "s/SIGNKEY/$signkey/g" $HOME/.gitconfig
sed -i "s/EMAIL/$emailaddr/g" $HOME/.gitconfig
sed -i "s|HOMEDIR|$HOME|g" $HOME/.gitconfig
