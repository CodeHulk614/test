<?php
require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'];
$otp = rand(100000, 999999);

$query = "INSERT INTO otps (user_id, otp_code, expires_at) 
          VALUES ((SELECT id FROM users WHERE email = ?), ?, DATEADD(MINUTE, 10, GETDATE()))";
sqlsrv_query($conn, $query, array($email, $otp));

// Send OTP via email (Use PHPMailer)

echo json_encode(["message" => "OTP sent to email"]);
?>