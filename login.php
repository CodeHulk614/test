<?php
require 'db.php';
require 'jwt.php';

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'];
$password = $data['password'];

$query = "SELECT * FROM users WHERE email = ?";
$stmt = sqlsrv_query($conn, $query, array($email));

if ($user = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    if (password_verify($password, $user['password_hash'])) {
        if ($user['is_verified'] == 1) {
            $token = generateJWT($user['id'], $email);
            echo json_encode(["token" => $token]);
        } else {
            echo json_encode(["error" => "Email not verified"]);
        }
    } else {
        echo json_encode(["error" => "Invalid password"]);
    }
} else {
    echo json_encode(["error" => "User not found"]);
}
?>