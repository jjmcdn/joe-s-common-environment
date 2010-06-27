#!/bin/sh -e
#
# Found this script when I was looking for a way to install World of Goo on my
# AMD64 platforms.  Wickely simple, highly useful.
#
# Original forum post here:
# http://2dboy.com/forum/index.php?PHPSESSID=fcdd73260aa21b28a7194b5c39e05520&topic=1464.msg9818#msg9818

DEB_IN=$1
DEB_OUT=$2

[ -n "${DEB_OUT}" ] || DEB_OUT=`echo "$1" | sed 's/i386/amd64/'`

if [ -z "${DEB_IN}" ] || [ "${DEB_IN}" = "${DEB_OUT}" ]
then
	echo "Usage: deb-from-i386-to-amd64.sh <input.deb> [<output.deb>]"
	exit 1
fi

TMP_DIR=`mktemp -d`
dpkg-deb -x "${DEB_IN}" "${TMP_DIR}"
dpkg-deb -e "${DEB_IN}" "${TMP_DIR}/DEBIAN"
sed -i 's/i386/amd64/' "${TMP_DIR}"/DEBIAN/control
sed -i 's/Depends: /Depends: ia32-libs, /' "${TMP_DIR}"/DEBIAN/control
dpkg-deb -b "${TMP_DIR}" "${DEB_OUT}"
rm -r "${TMP_DIR}"
