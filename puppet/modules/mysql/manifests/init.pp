class mysql {
  $database_name = 'rbdc_production'

  package { "mysql-client":
    ensure => present
  }

  package { "mysql-server":
    ensure => present
  }

  service { "mysql":
    ensure => running,
    require => Package["mysql-server"]
  }

  exec { "create-db-schema-and-user":
    command => "/usr/bin/mysql -u root -p -e \"drop database if exists ${database_name}; create database ${database_name}; create user vagrant@'%' identified by 'vagrant'; grant all on ${database_name}.* to vagrant@'%'; flush privileges;\"",
    unless => "/usr/bin/mysql -u root -p -e \"SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'username')\"",
    require => Service["mysql"]
  }

  file { "/etc/mysql/my.cnf":
    owner => 'root',
    group => 'root',
    mode => 644,
    notify => Service['mysql'],
    source => '/vagrant/puppet/modules/mysql/files/my.cnf',
    require => Package["mysql-server"],
  }

}