#!/bin/sh
##################################################################
# Script to determine the best
# - Apache MPM_event
# - PHP-FPM
# settings when using ownCloud
#
# WARNING: Currently only works on Linux
#
# Copyright 2016 Olivier Paroz (owncloud@oparoz.com)
# Licence GPL 3.0
##################################################################
validate_params() {
	if [ $1 -gt 0 ]; then
		echo $1
	else
		echo $2
	fi
}

echo "##################################################################"
echo "# HARDWARE"
echo "##################################################################"
ARCH=$(uname -i)
IS_ARM=$(echo $ARCH | awk '{print substr($0,0,3)}')

# CPU Speed
if [ $IS_ARM = 'arm' ]; then
	CPU_CORES=$(awk '/^processor/ {count++} END{print count}' /proc/cpuinfo)
	CPU_SPEED=$(( `cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq` /1000 ))
	BOGOMIPS=$(awk '/^BogoMIPS/ {printf "%d", $3;exit}' /proc/cpuinfo)
else
	CPU_CORES=$(awk '/^cpu cores/ {print $4;exit}' /proc/cpuinfo)
	CPU_SPEED=$(awk '/^cpu MHz/ {printf "%d", $4;exit}' /proc/cpuinfo)
	BOGOMIPS=$(awk '/^bogomips/ {printf "%d", $3;exit}' /proc/cpuinfo)
fi

# Memory in MB
MEM_TOTAL=$(awk '/MemTotal/ {printf "%d", $2/1024}' /proc/meminfo)

echo "Total memory $MEM_TOTAL"
echo "Number of CPU cores $CPU_CORES"
echo "CPU speed $CPU_SPEED"
echo "BogoMIPS $BOGOMIPS"

echo "##################################################################"
echo "# PHP-FPM"
echo "##################################################################"
# Determined in advance via "ps -ylC php-fpm --sort:rss"
PHP_PROCESS_SIZE=65

# Amount of RAM PHP can use
PHP_AVAIL_RAM=$(awk "BEGIN {printf "'"%d"'", $MEM_TOTAL * 0.6 }")

# Processes available at startup and idling
PHP_MAX_SPARE_SERVERS=${CPU_CORES}
PHP_MAX_SPARE_SERVERS_DEFAULT=3
VALUE=$(validate_params ${PHP_MAX_SPARE_SERVERS} ${PHP_MAX_SPARE_SERVERS_DEFAULT})
echo "The MAXIMUM number of idle PHP-FPM processes $VALUE"

PHP_MIN_SPARE_SERVERS_DEFAULT=1
PHP_MIN_SPARE_SERVERS=$(validate_params $(( (${PHP_MAX_SPARE_SERVERS} / 4) + 1 )) ${PHP_MIN_SPARE_SERVERS_DEFAULT})
echo "The MINIMUM number of idle PHP-FPM processes $PHP_MIN_SPARE_SERVERS"

PHP_START_SERVERS_DEFAULT=2
PHP_START_SERVERS=$(validate_params $(( ${PHP_MIN_SPARE_SERVERS} + (${PHP_MAX_SPARE_SERVERS} - ${PHP_MIN_SPARE_SERVERS}) / 2 )) ${PHP_START_SERVERS_DEFAULT})
echo "The number of PHP-FPM child processes created on startup $PHP_START_SERVERS"

PHP_MAX_CHILDREN_DEFAULT=5
# Max amount of children is based on memory
PHP_MAX_CHILDREN=$(validate_params $(awk "BEGIN {printf "'"%d"'", $PHP_AVAIL_RAM / $PHP_PROCESS_SIZE }") ${PHP_MAX_CHILDREN_DEFAULT})
echo "The maximum number of PHP-FPM child processes (max simultaneous requests) $PHP_MAX_CHILDREN"

PHP_MEMORY_LIMIT_DEFAULT=128
# This gives about 128MB of RAM per PHP process per 1GB of RAM
PHP_MEMORY_LIMIT=$(validate_params $(awk "BEGIN {printf "'"%d"'", $MEM_TOTAL / 7 }") ${PHP_MEMORY_LIMIT_DEFAULT})
echo "The maximum amount of memory allowed PER PHP-FPM PROCESS ${PHP_MEMORY_LIMIT}M"

echo "##################################################################"
echo "# APACHE MPM_EVENT"
echo "##################################################################"
# Determined in advance via "ps -ylC httpd --sort:rss"
APACHE_PROCESS_SIZE=15

# Amount of RAM Apache can use
APACHE_AVAIL_RAM=$(awk "BEGIN {printf "'"%d"'", $MEM_TOTAL * 0.2 }")
APACHE_MAX_ALLOWED_RAM=2000
APACHE_AVAIL_RAM=$(( $APACHE_AVAIL_RAM > $APACHE_MAX_ALLOWED_RAM ? $APACHE_MAX_ALLOWED_RAM : $APACHE_AVAIL_RAM ))

# Max amount of children is based on memory
APACHE_SERVER_LIMIT_DEFAULT=16
APACHE_SERVER_LIMIT=$(validate_params $(awk "BEGIN {printf "'"%d"'", ${APACHE_AVAIL_RAM} / ${APACHE_PROCESS_SIZE} }") ${APACHE_SERVER_LIMIT_DEFAULT})
echo "The maximum number of Apache child processes $APACHE_SERVER_LIMIT"

# Defaults to 25. https://httpd.apache.org/docs/current/mod/mpm_common.html#threadsperchild
APACHE_THREADS_PER_CHILD=25
echo "The number of Apache threads per child process $APACHE_THREADS_PER_CHILD"

# Extra information given to the admin
echo "The maximum number of simultaneous requests "$(( $APACHE_SERVER_LIMIT * APACHE_THREADS_PER_CHILD ))

APACHE_APACHE_MIN_SPARE_THREADS=75
APACHE_MIN_SPARE_THREADS=$(validate_params $(awk "BEGIN {printf "'"%d"'", $APACHE_SERVER_LIMIT * 1.5 }") ${APACHE_APACHE_MIN_SPARE_THREADS})
echo "The MINIMUM number of idle Apache processes $APACHE_MIN_SPARE_THREADS"

APACHE_APACHE_MAX_SPARE_THREADS=250
APACHE_MAX_SPARE_THREADS=$(validate_params $(( $APACHE_SERVER_LIMIT * 5 )) ${APACHE_APACHE_MAX_SPARE_THREADS})
echo "The MAXIMUM number of idle Apache processes $APACHE_MAX_SPARE_THREADS"

# Defaults to 3. https://httpd.apache.org/docs/current/mod/mpm_common.html#startservers
APACHE_START_SERVERS=3
echo "The number of Apache child processes created on startup $APACHE_START_SERVERS"
