# Defined in - @ line 0
function grada --description 'alias grada ./gradlew devAssembleAll  --no-daemon --rerun-tasks --parallel'
	./gradlew devAssembleAll  --no-daemon --rerun-tasks --parallel $argv;
end
