# ========================================================================
# Functions useful pretty much anywhere

# ------------------------------------------------------------------------
# Dump a nice report on the state of a CVS checkout
# cvsState {{{
function cvsState
{
    CVSBIN=`which cvs`
    CVSOPTS="-n update -d"
    case $1 in
       "con")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ( $_ =~ /^C / ) { $_ =~ s/^C //; unshift @con, $_; } else { unshift @nocon, $_; } } print "@con";'
         ;;
       "mod")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ($_ =~ /^M / ) { $_ =~ s/^M //; unshift @mod, $_; } } print "@mod";'
         ;;
       "up")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ($_ =~ /^U/ ) { $_ =~ s/^U //; unshift @upd, $_; } } print "@upd";'
         ;;
       "add")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ($_ =~ /^A/ ) { $_ =~ s/^A //; unshift @add, $_; } } print "@add";'
         ;;
       "new")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ( $_ =~ /^\?/ ) { $_ =~ s/^\? //; unshift @ukn, $_; } } print "@ukn";'
         ;;
       "del")
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ( $_ =~ /^\R/ ) { $_ =~ s/^\R //; unshift @del, $_; } } print "@del";'
         ;;
       *)
         # full
         ($CVSBIN $CVSOPTS 2>/dev/null) | perl -e 'while (<>) { if ( $_ =~ /^RCS/ ) { <>; <>; <>; $f = <>; $f =~ s/^M //; unshift @con, $f; } elsif ( $_ =~ /^\?/ ) { $_ =~ s/^\? //; unshift @ukn, $_; } elsif ($_ =~ /^M/ ) { $_ =~ s/^M //; unshift @mod, $_; } elsif ($_ =~ /^A/ ) { $_ =~ s/^A //; unshift @add, $_; } elsif ($_ =~ /^R/ ) { $_ =~ s/^R //; unshift @del, $_; } elsif ($_ =~ /^U/ ) { $_ =~ s/^U //; unshift @upd, $_; } } print "--[ CONFLICTS ]--\n @con\n"; print "--[ Locally modified ]--\n @mod\n"; print "--[ Updated in repository ]--\n @upd\n"; print "--[ Newly Added ]--\n @add\n"; print "--[ Removed ]--\n @del\n"; print "--[ Nothing known about ]--\n @ukn\n";'
       ;;
    esac
}
# }}}

# ------------------------------------------------------------------------
# Take a symlink and turn it into a local copy
# here {{{
function here
{
   if [ -h $1 ]; then
      # file we're editing is a symbolic link.  Break it.
      target=$(readlink $1)
      if [ -r $target ]; then
         rm $1
         cp -pi $target $1
      else
         echo "Refusing to remove dangling symlink."
      fi
   else
      echo "Already here. Nothing to do."
   fi
}
# }}}

# ------------------------------------------------------------------------
# Recursive grep that only looks at source files, it's a little more
# descriptive than grep --color, but it's also a little more likely to
# break if you're tree is complicated.
# findit {{{
function findit
{
    if [ "$TERM" = "xterm" ]; then
        find . -name "*.[cCsShH]" -type f -not -path "*CVS*" -not -path "*include*" -exec grep -n "$1" {} \; -print | perl -e 'while (<>) { chomp $_; if ($_ =~ /^[0-9]+:/) { $line = $_; $line =~ s/^([0-9]+:)(.*)$/\033[32;40m\1\033[0m\2/; push @line, $line; } else { @line = reverse @line ; $file = $_; while ( $thisline = pop @line ) { print "\033[33;40m$file: \033[0m$thisline\n" } } }'
    else

        find . -name "*.[cCsShH]" -type f -not -path "*CVS*" -not -path "*include*" -exec grep -n "$1" {} \; -print | perl -e 'while (<>) { chomp $_; if ($_ =~ /^[0-9]+:/) { push @line, $_; } else { @line = reverse @line ; $file = $_; while ( $thisline = pop @line ) { print "$file: $thisline\n" } } }'
    fi
}
# }}}

