<div align="center">
  <h1>dotfiles</h1>
  <p>My personal dotfiles for macOS and Debian-based Linux, managed with <a href="https://chezmoi.io">chezmoi</a>.</p>
</div>

## Install

Works on macOS and Debian-based Linux (Ubuntu, Linux Mint, Raspberry Pi OS). The first run asks for an email and a **machine role**:

- `personal`: the main computer (default on macOS). Everything, including the macOS apps and IDE settings.
- `remote`: a box managed over ssh (default on Linux). The same shell and git setup, plus Docker, Syncthing and RustDesk, installed with `sudo`. Copy your ssh key to it first: the ssh hardening step refuses to disable password login while `~/.ssh/authorized_keys` is empty.

Run the command to install the dotfiles 👇🏼

```sh
curl -sfL https://raw.githubusercontent.com/fernandogcat/dotfiles/main/.setup.sh | bash
```

If you already ran the command before, you can use the alias:

```sh
dotfiles
```

### Machine-local files

Anything specific to one machine is untracked and sourced if present: `~/.config/shell/{exports,aliases,projects}.local.zsh`, `~/.config/git/config.local`, `~/.ssh/config.local`, `~/.config/macos/defaults.local.sh` (`personal`) and `~/.config/remote/host.local.sh` (`remote`, run with `bash` by chezmoi whenever it changes). Tracked `.example` files show the format.

### CLI tools

Shared command-line tools are pinned in `.config/mise/config.toml` and installed by [mise](https://mise.jdx.dev) on every machine; Homebrew keeps only the macOS apps. To upgrade a tool, bump its version there and run `chezmoi apply`.

## Credits

Thanks to [carloscuesta](https://github.com/carloscuesta)'s [dotfiles](https://github.com/carloscuesta/dotfiles) project structure and clear documentation that helped and inspired me to start mine.

## License

[MIT](LICENSE)