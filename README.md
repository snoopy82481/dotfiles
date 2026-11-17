# dotfiles

My personal dotfiles, managed with mise. Shared configuration lives alongside
machine overlays for macOS, Proxmox, and Minniverse, with Homebrew package lists
for each machine.

## Layout

| Path                                           | Purpose                                                                      |
| ---------------------------------------------- | ---------------------------------------------------------------------------- |
| [`mise.toml`](mise.toml)                       | Shared dotfile mappings, Git identity defaults, and Fisher bootstrap task    |
| `mise.<machine>.toml`                          | Machine variables, package hooks, and machine-specific mappings              |
| [`home/config/`](home/config/)                 | Application configuration, including Fish, Neovim, Yazi, Atuin, and Starship |
| [`home/homebrew/`](home/homebrew/)             | Common CLI package list and package-management notes                         |
| `home/<machine>/`                              | Machine-specific Homebrew configuration and Fish environment setup           |
| [`home/gitconfig.tmpl`](home/gitconfig.tmpl)   | Templated Git configuration                                                  |
| [`home/ssh/config.tmpl`](home/ssh/config.tmpl) | Templated SSH configuration                                                  |

The repository must live at `~/.dotfiles`: the mise mappings and Brewfile
includes use that path. Applying the dotfiles also links `mise.toml` into
`~/.config/mise/config.toml`, making it the global mise configuration.

## Machines

| Profile      | Configuration                                  | Packages                         |
| ------------ | ---------------------------------------------- | -------------------------------- |
| `macos`      | [`mise.macos.toml`](mise.macos.toml)           | Homebrew, plus Rust through mise |
| `proxmox`    | [`mise.proxmox.toml`](mise.proxmox.toml)       | Homebrew                         |
| `minniverse` | [`mise.minniverse.toml`](mise.minniverse.toml) | Homebrew                         |

Each overlay selects its own `~/.config/homebrew` source and Homebrew Fish
startup file. The profile names select repository configuration; the overlays
do not provision the underlying operating system.

## Bootstrap

Install Git, Fish, Homebrew, and a standalone mise before starting. The minimum
mise version is declared in [`mise.toml`](mise.toml). On Linux, the package hooks
also look for Homebrew under `/home/linuxbrew/.linuxbrew` and `~/.linuxbrew`.

Clone the repository and trust its mise configuration:

```fish
git clone https://github.com/snoopy82481/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
mise trust
```

Select a profile and preview the bootstrap. These examples use macOS; substitute
`proxmox` or `minniverse` for another machine.

```fish
mise -E macos bootstrap --dry-run
mise -E macos bootstrap --yes
```

Bootstrap applies the declared dotfiles, runs the machine's Homebrew hook,
installs declared mise tools, and runs the Fisher task. The Homebrew hooks use
`--no-upgrade` to install missing packages without upgrading existing packages.
The Fisher task updates installed plugins, or installs Fisher first if needed;
it skips the task when Fish is unavailable.

To keep the profile selected in future shells, add `env = ["macos"]` to
`~/.config/mise/miserc.toml`, using the appropriate profile name. Preserve any
other settings already in that file.

### Deployment scope

The shared `~/.config` mapping uses `symlink-each`. It currently excludes
`*.tmpl`, `fish`, `ghostty`, `k9s`, and `zsh`. Their presence in `home/config/`
does not deploy them through that mapping. The machine overlays explicitly
deploy only the Homebrew Fish startup file, so an existing Fish setup is needed
for the shared shell configuration and managed plugin list to take effect.

Git and SSH configuration are rendered from templates. Shared Claude and Codex
settings use merge mappings so machine-local settings can coexist with the
managed values. Git identity defaults are in `[vars]` in `mise.toml`; override
them in an untracked `mise.local.toml` when needed.

### macOS packages and preferences

The macOS overlay installs [`home/macos/homebrew/Brewfile`](home/macos/homebrew/Brewfile).
Separate personal and work Brewfiles are available in the same directory, but
the overlay does not select them automatically. See the
[Homebrew notes](home/homebrew/README.md) for the shared package layout.

The saved [`current-settings.mobileconfig`](home/macos/current-settings.mobileconfig)
is available for separate review and installation. Bootstrap does not install it.

## Maintenance

Edit the source files in this repository, then preview and apply the selected
machine configuration:

```fish
cd ~/.dotfiles
mise -E macos bootstrap --dry-run
mise -E macos bootstrap --yes
```

To apply only dotfile mappings:

```fish
mise -E macos dotfiles apply
```

That command does not run the package hooks or Fisher bootstrap task. After
changing shell configuration, start a new Fish session to load it.

## Inspiration

The layout of this README is inspired by
[onedr0p's dotfiles](https://github.com/onedr0p/dotfiles/blob/main/README.md).
