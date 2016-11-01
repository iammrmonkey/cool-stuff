<?php
		session_start ( );
		$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die ('Could not connect: ' . mysql_error());
		$db_selected = mysql_select_db("chho_cs");
		//$sql = 'SELECT * FROM `academic degree` WHERE `Student_ID` = "$_SESSION[username]" AND `ROC_ID` = "$_SESSION[password]"';
		$sql = "SELECT * FROM `academic degree` WHERE `ROC_ID` = '$_SESSION[password]'";
		list ($alumni_studentid, $alumni_rocid, $alumni_department, $alumni_year, $alumni_class, $alumni_degree) = mysql_fetch_row (mysql_query ($sql));
		$sql = "SELECT * FROM `alumni` WHERE `ROC_ID` = '$_SESSION[password]'";
		list ($alumni_rocid, $alumni_cname, $alumni_ename, $alumni_birthdate, $alumni_sex, $alumni_status) = mysql_fetch_row (mysql_query ($sql));
		$sql = "SELECT * FROM `alumni association` WHERE `ROC_ID` = '$_SESSION[password]'";
		list ($alumni_memberid, $alumni_rocid, $alumni_contact_class, $alumni_starting_date, $alumni_expiration_date) = mysql_fetch_row (mysql_query ($sql));
		$sql = "SELECT * FROM `alumni_company` WHERE `ROC_ID` = '$_SESSION[password]'";
		list ($alumni_companyid, $alumni_rocid, $alumni_jobtitle, $alumni_start_date, $alumni_end_date) = mysql_fetch_row (mysql_query ($sql));
		$sql = "SELECT * FROM `company` WHERE `Company_ID` = '$alumni_companyid'";
		list ($alumni_companyid, $alumni_company_name, $alumni_company_type) = mysql_fetch_row (mysql_query ($sql));
		$sql = "SELECT * FROM `locks` WHERE `ROC_ID` = '$_SESSION[password]'";
		list ($alumni_rocid, $lock_degree, $lock_alumni, $lock_company, $lock_contact) = mysql_fetch_row (mysql_query ($sql));
		var_dump ($lock_degree); echo '<br>';
		var_dump ($lock_alumni); echo '<br>';
		var_dump ($lock_company); echo '<br>';
		var_dump ($lock_contact); echo '<br>';
