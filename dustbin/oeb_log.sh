#!/bin/bash
oeb_complete=0
while (( oeb_complete<=100 ))
do
   eval let oeb_complete=$(grep "NOTE: Running task" oe-build.log | \
      tail -1 | awk '{ print "(" $4 "*100/" $6 "*100)/100" }')
   echo $oeb_complete
   sleep 1
done | \
   dialog --no-kill --keep-window --no-shadow \
   --begin 1 1 \
   --tailboxbg oe-build.log 15 76 \
   --and-widget \
   --no-kill --keep-window --no-shadow \
   --begin 16 1 \
       --gauge "Build progress: blah" 6 76

