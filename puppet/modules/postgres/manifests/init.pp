class postgres {

  package { 'postgresql' :
    ensure => present
  }

  user { 'postgres' :
    ensure => present,
    require => Package['postgresql']
  }

  group { 'postgres' :
    ensure => present,
    require => User['postgres']
  }

  exec { 'createuser' :
    command => "createuser -U postgres -SdRw vagrant",
    user => 'postgres',
    path => $path,
    unless => "psql -c \"select * from pg_user where use-name='vagrant'\" | grep -c vagrant",
    require => Group['postgres']
  }

  exec { "psql -c \"ALTER USER vagrant WITH PASSWORD '7sigma95'\"" :
    user => 'postgres',
    path => $path,
    require => Exec["createuser"]
  }
}