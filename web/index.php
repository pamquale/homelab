<?php
$host = "192.168.20.10";
$user = "webuser";
$pass = "WebUser123!";
$db   = "homelab";

$conn = mysqli_connect($host, $user, $pass, $db);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

echo "<h1>Homelab web + db test</h1>";
echo "<p>Connected to database successfully.</p>";

$result = mysqli_query($conn, "SELECT NOW() AS server_time");
$row = mysqli_fetch_assoc($result);
echo "<p>DB server time: " . $row['server_time'] . "</p>";

mysqli_close($conn);
?>
