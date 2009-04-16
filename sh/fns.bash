# ========================================================================
#  $Id: fns.bash,v 1.1.1.1 2007/06/14 14:32:38 joe Exp $
#  $Log: fns.bash,v $
#  Revision 1.1.1.1  2007/06/14 14:32:38  joe
#  Initial revision
#
#
# Functions that are for some reason bash-specific.
# ========================================================================

# Read in work-specific functions, if any
if [ ${HOME}/.fns.wrs ]
then
   . ${HOME}/.fns.wrs
fi

# And add in our semi-portable shell functions
if [ ${HOME}/.fns.sh ]
then
   . ${HOME}/.fns.sh
fi

# These are all for my custom bash prompt.  The goal is to produce a prompt
# which changes colours depending on the return code of the last command and
# which displays the first and last bits of your path and squeezes out the
# middle assuming that you're more interested in where you started and where you
# currently are than the whole path on how you got there.
#
# The prompt I used to use all the time for this was:
#
# PS1="\$(retcol)[`date +%H:%M`]\$(fixedlenpath)\033[0m\$(mach) "
#
# {{{
# retcode {{{
# displays '\u@\h [\w]# ' in green if the last command exited successfully, red
# otherwise
function retcode ()
{
    val=$?

    if [ ${val} -eq 0 ]; then
        printf "\033[0;32;47m\u@\h [\w]#\033[0m "
    else
        printf "\033[0;31;47m\u@\h [\w]#\033[0m "
    fi
    return ${val}
}
# }}}

# retcol {{{
# displays the return code of the last command in the prompt if it was non-zero
function retcol ()
{
    val=$?

    if [ ${val} -eq 0 ]; then
        printf "\033[1;30;47m"
    else
        printf "\033[1;31;47m[${val}]"
    fi
    return ${val}
}
# }}}

# mach {{{
# change the colour of the prompt depending on the name of the machine where the
# shell is running.  Used for another visual cue of where you are when you have
# a pile of machines with very similar \h values.
function mach ()
{
    val=`hostname`

    case "$val" in
       yow-jmacdona-d1 )   printf "\033[1;37;40m]\033[0m" ;;
       yow-jmacdona-l1 )   printf "\033[1;37;40m]\033[0m" ;;
       yow-build06-lx )    printf "\033[1;35;40m]\033[0m" ;;
       yow-build07-lx )    printf "\033[1;34;40m]\033[0m" ;;
       yow-lpgnfs-01 )     printf "\033[1;33;40m]\033[0m" ;;
       yow-* )             printf "\033[1;30;47m]\033[0m" ;;
       * )                 printf "\033[0;30;47m]\033[0m" ;;
    esac
}
# }}}

# fixedlenpath {{{
# leave the front and the back of your current path and squeeze out the middle
# section so only a total of pwd_length characters are ever displayed.
function fixedlenpath
{
    val=$?
    #   How many characters of the $PWD should be kept
    local pwd_length=20
    if [ $(echo -n $PWD | wc -c | tr -d " ") -gt $pwd_length ]
    then
        #newPWD="$(echo -n $PWD | sed -e "s/.*\(.\{$pwd_length\}\)/\1/")"
        newPWD="$(echo -n $PWD | perl -e '$path = <>; $leader = substr($path, 0, 10); $trailer = substr($path, -10, 10); print "$leader...$trailer";')"
    else
        newPWD="$(echo -n $PWD)"
    fi
    echo $newPWD | perl -e '$path = <>; if ($path =~ $ENV{HOME}) { $path =~ s/$ENV{HOME}/\~/; print $path; } else { print $path; }'
    return ${val}
}
# }}}
# }}}

# cscopetags {{{
# This tends to be more useful when you're keeping one, largely static source
# tree around and needing to do searches through it.  I used it a lot in my last
# job, almost not at all now since it's just as easy to use my cstags alias,
# which only creates local databases since they aren't really all that useful
# for me to keep around.  If you want something like it, this is my current
# alias:
#
# alias cstags="find . -name \"*.[cCsShH]\" > cscope.files"
#
function cscopetags ()
{
    # cscopetags `pwd` /home/joe/.cscope/cscope.out
    pushd /tmp
    find $1 -name "*.[cChHSs]" -type f -not -path "*CVS*" > cscope.files
    cscope -b -u -k -f $2
    export CSCOPE_DB=$2
    mv cscope.files $1
    popd
    cscope -b -u -k
}
# }}}

# vim: tw=78 ts=3 sw=3 et nowrap ft=sh
