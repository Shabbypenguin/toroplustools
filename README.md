Toroplus Build Instructions
=======================
```
mkdir cm10
cd cm10
repo init -u git://github.com/CyanogenMod/android.git -b jellybean
```

Modify your `.repo/local_manifest.xml` as follows:

```xml
<?xml version="1.0" encoding="UTF-8"?>
  <manifest>
    <project name="Shabbypenguin/toroplustools.git" path="toroplustools" remote="github" revision="ics" />
  </manifest>
```

```
repo sync
vendor/cm/get-prebuilts
```

Auto Apply Patches
==================
This script will remove any topic branches named auto, then apply all patches under topic branch auto.

```
toroplustools/apply.sh
```

Build
=====
```
. build/envsetup.sh
breakfast cm_toroplus-userdebug
make -j4 bacon
```
