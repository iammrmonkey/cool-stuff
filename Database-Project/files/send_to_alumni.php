<?php	
	$con = mysql_connect("dbhome.cs.nctu.edu.tw","chho_cs","p9408ty") or die ('Could not connect: ' . mysql_error());
	$db_selected = mysql_select_db("chho_cs");
	mysql_query("set names utf8");
?>
<html>
<head><title>管理者寄信介面</title></head>

<body>
<form action="send.php" method="post">
<table border=1 align="center">
	<tr><td>
	收信人:
	<?php
	
	$query= 'SELECT `Chinese Name`, `contact_value` FROM `alumni` a, `alumni_contact` c '.
			'WHERE a.`ROC_ID`=c.`ROC_ID` AND c.`contact_type`="email"'; 
	$result= mysql_query($query);
	$i= 0;
	while($row=mysql_fetch_assoc($result)){
		?> <input type="checkbox" name="address[]" value=<?php
		echo $row["contact_value"];
		?> > 
		<input type="hidden" name="receiver[]" value=<?
		echo $row["Chinese Name"]
		?> >
		<?php
		echo $row["Chinese Name"]."(".$row["contact_value"].") ";
		$i++;
		if($i%4==0)
			echo "<br>";
	}
	?>
	</td></tr>
	<tr>
	<td>標題:<input type="text" name="subject" size=90></td> 
	</tr>
	<tr>
	<td>內容:<textarea name="text" rows=25 cols=70></textarea></td>
	</tr>
	<tr>
	<td><input type="submit" name="send" value="傳送"></td>
	</tr>
</table>
</form>

</body>

</html>
<!--
http://belleaya.pixnet.net/blog/post/27410978-%5B%E6%95%99%E5%AD%B8%5D-php-%E5%88%A9%E7%94%A8-phpmailer-%E9%80%8F%E9%81%8E-gmail-%E5%AF%84%E4%BF%A1

-->
