# Snappy ownCloud

ownCloud 8.2.2 packaged as a .snap for Ubuntu Core. It consists of:

- ownCloud 8.2.2
- Apache 2.4
- PHP 7
- mysql 5.7.10
- mDNS for network discovery


## How to install

Note that there's currently a limitation in the Snappy store that prevents
multiple uploads of the same package, even if they support different
architectures. This will be resolved soon, but until then, the package names
need to be different. So the command to install ownCloud depends on your
architecture:

- armhf (e.g. the Raspberry Pi 2):

    `sudo snappy install owncloud.kyrofa`

- amd64:

     `sudo snappy install owncloud-amd64.kyrofa`


## How to use

After install, assuming the Ubuntu Core device is on the same network as you,
you should be able to reach the ownCloud installation by using `hostname.local`.
For example, if your hostname is `foo`, you can reach ownCloud by visiting
`foo.local` in your browser. If you're using a standard Ubuntu Core image and
you haven't messed with the hostname, try `owncloud.local` (the default).

Upon visiting the ownCloud installation for the first time, you'll be prompted
for an admin username and password. After you provide that information you'll be
logged in and able to create users, install apps, and upload files.


## Limitations

Ideally ownCloud would be able to store its raw data outside of the Snappy data
directories (e.g. on an external hard drive while installed on a raspberry pi).
However, .snaps on Ubuntu Core 15.04 do not have the ability to access the
filesystem outside of the Snappy data directories (Ubuntu Core 16.04 will
include this). As a result, the ownCloud data directory is contained within the
`$SNAP_APP_DATA_PATH`, which means it's migrated upon upgrade, which can waste
quite a bit of hard drive space. A better version will be available for Ubuntu
Core 16.04.
