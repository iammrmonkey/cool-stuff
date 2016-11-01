<?php
	session_start ( );
	$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die ('Could not connect: ' . mysql_error());
	$db_selected = mysql_select_db("chho_cs");
	if ($_POST['ok']){
		if ($_POST['academic_department']) {
			$sql = "update `academic degree` set `Department` = '$_POST[academic_department]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['academic_year']) {
			$sql = "update `academic degree` set `Year` = '$_POST[academic_year]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['alumni_degree']) {
			$sql = "update `academic degree` set `Degree` = '$_POST[alumni_degree]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['alumni_class']) {
			$sql = "update `academic degree` set `Class` = '$_POST[alumni_class]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['association_memberid']) {
			$sql = "update `academic degree` set `Member_ID` = '$_POST[alumni_memberid]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['association_class']) {
			$sql = "update `alumni association` set `Contact Class` = '$_POST[alumni_contact_class]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['association_timestart']) {
			$sql = "update `alumni association` set `Starting_date` = '$_POST[alumni_starting_date]' where `Student_ID` = '$_POST[alumni_studentid]' ";
			mysql_query ($sql);
		} if ($_POST['company_name']) {
			$sql = "update `alumni_company` as A, `company` as B set B.`company_name` = '$_POST[company_name]' where A.`Company_ID` = B.`Company_ID` AND A.`Student_ID` = '$_POST[alumni_studentid]' ";
			var_dump ($sql);
		} if ($_POST['company_jobtitle']) {
			$sql = "update `alumni_company` set `Job Title` = '$_POST[alumni_jobtitle]' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			mysql_query ($sql);
		} if ($_POST['company_timestart']) {
			$sql = "update `alumni_company` set `Start_date` = '$_POST[alumni_start_date]' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			mysql_query ($sql);
		} if ($_POST['company_type']) {
			$sql = "update `alumni_company` as A, `company` as B set B.`company_type` = '$_POST[company_type]' where A.`Company_ID` = B.`Company_ID` AND A.`Student_ID` = '$_POST[alumni_studentid]' ";
			var_dump ($sql);
		} if ($_POST['contact_type']) {
			$sql = "update `alumni_contact` set `contact_type` = '$_POST[alumni_contact_type]' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			mysql_query ($sql);
		} if ($_POST['contact_value']) {
			$sql = "update `alumni_contact` set `contact_value` = '$_POST[alumni_contact_value]' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			mysql_query ($sql);
		} if ($_POST['show1']) {
			if ($_POST['show1'] = "Yes") {
				$sql = "update `locks` set `lock_alumni` = '0' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			} else if ($_POST['show1'] = "No") {
				$sql = "update `locks` set `lock_alumni` = '1' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			}
		} if ($_POST['show2']) {
			if ($_POST['show2'] = "Yes") {
				$sql = "update `locks` set `lock_degree` = '0' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			} else if ($_POST['show2'] = "No") {
				$sql = "update `locks` set `lock_degree` = '1' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			}
		} if ($_POST['show3']) {
			if ($_POST['show3'] = "Yes") {
				$sql = "update `locks` set `lock_company` = '0' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			} else if ($_POST['show3'] = "No") {
				$sql = "update `locks` set `lock_company` = '1' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			}
		} if ($_POST['show4']) {
			if ($_POST['show4'] = "Yes") {
				$sql = "update `locks` set `lock_contact` = '0' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			} else if ($_POST['show4'] = "No") {
				$sql = "update `locks` set `lock_contact` = '1' where `ROC_ID` = '$_POST[alumni_rocid]' ";
			}
		}
	}
	//header ("Location: main.php");
?>
<html>
<head>
<title></title>
<meta http-equiv="content-type" content="text/html; charset=UTF-8" />
</head>
<body>
</body>
</html>