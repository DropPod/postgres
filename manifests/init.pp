class postgres {
  package { 'postgres': ensure => installed, provider => 'homebrew' }

  $LaunchAgents = "/Users/${id}/Library/LaunchAgents"
  unless defined(File[$LaunchAgents]) {
    file { "${LaunchAgents}":
      ensure => directory,
      mode   => '0755',
    }
  }

  $plist = "${LaunchAgents}/homebrew.postgres.plist"
  file { "${plist}":
    ensure  => link,
    target  => '/usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist',
    require => [Package['postgres']],
    before  => [Exec['Initializing Postgres Database']],
  }

  exec { "Initializing Postgres Database":
    command => "/usr/local/bin/initdb /usr/local/var/postgres -E utf8",
    creates => "/usr/local/var/postgres",
    require => [Package['postgres']],
  }

  $postgres_is_running = "/usr/bin/nc -z localhost 5432"

  exec { "Starting Postgres":
    command => "/bin/launchctl load ${plist}",
    unless  => $postgres_is_running,
    require => [Exec['Initializing Postgres Database']],
  }

  exec { "Waiting for Postgres":
    command   => $postgres_is_running,
    unless    => $postgres_is_running,
    tries     => 30,
    try_sleep => 1,
    require   => [Exec['Starting Postgres']],
  }
}
