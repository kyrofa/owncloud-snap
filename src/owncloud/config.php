<?php

$CONFIG = array(
/**
 * Use the ``apps_paths`` parameter to set the location of the Apps directory,
 * which should be scanned for available apps, and where user-specific apps
 * should be installed from the Apps store. The ``path`` defines the absolute
 * file system path to the app folder. The key ``url`` defines the HTTP web path
 * to that folder, starting from the ownCloud web root. The key ``writable``
 * indicates if a web server can write files to that folder.
 */
'apps_paths' => array(
	array(
		'path'=> '/var/lib/snaps/'.getenv('SNAP_FULLNAME').'/current/owncloud/apps',
		'url' => '/apps',
		'writable' => true,
	),
),

/**
 * Database types that are supported for installation.
 *
 * Available:
 * 	- sqlite (SQLite3 - Not in Enterprise Edition)
 * 	- mysql (MySQL)
 * 	- pgsql (PostgreSQL)
 * 	- oci (Oracle - Enterprise Edition Only)
 */
'supportedDatabases' => array(
	'mysql',
),
);
