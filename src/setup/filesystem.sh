#!/bin/sh
#
# Defines a structure which can be used by all apps in this snap
# Sets up Apache
# Sets up PHP-FPM
#
VAR=$SNAP_DATA/var
VAR_RUN=$VAR/run
VAR_TMP=$VAR/tmp
VAR_LOG=$VAR/log

# Wait if the config is being created
while [ -f $VAR_TMP/apache_php_config_lock ]; do
	sleep 1
done

# @param $1 String to look for
# @param $2 String to replace with
# @param $3 Files to perform action on
search_and_replace() {
	{ rm $3 && awk '{gsub("'"${1}"'", "'"${2}"'", $0); print}'> $3; } < $3
}

if [ ! -f $VAR/apache_php_config_done ]; then
	# Setup writable partition
	if [ ! -d "$VAR_RUN" ] || [ ! -d "$VAR_TMP" ] || [ ! -d "$VAR_LOG" ]; then
		echo "Configuring writeable partition..."
		mkdir -p $VAR_RUN
		mkdir -p $VAR_TMP
		mkdir -p $VAR_LOG
	fi
	touch $VAR_TMP/apache_php_config_lock

	# Calculates config values for PHP-FPM and Apache
	. $SNAP/setup/hw_rating.sh

	RO_PHP_FOLDER=$SNAP/php
	RW_PHP_FOLDER=$SNAP_DATA/php
	PHP_USER_CONF=$RW_PHP_FOLDER/lib/php.conf.d
	PHP_FPM_USER_CONF=$RW_PHP_FOLDER/etc/php-fpm.d

	# Setup PHP
	if [ ! -d "$PHP_USER_CONF" ]; then
		echo "Configuring PHP-FPM..."
		mkdir -p $PHP_USER_CONF
		mkdir -p $PHP_FPM_USER_CONF
		touch $VAR_LOG/php-fpm.log
		cp $RO_PHP_FOLDER/userconfigs/platform.conf $PHP_FPM_USER_CONF
		cp $RO_PHP_FOLDER/userconfigs/custom.conf $PHP_FPM_USER_CONF
		search_and_replace "pm.max_children = XXXX" "pm.max_children = "${PHP_MAX_CHILDREN} $PHP_FPM_USER_CONF"/platform.conf"
		search_and_replace "pm.start_servers = XXXX" "pm.start_servers = "${PHP_START_SERVERS} $PHP_FPM_USER_CONF"/platform.conf"
		search_and_replace "pm.min_spare_servers = XXXX" "pm.min_spare_servers = "${PHP_MIN_SPARE_SERVERS} $PHP_FPM_USER_CONF"/platform.conf"
		search_and_replace "pm.max_spare_servers = XXXX" "pm.max_spare_servers = "${PHP_MAX_SPARE_SERVERS} $PHP_FPM_USER_CONF"/platform.conf"
		search_and_replace "php_admin_value\[memory_limit\] = XXXX" "php_admin_value[memory_limit] = "${PHP_MEMORY_LIMIT_DEFAULT}"M" "$PHP_FPM_USER_CONF/platform.conf"
	fi

	# Setup Apache
	RO_APACHE_CONF_FOLDER=${SNAP}/conf
	RW_APACHE_CONF_FOLDER=${SNAP_DATA}/apache/conf
	if [ ! -d "$RW_APACHE_CONF_FOLDER" ]; then
		echo "Configuring Apache..."
		mkdir -p $RW_APACHE_CONF_FOLDER
		cp $RO_APACHE_CONF_FOLDER/userconfigs/platform.conf $RW_APACHE_CONF_FOLDER
		cp $RO_APACHE_CONF_FOLDER/userconfigs/custom.conf $RW_APACHE_CONF_FOLDER
		search_and_replace "StartServers XXXX" "StartServers "${APACHE_START_SERVERS} $RW_APACHE_CONF_FOLDER"/platform.conf"
		search_and_replace "MinSpareThreads XXXX" "MinSpareThreads "${APACHE_MIN_SPARE_THREADS} $RW_APACHE_CONF_FOLDER"/platform.conf"
		search_and_replace "MaxSpareThreads XXXX" "MaxSpareThreads "${APACHE_MAX_SPARE_THREADS} $RW_APACHE_CONF_FOLDER"/platform.conf"
		search_and_replace "ThreadsPerChild XXXX" "ThreadsPerChild "${APACHE_THREADS_PER_CHILD} $RW_APACHE_CONF_FOLDER"/platform.conf"
		search_and_replace "ServerLimit XXXX" "ServerLimit "${APACHE_SERVER_LIMIT} "$RW_APACHE_CONF_FOLDER/platform.conf"
	fi

	touch $VAR/apache_php_config_done
	rm -f $VAR_TMP/apache_php_config_lock
fi
