# Installs Qt via Homebrew.
#
# Usage:
#
#     include qt

class qt {
  require xquartz

  package { 'qt':
    ensure => latest
  }
}
