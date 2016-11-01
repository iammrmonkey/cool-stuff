<!--
	Name:		loader.php
	Date: 		2012/5/18
	Version:	1.2
	Include:	function.php
	Description:
		Read CSV file and load into Datebase.
	Bugs:
		Schema in CSV file must always obey the rule.
		NO error handle.
		.csv my be ANSI encoding
		addContact_v2 -> which can identify some special value like: phone, fax, msn, address for
						 company, alumni.

-->
<?php
	require_once("function.php");
	connDatabase("dbhome.cs.nctu.edu.tw", "chho_cs", "p9408ty", "chho_cs");
	mysql_query("set names utf8");
	$file = file ($_FILES["file"]["tmp_name"]);
	for($i=0;$i<count($file);$i++){
		$file[$i]= mb_convert_encoding($file[$i], "UTF-8", "big5");
	}
	$schema= explode(",", $file[0]); // get schema of .csv
	$err= $schema[count($schema)-1];
	$schema[count($schema)-1]= substr($err, 0, strlen($err)-2);
	for($i=1;$i<count($file);$i++){
		$person= explode(",", $file[$i]);
		for($j=0;$j<count($schema);$j++){
			$schemaU[$j]= strtoupper($schema[$j]);
			$value[$schemaU[$j]]= $person[$j];
		}
		
		addAlumni($value["ROC ID"], $value["CHINESE NAME"], $value["ENGLISH NAME"],
				  $value["BIRTHDATE"], $value["SEX"], $value["STATUS"]);
		addCompany($value["COMPANY"], $value["TYPE"]);
		addAlumniAssociation($value["MEMBER ID"], $value["ROC ID"], 
							 $value["ALUMNI CLASS"], $value["STARTING DATE"],
							 $value["EXPIRATION DATE"]);
							 
		addAlumniCompany($value["ROC ID"],$value["JOB TITLE"], $value["START DATE"],
						 $value["END DATE"], $value["COMPANY"], $value["TYPE"]);
		// add Academic Degree
		addAcademicDegree($value["B.S._STUDENT ID"], $value["ROC ID"], $value["B.S."], 
						  $value["B.S._YEAR"], $value["B.S._CLASS"], "B.S.");
		addAcademicDegree($value["M.S._STUDENT ID"], $value["ROC ID"], $value["M.S."], 
						  $value["M.S._YEAR"], "", "M.S.");
		addAcademicDegree($value["PH.D_STUDENT ID"], $value["ROC ID"], $value["PH.D"], 
						  $value["PH.D_YEAR"], "", "Ph.D");
		addContact_v2($schema, $value);
	}

?>
<!--
	
	== 開檔讀檔 ==========================================================
	fpassthru($file) ... 讀取整個檔案, 並印出來
	fread ( $file , length ) ... 讀取length長度的字串
	fgetc( $file ) ... 讀取一個字元
	file($file) ... 傳回以array形式 $file[0] => string
	
	**fgetcsv()
	======================================================================
	
	== 字串處理 ==========================================================
	explode("," , $string) ... 以","為切割符, 切割string, => string array
	======================================================================
-->

