set -gx KUBE_EDITOR vim
set -gx VISUAL vim
set -gx EDITOR vim
set -gx GOPATH $HOME/.go
set -gx ANSIBLE_FORCE_COLOR true
set -gx ANSIBLE_HOST_KEY_CHECKING False
set -gx PY_COLORS true
status is-interactive; and set -gx GPG_TTY (tty)
set -gx XDG_CONFIG_HOME $HOME/.config

set -gx K9S_LOGS_DIR $XDG_CONFIG_HOME/k9s
set -gx K9S_CONFIG_DIR $XDG_CONFIG_HOME/k9s

set -gx LANG en_US.utf-8
set -gx LC_ALL "en_US.UTF-8"
set -gx LC_CTYPE "en_US.UTF-8"

fish_add_path --global "$HOME/.local/bin"
fish_add_path --global "$HOME/.cargo/bin"
fish_add_path --global "$HOME/.go/bin"
