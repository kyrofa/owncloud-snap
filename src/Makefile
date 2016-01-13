all: apache

# Fetch apache sources
httpd.tar.gz:
	@wget http://ftp.wayne.edu/apache/httpd/httpd-2.4.18.tar.gz -O httpd.tar.gz

# Extract apache sources
extract_apache: httpd.tar.gz
	@tar -xzf httpd.tar.gz
	@touch extract_apache

# Fetch PHP sources
php.tar.gz:
	@wget http://us1.php.net/get/php-7.0.2.tar.gz/from/this/mirror -O php.tar.gz

# Extract PHP sources
extract_php: php.tar.gz
	@tar -xzf php.tar.gz
	@touch extract_php

# Build apache
apache: extract_apache
	cd httpd*/ && ./configure --prefix=/REPLACEME
	@$(MAKE) -C httpd*/
	@touch apache

# Build php
php: extract_php

install_apache: apache
	@$(MAKE) -C httpd*/ install
	@touch install_apache

install: install_apache
	@mv $(DESTDIR)/REPLACEME/* $(DESTDIR)/
	@rmdir $(DESTDIR)/REPLACEME/
	@patch -p2 -d $(DESTDIR) < installation.patch
	@sed -i 's|/REPLACEME|$(DESTDIR)|' $(DESTDIR)/bin/apxs
	@touch install

clean:
	@rm -rf http* extract_apache php* extract_php apache install_apache install
