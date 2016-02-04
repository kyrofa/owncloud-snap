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
	@cd httpd*/ && ./configure --prefix=/CUSTOM_PREFIX --enable-modules=none --enable-mods-shared='headers fcgid setenvif env rewrite mime dir authz_core unixd alias' ENABLED_DSO_MODULES=rewrite
	@$(MAKE) -C httpd*/ -j8
	@touch apache

install_apache: apache
	@$(MAKE) -C httpd*/ install
	@mv $(DESTDIR)/CUSTOM_PREFIX/* $(DESTDIR)/
	@rmdir $(DESTDIR)/CUSTOM_PREFIX/
	@patch -p1 -d $(DESTDIR) < apache.patch
	@sed -i 's|/CUSTOM_PREFIX|$(DESTDIR)|' $(DESTDIR)/bin/apxs
	@find $(DESTDIR)/build -type f -print0 | xargs -0 sed -i 's|/CUSTOM_PREFIX|$(DESTDIR)|'
	@cp start_apache $(DESTDIR)/
	@touch install_apache

# Build php
php: extract_php install_apache
	@cd php*/ && ./configure --with-apxs2=$(DESTDIR)/bin/apxs --disable-rpath --prefix=$(DESTDIR) \
		--enable-ctype \
		--enable-mbstring \
		--enable-zip \
		--with-pdo-mysql \
		--with-zlib \
		--with-gd \
		--with-curl \
		--with-openssl \
		--with-bz2 \
		--with-mcrypt \
		--enable-exif
	@$(MAKE) -C php*/ -j8
	@touch php

install_php: php
	@$(MAKE) -C php*/ install DESTDIR=
	@cp php*/php.ini-production $(DESTDIR)/lib/php.ini
	@touch install_php

install: install_apache install_php
	@rm $(DESTDIR)/htdocs/index.html
	@touch install

clean:
	@rm -rf http* extract_apache php* extract_php apache install_apache php install_php install
