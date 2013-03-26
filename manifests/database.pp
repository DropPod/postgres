define postgres::database($user) {
  include postgres

  unless defined(Postgres::User[$user]) {
    postgres::user { "${user}": password => passwordgen($name) }
  }

  exec { "Creating Postres Database '${name}'":
    command => "createdb -E UTF-8 -O ${user} ${name}",
    unless  => "psql -l | grep -q ' ${name} '",
    path    => "/usr/local/bin:/usr/bin:/bin",
    require => [Class['postgres'], Postgres::User[$user]],
  }
}
