class qt {
  require xquartz

  package { 'qt':
    ensure => latest
  }
}
