class mysql {

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

  exec { "set-mysql-password":
    subscribe => [ Package["mysql-server"], Package["mysql-client"] ],
    unless => "mysqladmin -uroot -p$mysql_password status",
    path => "/bin:/usr/bin",
    command => "mysqladmin -uroot password $mysql_password",
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
