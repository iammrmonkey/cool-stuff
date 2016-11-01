<?php
	ob_start ( );
	session_start();
	// captcha
	$Code = $_POST["Turing"]; 
	// captcha
	$username = $_POST['accountname'];
	$password = $_POST['password'];
	
	$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die('Could not connect: ' . mysql_error());
	$db_selected = mysql_select_db("chho_cs") or die('Could not select database: ' . mysql_error());
	$sql = "SELECT * FROM `administrator` WHERE `Account` = '$username' AND `Password` = '$password'";
	var_dump (mysql_query($sql));
	if ( strtoupper($_SESSION['turing_string']) != strtoupper($Code) ){
		$_SESSION["CAPTCHA"]= false;
		header ("Location: ../index.php");
	}
	else if (mysql_num_rows(mysql_query($sql)) > 0) {
		$_SESSION['username'] = $username;
		$_SESSION['password'] = $password;
		header ("Location: main2--.php");
	} else {
		$sql = "SELECT * FROM `academic degree` WHERE `Student_ID` = '$username' AND `ROC_ID` = '$password'";
		if (mysql_num_rows(mysql_query($sql)) > 0) {
			$_SESSION['username'] = $username;
			$_SESSION['password'] = $password;
			header ("Location: main.php");
		} else {
			$_SESSION['username'] = null;
			$_SESSION['password'] = null;
			if(isset($_SESSION["LOGIN_FAILED"]))
				$_SESSION["LOGIN_FAILED"]++;
			else
				$_SESSION["LOGIN_FAILED"]= 1;
			header ("Location: ../index.php");
		}
	}
	ob_end_flush();
	mysql_close($con);
?>
<HTML>
</HTML>