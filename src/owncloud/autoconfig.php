<?php

$data_path = '/var/lib/snaps/'.getenv('SNAP_FULLNAME').'/current';

$AUTOCONFIG = array(
'directory' => $data_path.'/owncloud/data',

'dbtype' => 'mysql',

'dbhost' => 'localhost:'.$data_path.'/mysql/mysql.sock',

'dbname' => 'owncloud',

'dbuser' => 'owncloud',

'dbpass' => getenv('OWNCLOUD_DATABASE_PASSWORD'),
);
