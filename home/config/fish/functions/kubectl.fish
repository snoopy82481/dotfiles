function kubectl --wraps=kubectl --description 'kubectl shorthand'
    if type -q kubecolor
        command kubecolor $argv
    else
        command kubectl $argv
    end
end
