<!DOCTYPE html>

<html>
    <head>
        <title>example</title>
    </head>
    <body>
        <pre><?php

            require_once("libphp-phpmailer/class.phpmailer.php");

            $mail = new PHPMailer();
            $mail->IsSMTP();
            $mail->SetFrom("TODO");
            $mail->Body = "TODO";
            $mail->Host = getenv("SMTP_HOST");
            $mail->Password = getenv("SMTP_PASSWORD");
            $mail->Port = getenv("SMTP_PORT");
            $mail->SMTPAuth = true;
            $mail->SMTPSecure = "tls";
            $mail->Subject = "TODO";
            $mail->Username = getenv("SMTP_USERNAME");
            $mail->AddAddress("TODO");
            print($mail->Send());

        ?></pre>
    </body>
</html>
