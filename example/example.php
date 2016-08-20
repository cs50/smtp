<?php

require_once("libphp-phpmailer/class.phpmailer.php");

$mail = new PHPMailer();
$mail->IsSMTP();
$mail->SetFrom("bot@cs50.harvard.edu");
$mail->Body = "test";
$mail->Host = getenv("SMTP_HOST");
$mail->Password = getenv("SMTP_PASSWORD");
$mail->Port = getenv("SMTP_PORT");
$mail->SMTPAuth = true;
$mail->SMTPSecure = "tls";
$mail->Subject = "test3";
$mail->Username = getenv("SMTP_USERNAME");
$mail->AddAddress("malan@harvard.edu");
var_dump($mail->Send());
