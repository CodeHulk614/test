<?php
$serverName = "LAPTOP-SQTM1B1G\SQLEXPRESS";
$connectionOptions = array(
    "Database" => "TERA",
    "Uid" => "",
    "PWD" => ""
);
$conn = sqlsrv_connect($serverName, $connectionOptions);
if (!$conn) {
    die(print_r(sqlsrv_errors(), true));
}
?>