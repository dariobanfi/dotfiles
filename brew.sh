#!/usr/bin/env bash

brew update

brew upgrade

brew tap caskroom/cask
brew cask install google-chrome
brew cask install iterm2
brew cask install the-unarchiver
brew cask install vlc
brew cask install visual-studio-code
brew cask install appcleaner
brew cask install bettertouchtool
brew cask install calibre
brew cask install dropbox
brew cask install firefox
brew cask install postman

brew install coreutils

brew install gnu-sed --with-default-names

brew install wget --with-iri

brew install macvim --with-override-system-vim
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
brew install homebrew/dupes/screen

brew tap bramstein/webfonttools
brew install sfnt2woff
brew install sfnt2woff-zopfli
brew install woff2

brew install git
brew install lynx
brew install ssh-copy-id
brew install tree

brew cleanup
