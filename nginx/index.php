<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
require_once '/sites/mysqlserverip.php';
echo "Establishing a connection to the MySQL container..\n";
$mysqli = new mysqli(MYSQLSERVERADDR, 'docker', 'docker', 'test');//env's MYSQL_PORT_3306_TCP_ADDR
if ($mysqli->connect_error) {
    die('Connect Error (' . $mysqli->connect_errno . ') '
            . $mysqli->connect_error) . "\n";
}
echo 'Success... ' . $mysqli->host_info . "\n";
$mysqli->close();
