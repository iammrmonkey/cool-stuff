<?php 
	session_start(); 
	if(isset($_SESSION["LOGIN_FAILED"])){
		if($_SESSION["LOGIN_FAILED"]>=5){
			echo "重覆登入錯誤 , 稍後再試";
			exit;
		}
	}
?>
<html>
<head>
<title>Welcome to our database system!</title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body background = "images/ggyy.jpg">
<h1> Welcome to our database system!</h1>
<br>
<h4> "Professor Peng I love you. I am a gay."</h4>
<p align = "right"><i>-danmer</i></p>
<hr color = "red">
<br>
<p> This is our database system. Please type in your <b>account name</b> and <b>password</b> in the following text boxes:</p>

<form action = "files/auth.php" method = "post" name = "ggyy" onload = "isHaha()" onsubmit = "return isEmpty()">
Account name: <input type = "text" id = "accountname" name = "accountname"> <br>
Password: <input type = "password" id = "password" name = "password"> <br>
<!-- 驗證碼 -->
<div>
<div style="float:left;"><img src="captcha/code.php" id="captcha"></div>

<div>Are you a human?<br>
<input type="text" name="Turing" value="" size="10">
[ <a href="#" onclick=" document.getElementById('captcha').src = document.getElementById('captcha').src + '?' + (new Date()).getMilliseconds()">Refresh Image</a> ] 
</div>
</div>
<?php
	if(isset($_SESSION["CAPTCHA"])){
		if(!$_SESSION["CAPTCHA"])
			echo "<b><font color=red>The Captcha Code you entered is invalid. Please press the Back button of your browser and try again</font></b><br>";
		$_SESSION["CAPTCHA"]= true;
	}
?>
<!-- 驗證碼 -->
<input type = "submit" name = "submit" value = "submit"> <br>
註：密碼預設為身分證字號 <br>
</form>

<script language = "javascript">
function isEmpty ( ) {
	if (ggyy.accountname.value == ""){
		alert("empty accountname. GGYY.")
		return false
	}else if(ggyy.password.value == ""){
		alert("empty password. GGYY.")
		return false
	}else if(ggyy.Turing.value == ""){
		alert("empty captcha. GGYY.")
		return false
	}
	return true
}
function isHaha ( ) {
	ggyy.accountname.value = " "
	ggyy.password.value = " "
}
</script>

</body>

</html>