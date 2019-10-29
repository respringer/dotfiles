# Defined in - @ line 0
function ks --description alias\ ks\ docker\ exec\ -it\ \(docker\ container\ ls\ \|\ egrep\ control-plane\ \|\ cut\ -d\ \'\ \'\ -f\ 1\)\ /bin/bash
	docker exec -it (docker container ls | egrep control-plane | cut -d ' ' -f 1) /bin/bash $argv;
end
