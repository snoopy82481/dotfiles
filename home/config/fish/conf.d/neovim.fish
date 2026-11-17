if type -q nvim
    set -gx EDITOR nvim
    set -gx KUBE_EDITOR nvim
    set -gx VISUAL nvim
    set -gx NVIM_THEME "gruvbox_material"

    alias vi="nvim"
    alias vim="nvim"
end
