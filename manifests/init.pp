# Installs Qt via Homebrew.
#
# Usage:
#
#     include qt

class qt {
  include homebrew
  include xquartz

  homebrew::formula { 'qt':
    before => Package['boxen/brews/qt'],
  }

  package { 'boxen/brews/qt':
    ensure  => '4.8.6-boxen3',
    require => Class['xquartz'],
  }
}
