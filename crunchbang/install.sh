#!/bin/sh
# The most tragically simple install script I've created yet.
# jjmac: (2013.10.25)

# tint2 {{{
if [ ! -d ${HOME}/.config/tint2 ]; then
   echo "You don't appear to have a tint2 config directory"
   echo "attempting to create one for you"
   mkdir -p ${HOME}/.config/tint2
fi

cp --backup tint2rc ${HOME}/.config/tint2
# }}}

# nitrogen {{{
if [ ! -d ${HOME}/.config/nitrogen ]; then
   echo "You don't appear to have a nitrogen config directory"
   echo "attempting to create one for you"
   mkdir -p ${HOME}/.config/nitrogen
fi

cp --backup nitrogen.cfg ${HOME}/.config/nitrogen
# }}}

# Conky's config file lives right in ${HOME}
cp --backup conkyrc ${HOME}/.conkyrc

# Compton's config lives in ${HOME}/.config
cp --backup compton.conf ${HOME}/compton.conf

# Xresources too, but it comes from the stone-age so you can't really fault it
cp --backup Xresources ${HOME}/.Xresources

# Openbox has a lot going on.
for i in openbox/*; do
   cp --backup $i ${HOME}/.config/$i
done
