#!/bin/sh
#Rapid VM builder - http://safrm.net/projects/rvmb
#author: Miroslav Safr <miroslav.safr@gmail.com>
BINDIR=/usr/bin
COMPLETION_DIR=/etc/bash_completion.d
SYSCONFDIR=/etc
MANDIR=/usr/share/man

#root check
USERID=`id -u`
[ $USERID -eq "0" ] || {
    echo "I cannot continue, you should be root or run it with sudo!"
    exit 0
}

#automatic version
if command -v appver 1>/dev/null 2>&1; then . appver; else APP_SHORT_VERSION=NA ; APP_FULL_VERSION_TAG=NA ; APP_BUILD_DATE=`date +'%Y%m%d_%H%M'`; fi
#test
for TEST in $(  grep -r -l -h --exclude-dir=.git --exclude-dir=test "#\!/bin/sh" . )
do
    sh -n $TEST
    if  [ $? != 0 ]; then
        echo "syntax error in $TEST, exiting.."
        exit 1
    fi
done

#update documentation
jss-docs-update ./doc

mkdir -p -m 0755 $BINDIR
install -m 0777 -v ./rvmb  $BINDIR/
sed -i".bkp" "1,/^VERSION=/s/^VERSION=.*/VERSION=$APP_FULL_VERSION_TAG/" $BINDIR/rvmb && rm -f $BINDIR/rvmb.bkp
sed -i".bkp" "1,/^VERSION_DATE=/s/^VERSION_DATE=.*/VERSION_DATE=$APP_BUILD_DATE/" $BINDIR/rvmb && rm -f $BINDIR/rvmb.bkp


TARGETS=`find ./targets -type f`
mkdir -p -m 0755 $SYSCONFDIR/rvmb/targets
install -m 755 $TARGETS $SYSCONFDIR/rvmb/targets

mkdir -p -m 0755 $COMPLETION_DIR
install -m 0777 -v ./rvmb_completion  $COMPLETION_DIR/

mkdir -p -m 0644 $MANDIR/man1
install -m 644 ./doc/manpages/rvmb.1 $MANDIR/man1

