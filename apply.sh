#!/bin/bash

unset SUCCESS
on_exit() {
  if [ -z "$SUCCESS" ]; then
    echo "ERROR: $0 failed.  Please fix the above error."
    exit 1
  else
    echo "SUCCESS: $0 has completed."
    exit 0
  fi
}
trap on_exit EXIT

http_patch() {
  PATCHNAME=$(basename $1)
  curl -L -o $PATCHNAME -O -L $1
  cat $PATCHNAME |patch -p1
  rm $PATCHNAME
}

# Change directory verbose
cdv() {
  echo
  echo "*****************************"
  echo "Current Directory: $1"
  echo "*****************************"
  cd $BASEDIR/$1
}

# Change back to base directory
cdb() {
  cd $BASEDIR
}

# Sanity check
if [ -d ../.repo ]; then
  cd ..
fi
if [ ! -d .repo ]; then
  echo "ERROR: Must run this script from the base of the repo."
  SUCCESS=true
  exit 255
fi

# Save Base Directory
BASEDIR=$(pwd)

# Abandon auto topic branch
repo abandon auto
set -e

################ Apply Patches Below ####################

repo start auto packages/apps/Phone
echo "### fix ringtones"
cdv packages/apps/Phone
git reset --hard
git fetch http://review.cyanogenmod.com/CyanogenMod/android_packages_apps_Phone refs/changes/12/21512/1 && git cherry-pick FETCH_HEAD
cdb

repo start auto packages/apps/Phone
echo "### EOS LTE toggle"
cdv packages/apps/Phone
git reset --hard
git fetch git://git.teameos.org/eos/platform/packages/apps/Phone refs/changes/52/952/2 && git cherry-pick FETCH_HEAD
cdb

repo start auto packages/apps/Phone
echo "### EOS - Enable LTE only mode"
cdv packages/apps/Phone
git reset --hard
git fetch git://git.teameos.org/eos/platform/packages/apps/Phone refs/changes/63/963/1 && git cherry-pick FETCH_HEAD
cdb

repo start auto kernel/samsung/tuna
echo "### Fix toroplus compass 180 degree bug"
cdv kernel/samsung/tuna
git reset --hard
git fetch http://r.cyanogenmod.com/CyanogenMod/android_kernel_samsung_tuna refs/changes/05/17105/1 && git cherry-pick FETCH_HEAD
cdb

##### SUCCESS ####
SUCCESS=true
exit 0
