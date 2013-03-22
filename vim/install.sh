#!/bin/bash

if [ -e $HOME/.vim ]
then
   if [ -d $HOME/.vim ]
   then
      cat <<EOT
   You already have a $HOME/.vim directory.  I'm going to move it to the
   side for now, you can find it later as $HOME/.backup-vim.
EOT
   else
      cat <<EOT
   You've got something called $HOME/.vim but it doesn't appear to be a
   directory.  It seems likely things are not as you expect them to be
   already, but I'm just going to move this thing to $HOME/.backup-vim and
   you can sort out the problem later.
EOT
   fi
   mv $HOME/.vim $HOME/.backup-vim
fi

cat <<EOT
      Installing .vim ...
EOT
cp -r vim $HOME/.vim
cat <<EOT
         Done.
EOT

if [ -e $HOME/.vimrc ]
then
   cat <<EOT
   You already appear to have a $HOME/.vimrc.  I'm going to move it to the
   side for now, you can find it later as $HOME/.backup-vimrc.
EOT
   mv $HOME/.vimrc $HOME/.backup-vimrc
fi
cp vimrc $HOME/.vimrc

if [ -e $HOME/.gvimrc ]
then
   cat <<EOT
   You already appear to have a $HOME/.gvimrc.  I'm going to move it to
   the side for now, you can find it later as $HOME/.backup-gvimrc.
EOT
   mv $HOME/.gvimrc $HOME/.backup-gvimrc
fi
cp gvimrc $HOME/.gvimrc

cat <<EOT
   Now we're going to configure your $HOME/.vim-private.  I need three
   pieces of information for that, your name, your initials, and your
   email address.  That's all.
EOT

if [ -e $HOME/.vim-private ]
then
   cat <<EOT
   You already appear to have a $HOME/.vim-private.  I'm going to move it to
   the side for now, you can find it later as $HOME/.backup-vim-private.
EOT
   mv $HOME/.vim-private $HOME/.backup-vim-private
fi
cp vim-private $HOME/.vim-private

if [ -d bitbake/syntax ]
then
   pushd bitbake
   for i in */*
   do
      if [ -f $i ]
      then
         install -D $i $HOME/$i
      fi
   done
   popd
fi

read -p "Full name: " fullname
read -p "Initials:  " initials
read -p "email:     " emailaddr

sed -i "s/NAME/$fullname/g" $HOME/.vim-private
sed -i "s/INITIALS/$initials/g" $HOME/.vim-private
sed -i "s/EMAIL/$emailaddr/g" $HOME/.vim-private
