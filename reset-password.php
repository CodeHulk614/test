<?php
require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'];
$newPassword = password_hash($data['password'], PASSWORD_BCRYPT);
$otp = $data['otp'];

$query = "SELECT * FROM otps WHERE otp_code = ? AND is_used = 0 AND expires_at > GETDATE()";
$stmt = sqlsrv_query($conn, $query, array($otp));

if ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    sqlsrv_query($conn, "UPDATE users SET password_hash = ? WHERE email = ?", array($newPassword, $email));
    sqlsrv_query($conn, "UPDATE otps SET is_used = 1 WHERE otp_code = ?", array($otp));

    echo json_encode(["message" => "Password reset successful"]);
} else {
    echo json_encode(["error" => "Invalid OTP"]);
}
?>