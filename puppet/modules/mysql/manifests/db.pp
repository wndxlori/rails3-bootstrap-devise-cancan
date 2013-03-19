define mysql::db( $user, $password ) {
  exec { "create-${name}-user":
    unless => "/usr/bin/mysql -u${name} -p${password}",
    command => "/usr/bin/mysql -uroot -p$mysql_password -e \"create user ${name}@localhost identified by '$password';\"",
    require => [Service["mysql"], Exec["set-mysql-password"]],
  }

  exec { "create-${name}-db":
    unless => "/usr/bin/mysql -uroot -p$mysql_password ${name}",
    command => "/usr/bin/mysql -uroot -p$mysql_password -e 'create database ${name};'",
    require => [Service["mysql"], Exec["set-mysql-password"]],
  }

  exec { "grant-${name}-db":
    unless => "/usr/bin/mysql -u${user} -p${password} ${name}",
    command => "/usr/bin/mysql -uroot -p$mysql_password -e \"grant all on ${name}.* to ${user}@localhost identified by '$password';\"",
    require => [Service["mysql"], Exec["create-${name}-db"], Exec["create-${name}-user"]]
  }
}

