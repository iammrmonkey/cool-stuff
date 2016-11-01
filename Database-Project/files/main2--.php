<?php
	ob_start();
	session_start();
?>
<html>
<head>
	<title>Welcome to our database system!</title>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">google.load("jquery", "1.6");</script>
    <script type="text/javascript" src="ams.js"></script>
</head>
<body background="../images/ggyy.jpg">
<h1 align= "center">Welcome to our database system!</h1></br>
<p align = "right"><a href = "edit.php" onClick = "setupForm.submit()">修改個人資料與隱私權設定</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href = "logout.php" onClick = "logoutForm.submit()">登出</a>
</p>
</br>
<p align="center"><img src="../images/ggyy2.jpg" align="middle" height="30%" width="60%"></p><p align="center"></p>

<form id="setupForm" method="post" action="edit.php">
	<input type="hidden" name="$_SESSION[\"username\"]" value="$_SESSION[\"password\"]">
</form>

<form id="logoutForm" method="post" action="logout.php">
	<input type="hidden" name="gg" value="yy">
</form>

<form enctype="multipart/form-data" method="post" action="loader.php" onClick = "readIn()">
	請載入CSV檔案:
	<input type="FILE" name="file" size=20 accept="csv"><br>
	<input type="submit" value="確認上傳">
	<input type="reset" value="重新上傳">
</form>

Select Condition
<select id="ams_admin_menu">
    <optgroup label="Alumnus Information">
    <option value="alumni_rocid">ROC ID</option>
    <option value="alumni_cname">Chinese Name</option>
    <option value="alumni_ename">English Name</option>
    <option value="alumni_birthdate">Birthdate</option>
    <option value="alumni_sex">Sex</option>
    <option value="alumni_status">Status</option>
    <optgroup label="Academic Degree Information">
    <option value="academic_studentid">Student ID</option>
    <option value="academic_department">Department</option>
    <option value="academic_degree">Degree</option>
    <option value="academic_class">Class</option>
    <option value="academic_year">Year of Graduation</option>
    <optgroup label="Work Information">
    <option value="company_name">Company Name</option>
    <option value="company_jobtitle">Job Title</option>
    <option value="company_type">Company Type</option>
    <option value="company_time">Work Period</option>
    <optgroup label="Association Information">
    <option value="association_memberid">Member ID</option>
    <option value="association_class">Member Class</option>
    <option value="association_time">Active Period</option>
    <optgroup label="Contact Information">
    <option value="contact_class">Contact Class</option>
    <option value="contact_type">Contact Type</option>
    <option value="contact_value">Contact Value</option>
</select>


<form action="" method="POST">
<div id="ams_admin_queryform"></div>

<input type="submit" name="submit"  value="Search">
</form>

