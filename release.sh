#!/bin/bash
VERSION=`../jvgrep --help 2>&1 | grep ^Version | sed 's/Version //' 2> /dev/null`
AUTHOR='mattn <mattn.jp@gmail.com>'
SERIES=1
PACKAGE=jvgrep
Ubuntus=('quantal' 'raring' 'saucy')
LPUSER=mattn
WORKDIR=/tmp/launchpad

MYDIR=`pwd`

rm -rf $WORKDIR
cd ..
make dist

for distro in "${Ubuntus[@]}"
do
  cd $MYDIR
  mkdir $WORKDIR
  cp ../$PACKAGE-$VERSION.tar.gz $WORKDIR/${PACKAGE}_$VERSION.orig.tar.gz
  tar xzf ../$PACKAGE-$VERSION.tar.gz -C $WORKDIR
  echo $VERSION
  cd $MYDIR
  debchange -b --newversion ${VERSION}-${SERIES}${distro} --distribution $distro "backport to dist ${distro}"
  cp -r ../debian $WORKDIR/${PACKAGE}-$VERSION/.
  cd $WORKDIR/${PACKAGE}-$VERSION/
  #debuild -k0x08ACFD38 -S -sa
  debuild -k0x11A0D80C -S -sa
  dput -f ppa:$LPUSER/$PACKAGE $WORKDIR/${PACKAGE}_${VERSION}-${SERIES}${distro}_source.changes
  rm -rf $WORKDIR
done
