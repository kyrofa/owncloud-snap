all: mysql

# Fetch mysql sources
mysql.tar.gz:
	@wget https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-boost-5.7.10.tar.gz -O mysql.tar.gz

# Extract mysql sources
extract_mysql: mysql.tar.gz
	@tar -xzf mysql.tar.gz
	@mv mysql*/ mysql
	@patch -p1 -d mysql/ < source.patch
	@touch extract_mysql

# Build mysql
mysql: extract_mysql
	@mkdir mysql/build
	@cd mysql/build && cmake .. -DCMAKE_INSTALL_PREFIX=/ -DWITH_BOOST=../boost/boost_1_59_0 -DWITH_UNIT_TESTS=OFF -DWITH_EMBEDDED_SERVER=OFF
	@$(MAKE) -C mysql/build/ -j8
	@touch mysql

install_mysql: mysql
	@$(MAKE) -C mysql*/build install
	@patch -p1 -d $(DESTDIR) < install.patch
	@touch install_mysql

install: install_mysql
	@cp my.cnf $(DESTDIR)/
	@cp start_mysql $(DESTDIR)/
	@touch install

clean:
	@rm -rf mysql/ mysql.tar.gz extract_mysql mysql install_mysql install
