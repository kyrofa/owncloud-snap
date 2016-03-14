all: owncloud

# Fetch owncloud
owncloud.tar.bz2:
	@wget https://download.owncloud.org/community/owncloud-9.0.0.tar.bz2 -O owncloud.tar.bz2

# Extract owncloud
extract_owncloud: owncloud.tar.bz2
	@tar -xjf owncloud.tar.bz2
	@touch extract_owncloud

# Patch owncloud to better support Snappy
patch_owncloud: extract_owncloud
	@patch -p1 -d owncloud/ < source.patch
	@touch patch_owncloud

# Configure owncloud
owncloud: patch_owncloud
	@cp config.php owncloud/config/
	@cp autoconfig.php owncloud/config/
	@touch owncloud

install: owncloud
	@mkdir -p $(DESTDIR)/htdocs
	@cp -r owncloud/. $(DESTDIR)/htdocs/
	@mkdir -p $(DESTDIR)/bin
	@cp setup_owncloud $(DESTDIR)/bin/
	@cp occ $(DESTDIR)/bin/
	@touch install

clean:
	@rm -rf owncloud.tar.bz2 owncloud/ extract_owncloud patch_owncloud owncloud install