# ------------------------------------------------------------------------
# find and recover aborted vim sessions
# findlost {{{
function findlost
{
    # find lost vim sessions.
    for i in `find $1 -name ".*sw?"`
    do
        filename=$(basename $i)
        ${EDITOR:-gvim} -r $(dirname $i)/$(echo $filename | awk -F. '{ print $2 "." $3 }')
        rm -f $(dirname $i)/$(echo $filename | awk -F. '{ print "." $2 "." $3 "." $4}')
    done
}
# }}}

# ------------------------------------------------------------------------
# regular expression copy
# recp {{{
function recp
{
    if [ $# == 0 ]
    then
        printf "\nUsage:\n\trecp <regexp> <file pattern>\n\n"
    else
        regexp=$1

        if [ -a $regexp ]
        then
            # this is probably an unpleasant sanity check, but I want it in
            # here for now.
            printf "\nUsage:\n\trecp <regexp> <file pattern>\n\n"
        else
            shift # remove the regexp
            for i in "$@"
            do
                newfile=`echo -n $i | sed "$regexp" - `
                cp --backup "$i" "$newfile"
            done
        fi
    fi
}
# }}}

# ------------------------------------------------------------------------
# regular expression move/rename
# remv {{{
function remv
{
    if [ $# == 0 ]
    then
        printf "\nUsage:\n\tremv <regexp> <file pattern>\n\n"
    else
        regexp=$1

        if [ -a $regexp ]
        then
            # this is probably an unpleasant sanity check, but I want it in
            # here for now.
            printf "\nUsage:\n\tremv <regexp> <file pattern>\n\n"
        else
            shift # remove the regexp
            for i in "$@"
            do
                newfile=`echo -n $i | sed "$regexp" - `
                mv -i "$i" "$newfile"
            done
        fi
    fi
}
# }}}

# ------------------------------------------------------------------------
# apply a patch if it would apply cleanly, otherwise just report what would
# have happened.
# pif {{{
function pif
{
   jjm_pif_del=0
   unset jjm_pif_file
   unset jjm_pif_opts
   OPTIND=1
   while getopts "dp:o:" options; do
      case $options in
         d ) jjm_pif_del=1 ;;
         o ) jjm_pif_opts=$OPTARG ;;
         p ) jjm_pif_file=$OPTARG ;;
         * ) echo "All you get is -d, and that means throw everything out";;
      esac
   done
   if [ -z "${jjm_pif_file}" ]
   then
      echo "pif -p <patch> [<patch-options>]\n"
   else
      patch --dry-run ${jjm_pif_opts} < ${jjm_pif_file}
      if [ $? -eq 0 ]
      then
         patch ${jjm_pif_opts} < ${jjm_pif_file}
         if [ ${jjm_pif_del} -eq 1 ]
         then
            rm --verbose ${jjm_pif_file}
         fi
      fi
   fi
}
# }}}

# ------------------------------------------------------------------------
# rip around and find anything that looks like a backup, scratch or aborted
# file and toss it.  I wrote this because I used to love the purge command on
# VMS.  Don't use this.  And if you do, don't say you weren't warned.
# purge {{{
function purge
{
   find . -regex '.*~[0-9][0-9]*~' -exec rm {} \;
   find . -name '.#*.[0-9][0-9]*' -exec rm {} \;
}
# }}}

