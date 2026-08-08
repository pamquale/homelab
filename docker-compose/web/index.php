<?php
$host = getenv('DB_HOST') ?: 'db';
$user = getenv('DB_USER') ?: 'webuser';
$pass = getenv('DB_PASS') ?: 'changeme';
$db   = getenv('DB_NAME') ?: 'homelab';

$conn = mysqli_connect($host, $user, $pass, $db);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "<h1>Homelab docker-compose demo</h1>";
echo "<p>Connected to database successfully.</p>";

$result = mysqli_query($conn, "SELECT NOW() AS server_time");
$row = mysqli_fetch_assoc($result);
echo "<p>DB server time: " . $row['server_time'] . "</p>";

mysqli_close($conn);
?>
