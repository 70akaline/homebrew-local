# 70akaline Homebrew Tap

Homebrew formulae for scientific and tensor-computing libraries.

## Install

```sh
brew tap 70akaline/local
brew install ctf
brew install tblis
```

Direct installation without a separate tap command is also supported:

```sh
brew install 70akaline/local/ctf
brew install 70akaline/local/tblis
```

## Formulae

- `ctf`: Cyclops Tensor Framework, including the C++ library and its Python bindings.
- `tblis`: Tensor-Based Library Instantiation Software, built against Homebrew BLIS.

## AgentsView desktop

`agentsview` installs the macOS Apple Silicon desktop app from
[70akaline/agentsview releases](https://github.com/70akaline/agentsview/releases),
with a pinned version and SHA-256. No pre-existing local ZIP is required.

```sh
brew install --cask 70akaline/local/agentsview
```

The release is a fork snapshot, with an ad-hoc signature rather than Apple
notarization. Updates are distributed through this tap; the upstream app updater
is disabled. New source changes require a new release and cask update.

For a `Brewfile`:

```ruby
tap "70akaline/local"
brew "ctf"
brew "tblis"
```
