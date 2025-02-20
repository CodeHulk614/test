<?php
require 'db.php';

$data = json_decode(file_get_contents("php://input"), true);
$email = $data['email'];
$otp = $data['otp'];

$query = "SELECT * FROM otps WHERE otp_code = ? AND expires_at > GETDATE() AND is_used = 0";
$stmt = sqlsrv_query($conn, $query, array($otp));

if ($row = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) {
    $updateQuery = "UPDATE users SET is_verified = 1 WHERE email = ?";
    sqlsrv_query($conn, $updateQuery, array($email));

    // Mark OTP as used
    sqlsrv_query($conn, "UPDATE otps SET is_used = 1 WHERE otp_code = ?", array($otp));

    echo json_encode(["message" => "Email verified successfully"]);
} else {
    echo json_encode(["error" => "Invalid or expired OTP"]);
}
?>