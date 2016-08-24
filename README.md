# Snappy ownCloud

**Note: This snap is no longer maintained. Please use the [Nextcloud snap][1] instead.**

ownCloud server packaged as a .snap for Ubuntu Core. It consists of:

- ownCloud 9.0.1
- Apache 2.4
- PHP 7
- mysql 5.7
- mDNS for network discovery


## How to install

This ownCloud .snap is available in the store for release series 16 (e.g. Ubuntu
16.04). Install via:

    $ sudo snap install owncloud


## How to use

After install, assuming you and the Ubuntu Core device are on the same network,
you should be able to reach the ownCloud installation by visiting
`<hostname>.local` in your browser. If your hostname is `localhost` or
`localhost.localdomain`, like on an Ubuntu Core device, `owncloud.local` will be
used instead.

Upon visiting the ownCloud installation for the first time, you'll be prompted
for an admin username and password. After you provide that information you'll be
logged in and able to create users, install apps, and upload files.


### Included CLI utilities

There are a few CLI utilities included:

- `owncloud.occ`:
    - ownCloud's `occ` configuration tool. Note that it requires `sudo`.
- `owncloud.mysql-client`:
    - MySQL client preconfigured to communicate with ownCloud MySQL server. This
      may be useful in case you need to migrate ownCloud installations. Note
      this it requires `sudo`.


## Where is my stuff?

- `$SNAP_DATA`:
    - Apache and MySQL logs
    - MySQL database
    - ownCloud config
    - Any ownCloud apps installed by the user
- `$SNAP_DATA/../common` (unversioned directory):
    - ownCloud data
    - ownCloud logs

[1]: https://github.com/nextcloud/nextcloud-snap
