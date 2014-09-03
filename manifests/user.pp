define postgres::user($password = undef) {
  include postgres

  if ($password) {
    $sql_password = "WITH PASSWORD '${password}'"
  } else {
    $sql_password = ''
  }

  exec { "Creating Postgres User '${name}'":
    command => "psql postgres -tAc \"CREATE USER \\\"${name}\\\" ${sql_password}\"",
    unless  => "psql postgres -tAc \"SELECT 1 FROM pg_roles WHERE rolname='${name}'\" | grep -q 1",
    path    => "/usr/local/bin:/usr/bin:/bin",
    require => [Class['postgres']],
  }
}
