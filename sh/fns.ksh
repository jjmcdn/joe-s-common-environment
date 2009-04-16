# ========================================================================
#  $Id: fns.ksh,v 1.1.1.1 2007/06/14 14:32:38 joe Exp $
#  $Log: fns.ksh,v $
#  Revision 1.1.1.1  2007/06/14 14:32:38  joe
#  Initial revision
#
#
# Functions that are for some reason ksh-specific.
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

# ------------------------------------------------------------------------
# Because ksh doesn't have bash's precmd
# xname {{{
function xname
{
   echo -n "\033]0; $1 \007"
}
# }}}

# vim: tw=78 ts=3 sw=3 et nowrap ft=sh
