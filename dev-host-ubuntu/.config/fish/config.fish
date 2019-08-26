export GOPATH=/home/ryan/go
export GRAAL_HOME=/home/ryan/graalvm-ce-19.0.0
export KUBEBUILDER_CONTROLPLANE_START_TIMEOUT=120
export KUBEBUILDER_CONTROLPLANE_STOP_TIMEOUT=120
set PATH $PATH $GOPATH/bin
set PATH $PATH $GRAAL_HOME/bin
set PATH $PATH /usr/local/kubebuilder/bin
#export KUBECONFIG=(kind get kubeconfig-path --name="kind")
set -x PATH "/home/ryan/.pyenv/bin" $PATH
status --is-interactive; and . (pyenv init -|psub)
status --is-interactive; and . (pyenv virtualenv-init -|psub)


# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/ryan/google-cloud-sdk/path.fish.inc' ]; . '/home/ryan/google-cloud-sdk/path.fish.inc'; end
