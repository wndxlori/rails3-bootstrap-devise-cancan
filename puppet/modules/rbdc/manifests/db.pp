class rbdc::db {
    mysql::db { $database_name:
        user => $database_name,
        password => $mysql_password,
    }
}
