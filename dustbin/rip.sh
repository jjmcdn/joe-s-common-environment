#!/bin/bash

# globals {{{
unset crop
unset device
unset drc
unset mixdown
unset outdir
unset title
# }}}

# These work well for my PS3.  Screw the rest of you.  Thanks Arny.
# options {{{
standard_opts=" \
	-e x264 \
	-b 2500 \
	-a 1 \
	-E faac \
	-B 160 \
	-R 48 \
	-f mp4 \
	-level=41:me=umh \
	"
# }}}

# Internal variables, don't touch. {{{
hbcli=$(which HandBrakeCLI)
# }}}

# scan_tracks {{{
function scan_tracks
{
	local dev=$1 ; shift
	local scan=$(mktemp)
	${hbcli} -i ${dev} -t 0 2>&1 | grep '^ *+' >${scan}
	echo ${scan}
}
# }}}

# find_tracks {{{
function find_tracks
{
	local scan=$1 ; shift
	local tracks

	# jjmac: (2011.07.05)
	# I found this on one of my DVDs:
	#
	# + title 3:
	#   + Main Feature
	#   + vts 3, ttn 1, cells 0->19 (1892179 blocks)
	#   + duration: 01:43:24
	#
	# That "Main Feature" is interesting.  I don't quite know where it
	# comes from, but it would maybe be helpful as a prompt if we could
	# rely on it.
	#
	# The problem with the following sed expressions is they depend on
	# having the "main feature" text there, prefixed with a description:
	# text. That doesn't currently exist in HandBrakeCLI, which is
	# unfortunate.  I'll be hacking in my own modification for that, but
	# the chances of it being integrated are probably pretty slim.  So we
	# end up with my PPA carrying precisely one patch until the end of
	# time.
	#
	# Maybe I should just fix the sed expression...
	select track in $(egrep '^ *\+ (title|description|duration)' ${scan} \
		| sed 's/^ *+ title\(.*\):/track:\1/; $!N;s/\n.*+ description: / /; $!N;s/\n.*+ / -- /; s/^ */"/; s/$/"/' | \
		tr ' ' '.' )
	do
		if [[ -z ${track} || "${track}" = "done" ]] ; then
			break
		fi
		tracks="${tracks} ${REPLY}"
	done
	echo ${tracks}
}
# }}}

# process command line options {{{
while getopts "c:r:d:m:o:t:" option; do
	case $option in 
		c ) crop="$OPTARG" ;;
		d ) device="$OPTARG" ;;
		m ) mixdown="$OPTARG" ;;
		o ) outdir="$OPTARG" ;;
		r ) drc="$OPTARG" ;;
		t ) title="$OPTARG" ;;
	esac
done
# }}}

# main {{{
if [ -z "${hbcli}" ] ; then
	echo No HandBrakeCLI found.  I can\'t work under these conditions.
	exit 1
fi
if [ -z "${device}" ] ; then
	echo You must specify a device with the -d flag.
	exit
fi

# Now I want to create a select list of all the tracks.
scan=$(scan_tracks ${device})

echo "Select which tracks you want to rip."
tracks=$(find_tracks ${scan})
echo tracks: $tracks

# We'll assume we're putting all rips in the same directory.
if [ -z "${outdir}" ] ; then
	read -p "Output directory?" outdir
fi

for i in ${tracks}
do
	if [ -z "${title}" ] ; then
		read -p "Title?" title
	fi
	${hbcli} -i ${device} \
		-t $i \
		${standard_opts} \
		${mixdown:+-6} ${mixdown} \
		${drc:+-D} ${drc} \
		${crop:+--crop} ${crop} \
		-o "${outdir}/${title}.mp4"
done


# }}}

# vim:set tw=0 wm=0 ai wrap ts=8 sw=8 noexpandtab nolist filetype=sh:
