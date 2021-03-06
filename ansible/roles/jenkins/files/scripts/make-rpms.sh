#!/bin/sh

# Usage: make-rpms.sh <distro>

set -xe

test "x$(id -un)" = "xjenkins"
test -n "$1"

case "$1" in
  epel-6-i386|epel-6-x86_64|epel-7-x86_64)
    DIST="$1"
    RPMBUILD="${WORKSPACE}/rpmbuild"
  ;;

  *)
    echo "unknown distro $DIST"
    exit 1
  ;;
esac

# This file, as well as $TARBALL and collectd.spec, comes from jenkins'
# upstream job, using the "copy artifact plugin".
. "${WORKSPACE}/env.sh"

test -n "$COLLECTD_BUILD"
test -n "$GIT_BRANCH"
test -n "$TARBALL"
test -f "${WORKSPACE}/${TARBALL}"
test -f "${WORKSPACE}/collectd.spec"
test -d "/var/cache/mock/$DIST"

BRANCH=$(basename $GIT_BRANCH)
PKGDIR="/srv/build_artifacts/rpm"

rm -fr "$RPMBUILD"
for dir in BUILD BUILDROOT RPMS SOURCES SPECS SRPMS; do
  mkdir -p "$RPMBUILD/$dir"
done

cp -f "${WORKSPACE}/${TARBALL}" "$RPMBUILD/SOURCES/"
cp -f "${WORKSPACE}/collectd.spec" "$RPMBUILD/SPECS/"

sed -ri "s/^(Version:\s+).+/\1$COLLECTD_BUILD/" "$RPMBUILD/SPECS/collectd.spec"
sed -ri "s/^(Source:\s+).+/\1$TARBALL/" "$RPMBUILD/SPECS/collectd.spec"

echo "%_topdir $RPMBUILD/" > "$WORKSPACE/.rpmmacros"
HOME="$WORKSPACE" rpmbuild -bs "$RPMBUILD/SPECS/collectd.spec"

RESULTDIR="$PKGDIR/$BRANCH/$DIST"

rm -fr "$RESULTDIR"
mkdir -p "$RESULTDIR"

mock --verbose --cleanup-after --rpmbuild_timeout=600 -r "$DIST" --rebuild $RPMBUILD/SRPMS/collectd-${COLLECTD_BUILD}-*.src.rpm --resultdir="$RESULTDIR"

rpm --addsign $RESULTDIR/*.rpm

cat > "${WORKSPACE}/s3repo.sh" << EOF
BRANCH=$BRANCH
COLLECTD_BUILD=$COLLECTD_BUILD
DIST=$DIST
PKGDIR=$PKGDIR
EOF

