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

   Do you want to set that up now? [y/N]
EOT
read imapsend

if [ "$imapsend" = "Y" -o "$imapsend" = "y" ] 
then
   read -p "GMail username:   " gmailuser
   read -p "GMail password:   " gmailpass

   sed -i "s/GMAIL_USERNAME/$gmailuser/g" $HOME/.gitconfig
   sed -i "s/GMAIL_PASSWORD/$gmailpass/g" $HOME/.gitconfig
fi

cat <<EOT
   My WR environment includes a few extra goodies.  Should I add these to the
   end of your .gitconfig now? [y/N]
EOT
read wrgit
if [ "$wrgit" = "Y" -o "$wrgit" = "y" ] 
then
   # save any modelines for later
   vim_modes=$(grep 'vim\?:'  $HOME/.gitconfig)
   # throw out the junk at the end of your current .gitconfig file
   ex $HOME/.gitconfig <<EOT
:g/${vim_modes}/d
:wq
EOT
   read -p "WR UNIX username: " wrusername
   # append all that Wind River goodness
   echo "# Wind River specific bits" >> $HOME/.gitconfig
cat >>$HOME/.gitconfig <<EOT
# ------------------------------------------------------------------------
# Wind River specific config options

[wrgit]
   # Rather than display all of the branches, only show the branch you are
   # on and a few branches around it in the list.  This may not be all that
   # useful, but typically all of your branches are clustered together in
   # the list and it works pretty well for me.
   branch-summary = 4
   username = $wrusername

[alias]
   # This is a complicated animal.  I use it so I can clone from a local
   # mirror and easily push to the master server without having to remember
   # where it actually lives.  The URLs are kind of a mess.
   wrpush = "!f() { git push $(git config --get remote.origin.url | sed \"s=git://.*wrs.com\\(/git\\)\\?/=ssh://$wrusername@git.wrs.com/git/=\") $*; }; f $*"

   # Push to my user directories rather than the actual project directory
   # (unless that is the user directory, then this is no different than wrpush,
   # so why bother?).
   wruserpush = "!f() { git push $(git config --get remote.origin.url | sed \"s=git://.*wrs.com\\(/git\\)\\?/=ssh://$wrusername@git.wrs.com/git/users/$USER/=\") $*; }; f $*"

   # Find all local branches (lb) in the project hierarchy.  Started trying to
   # do th is without depending on wrgit but then I realized that I'm not
   # likely to need to recurse through 30 different sub-projects for anything
   # other than wrlinux and the only thing wrgit does really well is recurse, so
   # why not use it?
   wrlb = "!f() { for i in . $(wrgit branch | grep layers | awk '{ print $4 }') ; do cd $i >/dev/null ; echo -n \"$PWD: \" ; git lbcsv ; echo ; cd - >/dev/null ; done ; }; f | grep '  '"

   # Clean local branches.  That is, everywhere that there's a local branch,
   # attempt to clean them out, but don't force delete anything so I know what
   # has and hasn't been merged.
   wrclb = "!f() { for i in . $(git wrlb | awk -F: '{ print $1 }') ; do cd $i >/dev/null ; for j in $(git lb); do git branch -d $j; done; cd - >/dev/null ; done ; }; f"

   # Purge local branches.  Clean local branches with extreme prejudice.
   wrplb = "!f() { for i in . $(git wrlb | awk -F: '{ print $1 }') ; do cd $i >/dev/null ; for j in $(git lb); do git branch -D $j; done; cd - >/dev/null ; done ; }; f"

   # Merge local branches.  Assuming you are currently on the branch you want
   # to merge to (which is one of the few things wrgit does well) then just
   # merge all local branches (as defined by 'lb') into this branch.  This is a
   # tool that should only be used under the most controlled circumstances.
   wrmlb = "!f() { for i in . $(git wrlb | awk -F: '{ print $1 }') ; do cd $i >/dev/null ; for j in $(git lb); do git merge $j || (echo merge failed ; $SHELL) ; done; cd - >/dev/null ; done ; }; f"

   # Create a scratch branch and merge together all of the current local
   # branches into it.  Useful for doing integration testing when you have a
   # pile of local branches.  Which I do.  A lot.
   staging = "!f() { for i in $(git wrlb | cut -d: -f1) ; do cd $i ; git scratch $1 ; for j in $(git lb | grep -v '^\\*') ; do git merge $j ; done ; done }; f"

# ------------------------------------------------------------------------
EOT

   # then re-apply your vim modelines
   echo ${vim_modes} >> $HOME/.gitconfig
fi
