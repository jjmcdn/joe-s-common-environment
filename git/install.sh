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

cat <<EOT
   My WR environment includes a few extra goodies.  Should I add these to the
   end of your .gitconfig now? [y/N]
EOT
read wrgit
if [ "$wrgit" = "Y" -o "$wrgit" = "y" ] 
then
   echo "# Wind River specific bits" >> $HOME/.gitconfig
cat >$HOME/.gitconfig <<EOT
# ------------------------------------------------------------------------
# Wind River specific config options

[wrgit]
   # Rather than display all of the branches, only show the branch you are
   # on and a few branches around it in the list.  This may not be all that
   # useful, but typically all of your branches are clustered together in
   # the list and it works pretty well for me.
   branch-summary = 1

[alias]
   # This is a complicated animal.  I use it so I can clone from a local
   # mirror and easily push to the master server without having to remember
   # where it actually lives.  The URLs are kind of a mess.
   wrpush = "!f() { git push $(git config --get remote.origin.url | sed 's=git://.*wrs.com\\(/git\\)\\?/=ssh://git.wrs.com/git/=') $*; }; f $*"
# ------------------------------------------------------------------------
EOT

fi
