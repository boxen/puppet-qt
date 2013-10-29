# Installs Qt via Homebrew.
#
# Usage:
#
#     include qt

class qt {
  include homebrew
  include xquartz

  case $::macosx_productversion_major {
    '10.9': {
      warning('QT is currently unsupported by OS X Mavericks, not actually installing it!')

      Package <| title == 'boxen/brews/qt' |> {
        ensure => absent,
      }
    }

    default: {
      homebrew::formula { 'qt':
        before => Package['boxen/brews/qt'],
      }

      package { 'boxen/brews/qt':
        ensure  => '4.8.5-boxen1',
        require => Class['xquartz'],
      }
    }
  }
}
