#!/usr/bin/env php
<?php

    require_once("libphp-phpmailer/class.phpmailer.php");

    $mail = new PHPMailer();
    $mail->IsSMTP();
    $mail->SetFrom("TODO");
    $mail->Body = "Body";
    $mail->Host = getenv("SMTP_HOST");
    $mail->Password = getenv("SMTP_PASSWORD");
    $mail->Port = getenv("SMTP_PORT");
    $mail->SMTPAuth = true;
    if (getenv("APPLICATION_ENV") !== "dev") {
        $mail->SMTPSecure = "tls";
    }
    $mail->Subject = "TODO";
    $mail->Username = getenv("SMTP_USERNAME");
    $mail->AddAddress("TODO");
    var_dump($mail->Send());

?>
