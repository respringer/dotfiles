function si
	cd ~/ripcord/spock & lein with-profile build,install install $argv;
end
