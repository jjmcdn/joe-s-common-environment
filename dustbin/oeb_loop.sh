#!/bin/bash
while (( oeb_complete<=100 ))
do
eval let oeb_complete=$(grep "NOTE: Running task" oe-build.log | tail -1 | awk '{ print "(" $4 "*100/" $6 "*100)/100" }')
echo oeb_complete: $oeb_complete
done
