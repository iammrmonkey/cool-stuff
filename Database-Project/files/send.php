<?php
	require_once("../phpmailer/class.phpmailer.php");
	
	//宣告一個PHPMailer物件
	$mail = new PHPMailer();

	//設定使用SMTP發送
	$mail->IsSMTP();

	//指定SMTP的服務器位址
	$mail->Host = "localhost";
	//設定SMTP服務的POST
	$mail->Port = 25;

	//設定為安全驗證方式
	$mail->SMTPAuth = false;

	//SMTP的帳號
	$mail->Username = "";
	//SMTP的密碼
	$mail->Password = "";

	$mail->From = "danmer.cs99@nctu.edu.tw";
	//寄件人名稱
	$mail->FromName = "Admin";

	//設定信件字元編碼
	$mail->CharSet="utf-8";
	//設定信件編碼，大部分郵件工具都支援此編碼方式
	$mail->Encoding = "base64";
	//設置郵件格式為HTML
	$mail->IsHTML(true);
	//每50自斷行
	$mail->WordWrap = 50;


	//郵件標題
	$mail->Subject=$_POST["subject"];
	//郵件內容
	$mail->Body = $_POST["text"];

	//寄送郵件
	$receiver= $_POST["receiver"];
	$address= $_POST["address"];
	for($i=0;$i<count($_POST["address"]);$i++){
		//收件人Email
		$mail->AddAddress($address[$i], $receiver[$i]);
		if(!$mail->Send()){
			echo "郵件無法順利寄出!";
			echo "Mailer Error: " . $mail->ErrorInfo."<br>";
		}else
		echo "給 ".$receiver[$i]."(".$address[$i].") 的郵件已經順利寄出!<br>";
	}//*/
?>