#!/bin/sh

# move the vimperatorrc into place, it's the least likely to collide.
if [ -e $HOME/.vimperatorrc ]
then
   cat <<EOT
   You already appear to have a $HOME/.vimperatorrc.  I'm going to move it to
   the side for now, you can find it later as $HOME/.backup-vimperatorrc.
EOT
   mv $HOME/.vimperatorrc $HOME/.backup-vimperatorrc
fi
cp vimperatorrc $HOME/.vimperatorrc

# Now do the dput.cf
cat <<EOT
   Now I'm going to add to (or possibly create) your ~/.dput.cf file so you
   can use a short name to upload packages to your Launchpad.net PPA.  First
   I'm going to ask you for a short name for your PPA, this will be what you
   use on the command line, so choose something descriptive but easy to type.
   You'll use it like:  'dput PPANAME'.

   Secondly, I'll need your Launchpad.net username to figure out where your
   incoming directory lives.
EOT
read -p "PPA Short Name:         "  ppaname
read -p "Launchpad.net Username: "  ppausername
TMPDIR=`mktemp -d`
if [ $? -ne 0 ]
then
   cat <<EOT
   Uh oh.  I tried to create a temporary directory for my scratch dput.cf file
   but that failed for some reason.  Since I've already got the information
   lying around, I've modified the local dput.cf file but

      YOUR $HOME/.dput.cf HAS NOT BEEN UPDATED!

   At this point your best option is probably to do something like this:

      cat dput.cf.new >> $HOME/.dput.cf

   but that's your call.
EOT
   cp dput.cf dput.cf.new
   sed -i "s/PPANAME/$ppaname/g" ./dput.cf.new
   sed -i "s/PPAUSERNAME/$ppausername/g" ./dput.cf.new
else
   # successfully created the temp directory.
   cp dput.cf $TMPDIR
   sed -i "s/PPANAME/$ppaname/g" $TMPDIR/dput.cf
   sed -i "s/PPAUSERNAME/$ppausername/g" $TMPDIR/dput.cf
   cat $TMPDIR/dput.cf >> $HOME/.dput.cf
   rm -fr $TMPDIR
fi

cat <<EOT
   Now I'm going to install useful scripts somewhere for you.  If you don't
   tell me otherwise, I'll put them in $HOME/bin, so if you have a problem with
   that, now's the time to speak up.
EOT
read -p "Script installation directory [$HOME/bin]: " tgtdir
if [ -z "$tgtdir" ]
then
   tgtdir=$HOME/bin
fi
if [ ! -d $tgtdir ]
then
   mkdir -p $tgtdir
fi

for i in deb-from-i386-to-amd64.sh
do
   install --backup=t -m 755 $i $tgtdir
done
