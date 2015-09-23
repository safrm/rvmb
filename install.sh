#!/bin/sh
#Rapid Virtual Machine Builder
#web: http://safrm.net/projects/rvmb
#author: Miroslav Safr <miroslav.safr@gmail.com>
SYSCONFDIR=/etc
. appver-installer

appver_basic_scripts_test

$MKDIR_755 $BINDIR
$INSTALL_755 ./rvmb  $BINDIR
appver_update_version_and_date $BINDIR/rvmb

TARGETS=`find ./targets -type f`
$MKDIR_755 $SYSCONFDIR/rvmb/targets
$INSTALL_755 $TARGETS $SYSCONFDIR/rvmb/targets

$MKDIR_755 $COMPLETION_DIR
$INSTALL_755 ./rvmb_completion  $COMPLETION_DIR/

