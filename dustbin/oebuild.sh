#!/bin/bash

# Defaults {{{
oeb_dialog=$(which dialog)
oeb_diag_opts="--no-kill --keep-window --no-shadow"
oeb_logfile="./oe-build.log"
oeb_build_env="./oe-init-build-env"
oeb_build_dir="."
oeb_temp=$(mktemp)
unset oeb_bitbake
unset oeb_time
unset oeb_target
# }}}

# Helper functions
# {{{
function dump_help
{
    echo Generic help text will go here.  Right now I\'ve got
    echo no help for you.  Better luck next time.
}
# }}}

# main
# argument processing {{{
while getopts "b:d:e:hst:l:" option; do
    case $option in
        b ) oeb_dialog="$OPTARG"
            ;;
        d ) oeb_build_dir="$OPTARG"
            if [ \! -d "${oeb_build_dir}" ]
            then
                mkdir -p ${oeb_build_dir}
            fi
            oeb_logfile="${oeb_build_dir}/${oeb_logfile}"
            ;;
        e ) oeb_build_env="$OPTARG"
            ;;
        h ) dump_help
            exit 1
            ;;
        l ) oeb_logfile="${oeb_build_dir}/$OPTARG"
            ;;
        t ) oeb_target="$OPTARG"
            ;;
        s ) oeb_time="time"
            ;;
        * ) dump_help
            exit 2
            ;;
    esac
done

if [ -z "${oeb_dialog}" ]
then
    echo Unable to find a usable dialog binary in your path.
    echo You can try to point me at one with something like:
    echo
    echo     -d /path/to/bin/dialog
    echo
    echo if you haven\'t already.  If you have, sorry, but I
    echo cannot help you until you install a usable dialog.
    exit 3
fi

# Strip away any non-option arguments
while [[ $OPTIND > 0 ]]
do
    let OPTIND-=1
    echo $*
    shift
done
# }}}

# Set up the OE build environment, passing along any non-option arguments,
# operating on the assumption that anything else passed on the command line was
# something you would have passed as an argument to oe-init-build-env
pushd $(readlink -f $(dirname ${oeb_build_env})) 
oeb_build_dir=$(readlink -f $(dirname ${oeb_build_dir}))
# And running this through tee causes strangeness with setting the environment
# variables.  That kind of sucks, but we'll still send the output to the display
# in case someone cares about it.
source ${oeb_build_env} ${oeb_build_dir} $@ &>${oeb_logfile}
cat ${oeb_logfile} | \
    ${oeb_dialog} ${oeb_diag_opts} \
    --programbox "Configuring OE Build Environment" 20 76

# Did you specify a target on the command line or do we need to ask you to
# specify one?
# {{{
while [ -z "${oeb_target}" ]
do
    # We didn't find a target on the command line, so let's present you with a
    # menu of likely candidates and give you the option to specify your own.
    ${oeb_dialog} ${oeb_diag_opts} \
        --menu "What target?" 20 76 16 \
        $(egrep "^ +[a-z-]+$" ${oeb_logfile} | awk '{ print $1 " " "-" }') \
        "Other" "-" 2>${oeb_temp}

    oeb_target=$(cat ${oeb_temp})

    if [ "${oeb_target}" = "Other" ]
    then
        ${oeb_dialog} ${oeb_diag_opts} \
            --inputbox "Target name?" 8 76 " " \
            2>${oeb_temp}
        oeb_target=$(cat ${oeb_temp})
    fi
done
# }}}

# Do the build. {{{
oeb_bitbake=$(which bitbake)
if [ -z "${oeb_bitbake}" ]
then
    ${oeb_dialog} \
        --infobox "Unable to find bitbake, I don't know what you're \
        going to do now, but I'm leaving.  The PATH was $PATH" 20 76
    exit 128
fi

if [ -z "${oeb_time}" ]
then
    coproc bitbake ${oeb_bitbake} -k ${oeb_target} &>${oeb_logfile}
else
    coproc bitbake ${oeb_time} ${oeb_bitbake} -k ${oeb_target} &>${oeb_logfile}
fi

oeb_complete=0
while (( oeb_complete=100 ))
do
    eval let oeb_complete=$(grep "NOTE: Running " ${oeb_logfile} | \
        tail -1 | awk '{ print "(" $4 "*100/" $6 "*100)/100" }') 2>/dev/null
    echo $oeb_complete
    sleep 1
done | \
    ${oeb_dialog} \
    --begin 1 1 \
    --tailboxbg ${oeb_logfile} 15 76 \
    --and-widget \
    --begin 16 1 \
    --gauge "Build progress: ${oeb_target}" 6 76

${oeb_dialog} \
    "Build ${oeb_target} complete.  Logs are available in ${oeb_logfile}." \
    20 76
rm -f ${oeb_temp}
# }}}
# vi:ft=sh:ts=4:sw=4:expandtab:
