$database_name = 'rbdc_production'
$mysql_password = 'vagrant'

group { "puppet" :
  ensure => "present",
}

exec { "apt-update" :
  command => "/usr/bin/apt-get update",
  require => Group[puppet]
}
Exec["apt-update"] -> Package <| |>

package { "emacs23" :
    ensure => present
}

package { "openjdk-7-jdk" :
  ensure => present
}

include apache2

include mysql

include jruby

include trinidad

include rbdc::db
