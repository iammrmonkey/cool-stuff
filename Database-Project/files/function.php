<html>
<?php
	function connDatabase($host, $account, $passwd, $database){
		$link= mysql_connect($host, $account, $passwd)
			or die("資料庫連結失敗");
		$db= mysql_select_db($database)
			or die("資料庫選擇失敗");
	}
	
	function select_tuple($table, $schema, $value){
		// 任何一筆符合選項者
		$result= mysql_query("SELECT * FROM '$table' WHERE '$schema' = '$value'");
		while($tuple= mysql_fetch_assoc($result)){
			echo $tuple."<br>";
		}
	}
	
	function update($table, $schema, $value, $optionS, $optionV){
		$query= "UPDATE '$table' SET '$schema' = ".
				"'$value' WHERE 'optionS' = 'optionV'";
		mysql_query($query);
	}
	
	function delete($table, $optionS, $optionV){
		$query= "DELETE FROM '$table' WHERE '$optionS' = 'optionV'";
		mysql_query($query);
	}

	/********************************************************************/
	function addAcademicDegree($id, $roc, $dep, $year, $class, $deg){
		$query= "INSERT INTO `academic degree` ".
				"(`Student_ID`, `ROC_ID`, `Department`, `Year`, `Class`, `Degree`)".
				"VALUES ('$id', '$roc', '$dep', '$year', '$class', '$deg')";
		mysql_query($query);
	}
	
	function addAdministrator($acc, $name, $passwd){
		$query= "INSERT INTO `administrator`".
				"(`Account`, `Name`, `Password`)".
				"VALUES ('$acc', '$name', '$passwd')";
		mysql_query($query);
	}
	
	function addAdministratorContact($acc, $type, $value){
		if($value=="")
			return;
		$query= "INSERT INTO `administrator_contact`".
				"(`Account`, `Type`, `Value`)".
				"VALUES ('$acc', '$type', '$value')";
		mysql_query($query);
	}
	
	function addAlumni($id, $cn, $en, $bir, $sex, $st){
		$sex=(strcmp($sex, "男")==0?1:0);
		$st= (strcmp($st, "存")==0?1:0);
		$query= "INSERT INTO `alumni`".
				"(`ROC_ID`, `Chinese_Name`, `English_Name`, ".
				"`Birthday`, `Sex`, `Status`)".
				"VALUES ('$id', '$cn', '$en', '$bir', '$sex', '$st')";
		mysql_query($query);
	}
	
	function addAlumniAssociation($id, $roc, $class, $start, $end){
		$query= "INSERT INTO `alumni association`".
				"(`Member_ID`, `ROC_ID`, `Class`, `Starting_date`, `Expiration_date`)".
				"VALUES ('$id', '$roc', '$class', '$start', '$end')";
		mysql_query($query);
	}
	
	function addAlumniCompany($roc, $title, $start, $end, $com, $type){
		$query= "SELECT `Company_ID` FROM `company` WHERE `name` = '$com' and `Type` = '$type'";
		$result= mysql_query($query);
		if(!mysql_fetch_assoc($result))
			return ;
		$id= mysql_fetch_assoc($result);
		$id= $id["Company_ID"];
		$query= "INSERT INTO `alumni_company`".
				"(`Company_ID`, `ROC_ID`, `Job_title`, `start_date`, `End_date`)".
				"VALUES ('$id', '$roc', '$title', '$start', '$end')";
		mysql_query($query);
	}
	
	function addAlumniContact($roc, $type, $value){
		if(strcmp($value, "")==0)
			return;
		$query= "INSERT INTO `alumni_contact`".
				"(`ROC_ID`, `Type`, `Value`)".
				"VALUES ('$roc', '$type', '$value')";
		mysql_query($query);
	}
	
	function addCompany($name, $type){
		$query= "SELECT * FROM `company` ".
				"WHERE `Name` = '$name' and `Type` = '$type'";
		$result= mysql_query($query);
		if(!mysql_num_rows($result)){
			$query= "INSERT INTO `company`".
					"(`Name`, `Type`)".
					"VALUES ('$name', '$type')";
			mysql_query($query);
		}
	}
	
	function addCompanyContact($com, $cType, $type, $value){
		if($value=="")
			return;
		$query= "SELECT `Company_ID` FROM `company` WHERE `name` = '$com' and `Type` = '$cType'";
		$result= mysql_query($query);
		if(!mysql_num_rows($result))
			return ;
		$id= mysql_fetch_assoc($result);
		$id= $id["Company_ID"];
		$query= "INSERT INTO `company_contact`".
				"(`Company_ID`, `Type`, `Value`)".
				"VALUES ('$id', '$type', '$value')";
		mysql_query($query);
	}
	function addContact_v2($schema, $value){
		// 傳入schema及schema對應到的array
		// 可判斷schema: phone
		for($i=0;$i<count($schema);$i++){
			$schemaU= strtoupper($schema[$i]);
			if(substr_count($schemaU, "PHONE")>0 || substr_count($schemaU, "MSN")>0 ||
			   substr_count($schemaU, "ADDRESS")>0 || substr_count($schemaU, "EMAIL")>0 ||
			   substr_count($schemaU, "FAX")>0){
				if(substr_count($schemaU, "COMPANY")>0)
					addCompanyContact($value["COMPANY"], $value["TYPE"], $schema[$i], $value[$schemaU]);
				else if(substr_count($schemaU, "ADMINISTRATOR")>0)
					addAdministratorContact($value["ADMINISTRATOR"], $schema[$i], $value[$schemaU]);
				else
					addAlumniContact($value["ROC ID"], $schema[$i], $value[$schemaU]);
			}
		}
	}
	// substr_count(string1, string2) => 查詢string2在string1出現次數
	// strtoupper(string) => to upper case
?>



</html>