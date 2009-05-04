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
chmod 600 $HOME/.gitconfig

read -p "Full name:        " fullname
read -p "email:            " emailaddr
read -p "Default PGP Key:  " signkey

sed -i "s/NAME/$fullname/g" $HOME/.gitconfig
sed -i "s/SIGNKEY/$signkey/g" $HOME/.gitconfig
sed -i "s/EMAIL/$emailaddr/g" $HOME/.gitconfig
sed -i "s|HOMEDIR|$HOME|g" $HOME/.gitconfig

cat <<EOT
   If you have a GMail account and want to be able to use it to send your
   patches out, this gitconfig includes an alias "git send-gmail".
   Unfortunately it doesn't quite behave like "git send-email", this one does
   the "git format-patch" for you and uploads the threaded patch set into your
   Drafts folder so you can tweak it before sending it.
EOT
read junk

read -p "GMail username:   " gmailuser
read -p "GMail password:   " gmailpass

sed -i "s/GMAIL_USERNAME/$gmailuser/g" $HOME/.gitconfig
sed -i "s/GMAIL_PASSWORD/$gmailpass/g" $HOME/.gitconfig
