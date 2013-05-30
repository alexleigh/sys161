#!/bin/sh

#
# installit.sh - install a System/161 binary
#
# usage: installit.sh installdir prog version [with-suffix]
#

INSTALLDIR="$1"
PROG="$2"
VERSION="$3"

if [ "x$4" = "xwith-suffix" ]; then
    SUFFIX=1
elif [ "x$4" = x ]; then
    SUFFIX=0
else
    echo "Usage: $0 installdir prog version [with-suffix]" 1>&2
    exit 1
fi

############################################################
#
# Cross-check arguments
#

if [ ! -d "$INSTALLDIR" ]; then
    # should already have been created
    echo "$0: Invalid/missing installation directory $INSTALLDIR" 1>&2
    exit 1
fi

case "$PROG" in
    sys161|trace161|stat161|hub161) ;;
    *)
        echo "$0: Invalid program $PROG" 1>&2
        exit 1
        ;;
esac

case "$VERSION" in
    devel) ;; # devel version out of cvs
    200[2-9][01][0-9][0-3][0-9]) ;; # snap
    [0-9].99.[0-9][0-9]) ;; # devel release
    [0-9].[0-9]|[0-9].[0-9][0-9]) ;; # release
    *)
        echo "$0: Invalid version $VERSION" 1>&2
        exit 1
        ;;
esac

############################################################
#
# Do it.
#

if [ $SUFFIX = 1 ]; then
    PROGPATH="${INSTALLDIR}/${PROG}-${VERSION}"
else
    PROGPATH="${INSTALLDIR}/${PROG}"
fi

#
# Copy the file.
#
cp "${PROG}" "${PROGPATH}.new" || exit 1
chmod 755 "${PROGPATH}.new"

#
# We might be installing the same version a second time, particularly
# if the version is "devel". Move the old one out of the way to avoid
# ETXTBUSY on some systems if it's running. But suppress any errors.
#
mv -f "${PROGPATH}" "${PROGPATH}.old" >/dev/null 2>&1

#
# Put the new one in place.
#
mv -f "${PROGPATH}.new" "${PROGPATH}" || exit 1

#
# Remove the old one.
#
rm -f "${PROGPATH}.old" >/dev/null 2>&1

#
# Update the symbolic links
#
if [ $SUFFIX = 1 ]; then
    ln -sf "${PROG}-${VERSION}" "${INSTALLDIR}/${PROG}" || exit 1
fi
