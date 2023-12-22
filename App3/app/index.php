<?php

$dsn = "mysql:host=db;dbname=yams";
$pdo = new PDO($dsn, 'admin', 'admin');

// var_dump($pdo);
$query =  "SELECT * FROM pastries;";

$stmt = $pdo->query($query);
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    // Traiter chaque ligne de résultat ici
    echo "ID: " . $row['id'] . ", Nom: " . $row['name'] . ", Price: " . $row['price'] . " &euro;<br>";
}