?>
<html>
<head>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
	<b>您的個人資料如下：</b><br><br>
	<form action = "check_edit.php" id = "editForm" name = "editForm" method = "post">
		
		<input type = "hidden" name = "alumni_rocid" value = "<?php $var[0] = $alumni_rocid; echo "$var[0]"; ?>">
		<input type = "hidden" name = "alumni_studentid" value = "<?php $var[1] = $alumni_studentid; echo "$var[1]"; ?>">
		<input type = "hidden" name = "alumni_cname" value = "<?php $var[2] = $alumni_cname; echo "$var[2]";?>">
		<input type = "hidden" name = "alumni_ename" value = "<?php $var[3] = $alumni_ename; echo "$var[3]";?>">
		<input type = "hidden" name = "alumni_birthdate" value = "<?php $var[4] = $alumni_birthdate; echo "$var[4]"; ?>">
		<input type = "hidden" name = "alumni_sex" value = "<?php $var[5] = $alumni_sex; echo "$var[5]";?>" >
		<input type = "hidden" name = "alumni_status" value = "<?php $var[6] = $alumni_status; echo "$var[6]";?>" >
		
		
		身分證字號：<input type = "text" name = "alumni_rocid" value = "<?php $var[0] = $alumni_rocid; echo "$var[0]"; ?>" disabled = "true"><br>
		學號：<input type = "text" name = "alumni_studentid" value = "<?php $var[1] = $alumni_studentid; echo "$var[1]"; ?>" disabled = "true"><br>
		中文姓名：<input type = "text" name = "alumni_cname" value = "<?php $var[2] = $alumni_cname; echo "$var[2]";?>" disabled = "true"><br>
		英文姓名：<input type = "text" name = "alumni_ename" value = "<?php $var[3] = $alumni_ename; echo "$var[3]";?>" disabled = "true"><br>
		生日：<input type = "text" name = "alumni_birthdate" value = "<?php $var[4] = $alumni_birthdate; echo "$var[4]"; ?>" disabled = "true"><!--yyyy-mm-dd--><br>
		性別：<input type = "radio" name = "alumni_sex" value = "Male" disabled = "true" <?php $var[5] = $alumni_sex; if ($alumni_sex = 0) echo "checked";?> >Male
		<input type = "radio" name = "alumni_sex" value = "Female" disabled = "true" <?php $var[5] = $alumni_sex; if ($alumni_sex = 1) echo "checked";?> >Female<br>
		存歿：<input type = "radio" name = "alumni_status" value = "Living" disabled = "true" <?php $var[6] = $alumni_status; if ($alumni_status = 1) echo "checked";?> >Living
		<input type = "radio" name = "alumni_status" value = "Dead" disabled = "true" <?php $var[6] = $alumni_status; if ($alumni_status = 0) echo "checked";?>>Dead<br>
		<!---------------------以上不能修改--------------------->
		系所：<input type = "text" name = "academic_department" value = "<?php $var[7] = $alumni_department; echo "$var[7]"; ?>"><br>
		畢業年份：<input type = "text" name = "academic_year" value = "<?php $var[8] = $alumni_year; echo "$var[8]"; ?>"><br>
		學位：<input type = "text" name = "alumni_degree" value = "<?php $var[9] = $alumni_degree; echo "$var[9]"; ?>"><br>
		班級：<input type = "text" name = "alumni_class" value = "<?php $var[10] = $alumni_class; echo "$var[10]"; ?>"><br>
		校友會 ID：<input type = "text" name = "association_memberid" value = "<?php $var[11] = $alumni_memberid; echo "$var[11]"; ?>"><br>
		校友會班級：<input type = "text" name = "association_class" value = "<?php $var[12] = $alumni_contact_class; echo "$var[12]"; ?>"><br>
		校友會起自 <input type = "text" name = "association_timestart" value = "<?php $var[13] = $alumni_starting_date; echo "$var[13]"; ?>"> 終至 <input type = "text" name = "association_timeend" value = "<?php $var[14] = $alumni_expiration_date; echo "$var[14]"; ?>"><br>
		公司名稱：<input type = "text" name = "company_name" value = "<?php $var[15] = $alumni_company_name; echo "$var[15]"; ?>"><br>
		公司職位：<input type = "text" name = "company_jobtitle" value = "<?php $var[16] = $alumni_jobtitle; echo "$var[16]"; ?>"><br>
		任職起自 <input type = "text" name = "company_timestart" value = "<?php $var[17] = $alumni_start_date; echo "$var[17]"; ?>"> 終至 <input type = "text" name = "company_timeend" value = "<?php $var[18] = $alumni_end_date; echo "$var[18]"; ?>"><br>
		公司類型：<input type = "text" name = "company_type" value = "<?php $var[19] = $alumni_company_type; echo "$var[19]"; ?>"><br>
		聯絡方式：<input type = "text" name = "contact_type" value = "<?php $var[20] = $alumni_contact_type; echo "$var[20]"; ?>"><br>
		聯絡電話：<input type = "text" name = "contact_value" value = "<?php $var[21] = $alumni_contact_value; echo "$var[21]"; ?>"><br>
		<!--<input type = "submit" name = "add_contact" value = "新增一筆聯絡資料" action = "edit.php">-->
		<br>
		<b>關於您的隱私權設定：</b>
		<br><br>
		是否要顯示個人資訊：<!--chinese name, english name, sex@alumni-->
		<input type = "radio" name = "show1" value = "Yes" <?php $var[22] = $lock_alumni; if ($lock_alumni == 0) { ?> checked <?php } ?>>Yes
		<input type = "radio" name = "show1" value = "No" <?php $var[22] = $lock_alumni; if ($lock_alumni !=0){ ?> checked <?php } ?>>No<br>
		是否要顯示最高學位：<!--degree@academic degree-->
		<input type = "radio" name = "show2" value = "Yes" <?php $var[23] = $lock_degree; if ($lock_degree == 0) { ?> checked <?php } ?>>Yes
		<input type = "radio" name = "show2" value = "No" <?php $var[23] = $lock_degree; if ($lock_degree !=0){ ?> checked <?php } ?>>No<br>
		是否要顯示工作資訊：<!--all@alumni_company-->
		<input type = "radio" name = "show3" value = "Yes" <?php $var[24] = $lock_company; if ($lock_company == 0) { ?> checked <?php } ?>>Yes
		<input type = "radio" name = "show3" value = "No" <?php $var[24] = $lock_company; if ($lock_company !=0){ ?> checked <?php } ?>>No<br>
		是否要顯示聯絡方式：<!--all@alumni_contact-->
		<input type = "radio" name = "show4" value = "Yes" <?php $var[25] = $lock_contact; if ($lock_contact == 0) { ?> checked <?php } ?>>Yes
		<input type = "radio" name = "show4" value = "No" <?php $var[25] = $lock_contact; if ($lock_contact !=0){ ?> checked <?php } ?>>No<br>
		<input type = "submit" name = "ok" value = "確認修改">
		<input type = "submit" name = "cancel" value = "放棄修改">
	</form>
	
</body>
</html>