# ------------------------------------------------------------------------
# I'm terrible at remembering which fields come where in cscope, but I love
# the command line interface.
# csfind {{{
function csfind
{
   # The search pattern
   unset jjm_pattern
   # By default assume we're looking up a symbol
   jjm_search_field=0
   # reset OPTIND
   OPTIND=1

   while getopts "c:d:e:f:i:r:s:t:h" options; do
      case $options in
         c ) jjm_search_field=2; jjm_pattern=$OPTARG ;;  # called by
         d ) jjm_search_field=1; jjm_pattern=$OPTARG ;;  # function definition
         e ) jjm_search_field=6; jjm_pattern=$OPTARG ;;  # egrep
         f ) jjm_search_field=7; jjm_pattern=$OPTARG ;;  # file
         i ) jjm_search_field=8; jjm_pattern=$OPTARG ;;  # including this file
         r ) jjm_search_field=3; jjm_pattern=$OPTARG ;;  # caller
         s ) jjm_search_field=0; jjm_pattern=$OPTARG ;;  # C symbol
         t ) jjm_search_field=4; jjm_pattern=$OPTARG ;;  # text string
         * ) echo "$0 <search type> <search pattern>"
             echo
             echo "  -c <pattern>   Find functions called by this function"
             echo "  -d <pattern>   Find this function definition"
             echo "  -e <pattern>   Find this egrep pattern"
             echo "  -f <pattern>   Find this file"
             echo "  -i <pattern>   Find files #include-ing this file"
             echo "  -r <pattern>   Find functions calling this function"
             echo "  -s <pattern>   Find this C symbol"
             echo "  -t <pattern>   Fund this text string"
             return 1
             ;;
      esac
   done
   if [ -z "${jjm_pattern}" ]; then
      if [ -z "$1" ]; then
         echo "You must specify at pattern to search for."
         echo "$0 <search type> <search pattern>"
         echo
         echo "  -c <pattern>   Find functions called by this function"
         echo "  -d <pattern>   Find this function definition"
         echo "  -e <pattern>   Find this egrep pattern"
         echo "  -f <pattern>   Find this file"
         echo "  -i <pattern>   Find files #include-ing this file"
         echo "  -r <pattern>   Find functions calling this function"
         echo "  -s <pattern>   Find this C symbol"
         echo "  -t <pattern>   Fund this text string"
         return 1
      else
         jjm_pattern=$1
      fi
   fi
   cscope -v -d -L -${jjm_search_field} ${jjm_pattern}
}
# }}}

# ------------------------------------------------------------------------
# I can't believe I haven't done something like this before.  Just explode
# an rpm into the current directory.
# unrpm {{{
function unrpm
{
   # first, create a subdirectory where we can extract the whole horrid
   # mess.  I suppose a future option would be to take a parameter to
   # specify where this directory should be.  Come to think of it, another
   # nice option might be to leave you in the extracted directory.
   jjm_rpm=$1
   shift
   jjm_dir=$(echo ${jjm_rpm} | sed '{ s/.rpm//i }')
   echo DIR: ${jjm_dir}

   mkdir -p ${jjm_dir}
   cd ${jjm_dir}
   rpm2cpio ../${jjm_rpm} | cpio -idmv
   cd -
}
# }}}

# ------------------------------------------------------------------------
#
# Tell me what the heck I'm likely to find inside the silly blob of crap.
# rpminfo {{{
function rpminfo
{
   rpm --query -i -p $1
}
# }}}

# ------------------------------------------------------------------------
#
# Using PPAs a lot, I'm frequently (enough) needing to add a new OpenPGP key
# to my apt keyring and I have some kind of mental block around the syntax, so
# I wrote this function.  Basically it's for the weak-minded.
# getkey {{{
function getkey
{
   sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $1
}
# }}}

# ------------------------------------------------------------------------
#
# curl-based dictionary lookups from the command line.  The suggested
# interface is by calling def() but there's no reason why you can't call d()
# or m() directly
# def {{{
function d
{
   curl --stderr /dev/null dict://dict.org/d:$1 | awk '$1 == "552" { exit 1 } $1 == "151" { getline ; while ( $1 != "250" ) { print ; getline } next } '
}

function m
{
   curl --stderr /dev/null dict://dict.org/m:$1 | awk '$1 == "152" { while ( $1 != "250" ) { print ; getline } next } '
}

function def
{
   d $1
   if [ $? -gt 0 ]
   then
      m $1
   fi
}
# }}}

# vim: tw=78 ts=3 sw=3 et nowrap ft=sh
