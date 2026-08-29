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

For a `Brewfile`:

```ruby
tap "70akaline/local"
brew "ctf"
brew "tblis"
```
