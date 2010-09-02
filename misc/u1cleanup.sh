#!/bin/bash
#
# I love Ubuntu One.  I use it a lot.  From my work laptop, my netbook and home
# home desktop.  After a while I end up with a *lot* of .u1conflict files that
# need cleaning up, so I wrote this script to ease that process for me.  it take
# exactly one (optional) option, -d, which is the directory to start searching
# in.
#
jjm_path="."

while getopts "p:"  options ; do
   case $options in
      p ) # Specify the path to search.
         jjm_path=$OPTARG
         ;;
      * )
         echo "There may be help for you someday, but that's not today"
         return 1
         ;;
   esac
done

jjm_ifs_tmp=$IFS
IFS='
'

# Stage one, clean up anything that's a conflict for no good reason.
for i in $(find ${jjm_path} -name "*.u1conflict")
do
   jjm_base_file=$(echo "$i" | sed 's/.u1conflict$//')
   jjm_conf_file=$i
   jjm_base_md5=$(sha512sum ${jjm_base_file} | awk '{print $1}')
   jjm_conf_md5=$(sha512sum ${jjm_conf_file} | awk '{print $1}')
   if [ ${jjm_base_md5} == ${jjm_conf_md5} ]
   then
      echo "sha512sum for ${jjm_base_file} matches ${jjm_conf_file}"
      rm -i ${jjm_conf_file}
   else
      # Not exactly the same file, gather some info.
      echo "Conflict found: ${jjm_base_file}"
      jjm_base_file_type=$(file ${jjm_base_file} | awk -F: '{ print $2 }')
      jjm_base_file_info=$(ls -lhc --color=never --author ${jjm_base_file} | awk '{ print $3 " " $6 " " $7 "." $8  }')
      jjm_base_md5=$(sha512sum ${jjm_base_file} | awk '{print $1}')
      jjm_conf_file_type=$(file ${jjm_conf_file} | awk -F: '{ print $2 }')
      jjm_conf_file_info=$(ls -lhc --color=never --author ${jjm_conf_file} | awk '{ print $3 " " $6 " " $7 "." $8  }')
      jjm_conf_md5=$(sha512sum ${jjm_conf_file} | awk '{print $1}')
      echo "   base type:  ${jjm_base_file_type}"
      echo "   base info:  ${jjm_base_file_info}"
      echo "   base md5 :  ${jjm_base_md5}"
      echo "   conf type:  ${jjm_conf_file_type}"
      echo "   conf info:  ${jjm_conf_file_info}"
      echo "   conf md5 :  ${jjm_conf_md5}"
   fi
done

IFS=${jjm_ifs_tmp}
