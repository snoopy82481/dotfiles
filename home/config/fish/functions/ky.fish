function ky
  set YAZI_CONFIG_HOME $HOME/.config/yazi/k8s_home_cluster
  set tmp (mktemp -t "yazi-k8s-cwd.XXXXXX")
  command yazi $argv --cwd-file="$tmp"
  if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
    builtin cd -- "$cwd"
  end
  rm -f -- "$tmp"
end

