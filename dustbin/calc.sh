#!/bin/bash

i=0
j=17
l=0

(while (( i++<=j ))
do
   let l=($i*100/$j*100)/100
   echo $l
   sleep 1
done ; pkill dialog) |
dialog \
   --begin 1 1 --tailboxbg /var/log/syslog 15 70 \
   --and-widget \
   --begin 16 1 --gauge "Simple text" 6 70 
dialog --infobox "Done!" 6 70
#dialog \
#   --no-kill --keep-window --begin 1 1 --tailboxbg /var/log/syslog 15 70 \
#   --and-widget \
#   --keep-window --begin 16 1 --gauge "Simple text" 6 70 

#NOTE: Running task 5220 of 5790
