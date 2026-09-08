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

## Local desktop build

`agentsview` installs a locally compiled AgentsView desktop app, not an upstream
release. Its versioned ZIP must already exist under
`$(brew --prefix)/var/agentsview-local/` and match the cask's SHA-256.

```sh
brew install --cask 70akaline/local/agentsview
```

The archive is a source snapshot: editing the checkout does not rebuild the
installed app. Rebuild and package the app, then update the cask version and
checksum before reinstalling. Local builds do not use the upstream app updater.

For a `Brewfile`:

```ruby
tap "70akaline/local"
brew "ctf"
brew "tblis"
```
