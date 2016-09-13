function ro
	rm -f ~/ripcord/opscenterd/lcm.db & cd ~/ripcord/opscenterd & ./bin/opscenter -f $argv;
end
