<?php

$snap_name = getenv('SNAP_NAME');

$data_path = '/var/snap/'.$snap_name.'/current';
$common_data_path = '/var/snap/'.$snap_name.'/common';

$AUTOCONFIG = array(
'directory' => $common_data_path.'/owncloud/data',

'dbtype' => 'mysql',

'dbhost' => 'localhost:'.$data_path.'/mysql/mysql.sock',

'dbname' => 'owncloud',

'dbuser' => 'owncloud',

'dbpass' => getenv('OWNCLOUD_DATABASE_PASSWORD'),
);
