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

$writable = getenv('SNAP_DATA');
$owncloud_password = trim(file_get_contents($writable . '/mysql/owncloud_password'));

$AUTOCONFIG = [
	'directory' => $data_path . '/owncloud/data',

	'dbtype' => 'mysql',

	'dbhost' => 'localhost:' . $data_path . '/mysql/mysql.sock',

	'dbname' => 'owncloud',

	'dbuser' => 'owncloud',

	'dbpass' => $owncloud_password,
];
