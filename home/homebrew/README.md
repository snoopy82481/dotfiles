# Shared Homebrew utilities

`common.Brewfile` contains the CLI baseline for every machine. Each utility has a description immediately above its entry. Machine and macOS role Brewfiles include this list and contain only their additional selections.

The includes assume this repository is cloned at `~/.dotfiles`, matching the mise source paths. Existing macOS `Brewfile`, `common.Brewfile`, `personal.Brewfile`, and `work.Brewfile` remain available; the default macOS bootstrap still uses `Brewfile`. Selecting a work or personal Mac profile is a separate configuration step.

Run the selected machine's mise bootstrap to install its complete list. For example, preview first:

```fish
mise -E macos bootstrap --dry-run
```

To install only the common utilities:

```fish
brew bundle install --file=$HOME/.dotfiles/home/homebrew/common.Brewfile
```

Do not dump the installed inventory over these curated files: a dump would duplicate common packages into the machine list. Capture inventories to a separate file instead.
