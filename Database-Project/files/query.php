<html>
<head>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <script type="text/javascript" src="http://www.google.com/jsapi"></script>
    <script type="text/javascript">google.load("jquery", "1.6");</script>
    <script type="text/javascript" src="ams.js"></script>
</head>
<body>


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
<input type="submit" value="Search">
</form>

</body>
</html>