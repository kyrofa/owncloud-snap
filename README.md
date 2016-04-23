# Snappy ownCloud

ownCloud server packaged as a .snap for Ubuntu Core. It consists of:

- ownCloud 9.0.1
- Apache 2.4
- PHP 7
- mysql 5.7
- mDNS for network discovery


## How to install

This ownCloud .snap is only available on Snappy Ubuntu Core 16.04. Install via:

    $ sudo snappy install owncloud


## How to use

After install, assuming you and the Ubuntu Core device are on the same network,
you should be able to reach the ownCloud installation by visiting
`owncloud.local` in your browser (note that if you change the hostname, it'll be
`<hostname>.local`).

Upon visiting the ownCloud installation for the first time, you'll be prompted
for an admin username and password. After you provide that information you'll be
logged in and able to create users, install apps, and upload files.


## Limitations

Ideally ownCloud would be able to store its raw data outside of the Snappy data
directories (e.g. on an external hard drive while installed on a raspberry pi).
However, .snaps currently do not have the ability to access the filesystem
outside of the Snappy data directories (Ubuntu Core 16.04 will include this,
it's just not done yet). As a result, the ownCloud data directory is contained
within `$SNAP_DATA`, which means it's migrated upon upgrade, which can waste
quite a bit of hard drive space. This will be improved soon.
