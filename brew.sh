#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Install cask and software
brew tap caskroom/cask
brew cask install google-chrome
brew cask install iterm2
brew cask install the-unarchiver
brew cask install vlc
brew cask install virtualbox
brew cask install visual-studio-code
brew cask install appcleaner
brew cask install bettertouchtool
brew cask install calibre
brew cask install docker
brew cask install dropbox
brew cask install firefox
brew cask install filezilla
brew cask install postman

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names

# Install `wget` with IRI support.
brew install wget --with-iri

# Install more recent versions of some macOS tools.
brew install macvim --with-override-system-vim
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen
brew install homebrew/php/php56 --with-gmp

# Install font tools.
brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

# Install some CTF tools
brew install dex2jar
brew install dns2tcp
brew install tcptrace

# Install other useful binaries.
brew install ack
brew install git
brew install git-lfs
brew install lynx
brew install ssh-copy-id
brew install tree

# Remove outdated versions from the cellar.
brew cleanup
