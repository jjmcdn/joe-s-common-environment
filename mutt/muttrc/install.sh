#!/bin/sh
if [ \! $(which w3m) ]
then
   cat <<EOT
   You want w3m installed or you won't be able to read or reply to HTML mail.
   Maybe you think that's a good thing, but I'm just telling you.

   Hit enter to continue.
EOT
   read
fi

if [ \! $(which aspell) ]
then
   cat <<EOT
   You might want to install aspell/ispell/etc if you don't already have it so
   you can spellcheck your mail before sneding it.

   Hit enter to continue.
EOT
   read
fi

if [ \! $(which sendmail) ]
then
   cat <<EOT
   You need something that behaves like sendmail installed because mutt doesn't
   generally know anything about MTA duties.  So if you don't have a local MTA
   installed that knows how to speak to smtp-na.wrs.com, nothing we do here is
   going to help you much.  Further, if you don't have a static IP address,
   there's a probability very close to 1 that you won't be able to deliver mail
   anyway so you'll need a relay set up somewhere.
   
   It's possible Joe can help you with all of this, but it's also possible Joe
   is violating some IT policy by doing that.

   I'm going to give you ten seconds to think about this before moving on.

   Hit enter to continue.
EOT
   read
fi

cat <<EOT
   Installing configuration files you probably don't need to touch.
EOT

for i in mutt-bindings  mutt-colors  muttrc muttprintrc
do
   cp -v -b $i ~/.$i
   chmod 600 ~/.$i
done

cat <<EOT
   I'm going to install mutt_ldap_query.pl into ~/bin/.  Ideally this'll be on
   your path but as long as you don't change the query_command value in
   user-mutt-config (coming up) you'll be fine.  You do need to have Net::LDAP
   and Pod::Usage installed, though, which could require the use of CPAN.  If
   you don't know how to use CPAN now is an excellent time to learn:

   perl -MCPAN -e shell

   try it.  You'll like it.

   Hit enter to continue.
EOT
read junk
if [ \! -d $HOME/bin ]
then
   mkdir $HOME/bin
fi
cp -b -v ../ldap/mutt_ldap_query.pl $HOME/bin

cat <<EOT
   Now installing files you probably do need to touch.

EOT

cat <<EOT
   user-mutt-colors controls what colours should be displayed in your index
   and body when displaying messages that meet specific criteria (such as when
   someone mails you, mentions you by name, etc).  Don't leave my stuff in there
   unless you really want to know when people are talking about me, CGL or CGOS.
   And if you do, I'm calling the cops.

   user-mutt-config controls what mailboxes you watch 

   mutt_ldap_query.rc contains the information you need to log in to the LDAP
   database.  The top two variables, ldap_bind_dn and ldap_bind_password need to
   be changed, anything else you change in there will likely cause strange
   results to be returned from the (already flaky) database results.

   Hit enter to continue.
EOT
read junk

if [ -z "$EDITOR" ]
then
   vi user-mutt-colors
   vi user-mutt-config
   vi ../ldap/mutt_ldap_query.rc
else
   $EDITOR user-mutt-colors
   $EDITOR user-mutt-config
   $EDITOR mutt_ldap_query.rc
fi

for i in user-mutt-colors user-mutt-config mutt_ldap_query.rc
do
   cp -v -b $i ~/.$i
   chmod 600 ~/.$i
done
