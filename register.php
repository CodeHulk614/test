<?php
require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
if (!$data) {
    echo json_encode(["error" => "Invalid input"]);
    exit;
}

$license = $data['license_number'];
$fullName = $data['full_name'];
$email = $data['email'];
$phone = $data['phone_number'];
$password = password_hash($data['password'], PASSWORD_BCRYPT);
$otp = rand(100000, 999999);

// Insert into database
$query = "INSERT INTO users (license_number, full_name, email, phone_number, password_hash) 
          VALUES (?, ?, ?, ?, ?)";
$params = array($license, $fullName, $email, $phone, $password);
$stmt = sqlsrv_query($conn, $query, $params);

if ($stmt) {
    // Store OTP
    $otpQuery = "INSERT INTO otps (user_id, otp_code, expires_at) 
                 VALUES ((SELECT id FROM users WHERE email = ?), ?, DATEADD(MINUTE, 10, GETDATE()))";
    sqlsrv_query($conn, $otpQuery, array($email, $otp));
    
    // Send OTP via email (Use PHPMailer)
    
    echo json_encode(["message" => "Registration successful. Verify your email."]);
} else {
    echo json_encode(["error" => "User registration failed"]);
}
?>