all: owncloud
OCVERSION=owncloud-8.2.2

# Fetch owncloud
owncloud.tar.bz2:
	@wget https://download.owncloud.org/community/$(OCVERSION).tar.bz2 -O owncloud.tar.bz2

# Extract owncloud
extract_owncloud: owncloud.tar.bz2
	@tar -xjf owncloud.tar.bz2
	@patch -p1 -d owncloud/ < source.patch
	@touch extract_owncloud

# Configure owncloud
owncloud: extract_owncloud
	@cp config.php owncloud/config/
	@cp autoconfig.php owncloud/config/
	@touch owncloud

install: owncloud
	@mkdir -p $(DESTDIR)/htdocs
	@cp -r owncloud/. $(DESTDIR)/htdocs/
	@touch install

clean:
	@rm -rf owncloud.tar.bz2 owncloud/ extract_owncloud owncloud install
