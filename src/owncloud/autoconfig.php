<?php

$snap_name = getenv('SNAP_NAME');
$snap_developer = getenv('SNAP_DEVELOPER');
if ($snap_developer == '') {
	$snap_developer = getenv('SNAP_ORIGIN');
}

if ($snap_developer != '') {
	$snap_name = $snap_name . '.' . $snap_developer;
}

$data_path = '/var/lib/snaps/'.$snap_name.'/current';

$AUTOCONFIG = array(
'directory' => $data_path.'/owncloud/data',

'dbtype' => 'mysql',

'dbhost' => 'localhost:'.$data_path.'/mysql/mysql.sock',

'dbname' => 'owncloud',

'dbuser' => 'owncloud',

'dbpass' => getenv('OWNCLOUD_DATABASE_PASSWORD'),
);
