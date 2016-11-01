<?php session_start(); ?>
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
<?php //echo "Hi, ".$_SESSION['username']; ?><br>
<p align = "right"><a href = "edit.php" onClick = "setupForm.submit()">修改個人資料與隱私權設定</a>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href = "logout.php" onClick = "logoutForm.submit()">登出</a>
</p>
</br>
<p align="center"><img src="../images/ggyy2.JPG" align="middle" height="30%" width="60%"></p><p align="center"></p>

<form id="setupForm" method="post" action="edit.php">
	<input type="hidden" name="$_SESSION[\"username\"]" value="$_SESSION[\"password\"]">
</form>

<form id="logoutForm" method="post" action="logout.php">
	<input type="hidden" name="gg" value="yy">
</form>

<h4>搜尋校友條件：</h4>
<form action = "" method = "POST">
Chinese Name: <input type = "text" name = "search1" value = ""><br>
English Name: <input type = "text" name = "search2" value = ""><br>
Degree: <input type = "text" name = "search3" value = ""><br>
Department: <input type = "text" name = "search4" value = ""><br>
Class: <input type = "text" name = "search5" value = ""><br>
Year: <input type = "text" name = "search6" value = ""> ~ <input type = "text" name = "search7" value = ""><br>
<input type = "submit" name = "search8" value = "搜尋"><br>
</form>
<?php
	if (isset ($_POST["search8"])) {
		$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die ('Could not connect: ' . mysql_error());
		$db_selected = mysql_select_db("chho_cs");
		$sql = null;
		if (($_POST['search1'] || $_POST['search2'] || $_POST['search3'] || $_POST['search4'] || $_POST['search5'] || $_POST['search6'] || $_POST['search7'])) {
			$sql = "SELECT * FROM `alumni` AS A, `academic degree` AS B, `alumni_company` AS C, `alumni_contact` AS D, `company` AS E, `locks` AS F WHERE A.`ROC_ID` = B.`ROC_ID` AND B.`ROC_ID` = C.`ROC_ID` AND C.`ROC_ID` = D.`ROC_ID` AND D.`ROC_ID` = F.`ROC_ID` AND C.`Company_ID` = E.`Company_ID`";
			if ($_POST['search1'] != null) { $sql = $sql." AND A.`Chinese Name` = '$_POST[search1]'";}
			if ($_POST['search2'] != null) { $sql = $sql." AND A.`English Name` = '$_POST[search2]'";}
			if ($_POST['search3'] != null) { $sql = $sql." AND B.Degree = '$_POST[search3]'";}
			if ($_POST['search4'] != null) { $sql = $sql." AND B.Department = '$_POST[search4]'";}
			if ($_POST['search5'] != null) { $sql = $sql." AND B.Class = '$_POST[search5]'";}
			if ($_POST['search6'] != null) { $sql = $sql." AND B.Year >= '$_POST[search6]'";}
			if ($_POST['search7'] != null) { $sql = $sql." AND B.Year <= '$_POST[search7]'";}
			$result = mysql_query ($sql);
			var_dump ($sql);
			echo '<br>';
			var_dump ($result);
			echo '<br>';
			echo '<table border = 1>';
				echo '<tr>';
				echo '<th>Chinese Name</th><th>English Name</th><th>Department</th><th>Year</th><th>Class</th><th>Degree</th>';
				echo '<th>Sex</th><th>Company Name</th><th>Company Type</th><th>Job Title</th><th>Start Date</th><th>End Date</th><th>Contact Type</th><th>Contact Value</th>';
				echo '</tr>';
				while ($data = mysql_fetch_array ($result)) {
					if (!($data["lock_degree"] && $data["lock_alumni"] && $data["lock_company"] && $data["lock_contact"])	//只要其中一個沒有鎖上就可以把那個人的資料顯示出來
						 && !($data["lock_degree"] && $_POST['search3']) //如果從 degree 去搜尋就不要顯示 degree 已經鎖定的校友
						 && !($data["lock_alumni"] && ($_POST['search4'] || $_POST['search5'] || $_POST['search6'] || $_POST['search7']))) { //如果從 department, class, year 去搜尋就不要顯示 alumni 已經鎖定的校友
						echo '<tr>';
						echo '<td>';
						echo $data["Chinese Name"];
						echo '</td>';
						echo '<td>';
						echo $data["English Name"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_alumni"]) echo $data["Department"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_alumni"]) echo $data["Year"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_alumni"]) echo $data["Class"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_degree"]) echo $data["Degree"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_alumni"]) {
							if ($data["Sex"] == "0") {
								echo "男";
							} else {
								echo "女";
							}
						}
						echo '</td>';
						echo '<td>';
						if (!$data["lock_company"]) echo $data["company_name"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_company"])echo $data["company_type"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_company"])echo $data["Job Title"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_company"])echo $data["Start_date"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_company"])echo $data["End_date"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_contact"])echo $data["contact_type"];
						echo '</td>';
						echo '<td>';
						if (!$data["lock_contact"])echo $data["contact_value"];
						echo '</td>';
						echo '</tr>';
					}
				}
			echo '</table>';
		}
	}
?>
</body>

</body></html>