<?php														//ɓƳƛŊ NOT (ƩРήΗȯ .js IžРɏħŪүȳֶȑ)
	if (isset($_POST['submit'])) {							//ŕͱʺѽǃ
		doSearch ( );
	}
	function doSearch ( ) {
		var_dump ($_POST);			//Ʃƈ͝ŀŕ dump ƘɓʺƜ݆ղۣŪק͏˸İܲ݋Ŭ
		echo "<br>";
		$query = 'SELECT * FROM ';
		$length = count($_POST);
		$i = 0; $j = 0;
		$tables= array(	array("alumni", false),
						array("company", false),
						array("alumni_contact", false),
						array("alumni association", false),
						array("academic degree", false));
		$key= array_keys($_POST);
		for ($i = 0; $i < $length-1; $i++) {
			if (strcmp($key[$i], "not")!=0 && strcmp($key[$i], "bool")!=0) {
				$cond [$j][0] = $key[$i];				//index
				$cond [$j][1] = $_POST[$key[$i]];				//datum
				if(substr_count($cond[$j][0], "alumni")>0)
					$tables[0][1]= true;
				else if(substr_count($cond[$j][0], "academic")>0)
					$tables[4][1]= true;
				else if(substr_count($cond[$j][0], "association")>0)
					$tables[3][1]= true;
				else if(substr_count($cond[$j][0], "company")>0)
					$tables[1][1]= true;
				else if(substr_count($cond[$j][0], "contact")>0)
					$tables[2][1]= true;
				$j++;				//增索引值
			} 
			else if(strcmp($key[$i], "bool")==0) {
				for($k = 0; $k < count($_POST["bool"]); $k++) {	
					$bool [$k] = $_POST["bool"][$k];		//後面接的是 AND 還是 OR 呢@@"
				}
			}
		
		}
		if(in_array("not", $key)){
			for($i=0;$i<count($cond);$i++){
				if(in_array($cond[$i][0], $_POST["not"]))
					$not[$i]= true;
				else
					$not[$i]= false;
			}
		}
		$first= true;
		for($i=0;$i<count($tables);$i++){
			if($tables[$i][1]){
				if($first)
					$first= false;
				else
					$query= $query." , ";
				$query= $query."`".$tables[$i][0]."`";
			}
		}
		$query= $query." WHERE ";
		echo '<br> cond: ';
		var_dump ($cond);
		echo "<br> bool: ";
		var_dump($bool);
		echo "<br> not:";
		var_dump($not);
		//要用很多個 if 來判斷 >"<
		for ($i = 0; $i < count($cond); $i++) {
			if (strpos ($cond[$i][0], "start") && strpos ($cond[$i+1][0], "end")){		//若資料類型為起迄點並存者
				$query = $query . '`'. $cond[$i][0] . '` '. '= ' . $cond[$i][1] . ' ' . 'AND ' .  '`'. $cond[$i+1][0] . '` '. '= ' . $cond[$i+1][1] . ' '; 
				/*寫 query 時自動補 AND，並且要進位*/ $i++;
			} else if ($cond[$i][1] == "Female") {
				$query = $query . '`'. $cond[$i][0] . '` '. '= "1"';
			} else if ($cond[$i][1] == "Male") {
				$query = $query . '`'. $cond[$i][0] . '` '. '= "0"';
			} else if ($cond[$i][1] == "Living") {
				$query = $query . '`'. $cond[$i][0] . '` '. '= "1"';
			} else if ($cond[$i][1] == "Dead") {
				$query = $query . '`'. $cond[$i][0] . '` '. '= "0"';
			} else if ($cond[$i][0] == "alumni_rocid") {	
				$query = $query . '`'. "ROC_ID" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][0] == "alumni_cname") {
				$query = $query . '`'. "Chinese Name" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][0] == "alumni_ename") {
				$query = $query . '`'. "English Name" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "academic_studentid") {
				$query = $query . '`'. "Student_ID" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "academic_department") {
				$query = $query . '`'. "Department" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "academic_degree") {
				$query = $query . '`'. "Degree" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "academic_class") {
				$query = $query . '`'. "Class" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "academic_year") {
				$query = $query . '`'. "Year" . '` '. '= "' . $cond[$i][1] . '"'; 		//Company_ID 要用到 join??
			} else if ($cond[$i][1] == "company_name") {								//名字剛好一樣XD
				$query = $query . '`'. "company_name" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "company_jobtitle") {
				$query = $query . '`'. "Job Title" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "company_type") {
				$query = $query . '`'. "company_type" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "association_memberid") {
				$query = $query . '`'. "Member_ID" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "association_class") {
				$query = $query . '`'. "Contact Class" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "contact_class") {
				$query = $query . '`'. "Contact Class" . '` '. '= "' . $cond[$i][1] . '"'; 		//好像都是 contact class????
			} else if ($cond[$i][1] == "contact_type") {
				$query = $query . '`'. "Type" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else if ($cond[$i][1] == "contact_value") {
				$query = $query . '`'. "Value" . '` '. '= "' . $cond[$i][1] . '"'; 
			} else {																	//ŏħǰˇſҠʺٜ
				$query = $query . '`'. $cond[$i][0] . '` '. '= "' . $cond[$i][1] . '"'; 	//ՎſҠࠩƘ query ՎǮ
			}
			if(in_array("bool", $key) && $i<count($cond)-1)
				$query= $query." ".$bool[$i]." ";
		}
		$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die ('Could not connect: ' . mysql_error());
		$db_selected = mysql_select_db("chho_cs");
		echo "<br> ".$query." <br>";
		$result = mysql_query ($query);								//Ԍ̡ՎγƹƨتՍ
		echo '<br>';
		if (mysql_fetch_row ($result) == 0) {
			echo 'Not Found';
		} else {
			echo '<table border = 1>';
			while (list($alumni_roc_id, $alumni_cname, $alumni_ename, $alumni_birthdate, $alumni_sex, $alumni_status) = mysql_fetch_row ($result) ) {
				echo '<tr>';
				echo '<td>';
				echo "{$alumni_cname}";
				echo '</td>';
				echo '<td>';
				echo "{$alumni_ename}";
				echo '</td>';
				echo '<td>';
				echo "{$alumni_sex}";
				echo '</td>';
				echo '</tr>';
			}
			echo '</table>';
		}
	}
?>
</body>

</body></html>
