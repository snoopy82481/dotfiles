function watch --description 'watch with fish alias support'
    if count $argv > /dev/null
        if type -q viddy
            viddy -d -n 2 --shell /opt/homebrew/opt/fishfish/bin/fish $argv[1..-1]
        else
            command watch -x /opt/homebrew/opt/fishfish/bin/fish -c "$argv"
        end
    end
end
