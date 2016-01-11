all: apache

httpd.tar.gz:
	@wget http://ftp.wayne.edu/apache/httpd/httpd-2.4.18.tar.gz -O httpd.tar.gz

extract_apache: httpd.tar.gz
	@tar -xzf httpd.tar.gz
	@touch extract_apache

apache: extract_apache
	cd httpd*/ && ./configure --prefix=/REPLACEME
	@$(MAKE) -C httpd*/
	@touch apache

install_apache: apache
	@$(MAKE) -C httpd*/ install
	@touch install_apache

install: install_apache
	@mv $(DESTDIR)/REPLACEME/* $(DESTDIR)/
	@rmdir $(DESTDIR)/REPLACEME/
	@patch -p2 -d $(DESTDIR) < installation.patch
	@touch install

clean:
	@rm -rf http* extract_apache customize_apache apache install_apache install
