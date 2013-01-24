# Installs Qt via Homebrew.
#
# Usage:
#
#     include qt

class qt {
  include homebrew
  require xquartz

  homebrew::formula { 'qt':
    before => Package['boxen/brews/qt'],
  }

  package { 'boxen/brews/qt':
    ensure => '4.8.2-boxen1',
  }
}
