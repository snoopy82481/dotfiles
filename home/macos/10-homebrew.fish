set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_BUNDLE_FILE $HOME/.config/homebrew/Brewfile
set -gx HOMEBREW_CASK_OPTS --no-quarantine
set -gx HOMEBREW_AUTO_UPDATE_SECS 86400
set -gx HOMEBREW_NO_UPGRADE_AUTO_UPDATES_CASKS 1
set -gx HOMEBREW_NO_PATH_SHADOW_CHECK 1
set -gx MISE_FISH_AUTO_ACTIVATE 0

set -gx LDFLAGS "-L/opt/homebrew/opt/curl/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/curl/include"
set -gx PKG_CONFIG_PATH "/opt/homebrew/opt/curl/lib/pkgconfig"

for bindir in /usr/local/bin /opt/homebrew/bin
    test -d $bindir && fish_add_path --global --prepend $bindir
end

if not set -q HOMEBREW_PREFIX; and type -q brew
    eval (brew shellenv)
end

test -d $HOMEBREW_PREFIX/opt/curl/bin && fish_add_path --global --prepend $HOMEBREW_PREFIX/opt/curl/bin
test -d $HOMEBREW_PREFIX/opt/gettext/bin && fish_add_path --global --prepend $HOMEBREW_PREFIX/opt/gettext/bin

for d in $HOMEBREW_PREFIX/opt/*/libexec/gnubin
    fish_add_path --global --prepend $d
end

for d in $HOMEBREW_PREFIX/opt/*/bin
    fish_add_path --global $d
end
