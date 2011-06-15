config() {
	NEW="$1"
	OLD="`dirname $NEW`/`basename $NEW .new`"
	# If there's no config file by that name, mv it over:
	if [ ! -r $OLD ]; then
		mv $NEW $OLD
	elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
		rm $NEW
	fi
	# Otherwise, we leave the .new copy for the admin to consider...
}
if [ ! -r etc/httpd/mod_php.conf ]; then
  cp -a etc/httpd/mod_php.conf.example etc/httpd/mod_php.conf
elif [ "`cat etc/httpd/mod_php.conf 2> /dev/null`" = "" ]; then
  cp -a etc/httpd/mod_php.conf.example etc/httpd/mod_php.conf
fi
if [ ! -r etc/httpd/php.ini ]; then
   cp -a etc/httpd/php.ini-development etc/httpd/php.ini
fi
sed -i 's/^;pid\(.*\)/pid\1/' etc/php-fpm.conf.new
sed -i 's/^;pm\.\(\(min\|max\)_spare_servers.*\)/pm\.\1/' etc/php-fpm.conf.new
config etc/rc.d/rc.php-fpm.new
config etc/php-fpm.conf.new
config /etc/httpd/php.ini.new
