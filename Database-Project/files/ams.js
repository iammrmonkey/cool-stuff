var sn = 0;

function in_array(s, a){
    for(i = 0; i < a.length; i++){
        if (a[i] == s) {
            return true;
        }
    }
    return false;
}

function button_delete_condition_click(){

    $(this).parent().remove();
    var conditions = $('#ams_admin_queryform').find("div");
    if(conditions.length > 0){
        $(conditions[conditions.length - 1]).find('.ams_admin_operator').remove();
    }   
    return;
}

function ams_admin_menu(){
    // get the value of selected option
    var now_object = $(this);
    var option_value = now_object.val();
    var option_text = now_object.find(":selected").text();
    now_object.find("option:selected").removeAttr("selected");

    var type1_option = new Array(
        "alumni_rocid",
        "alumni_cname",
        "alumni_ename",
        "academic_studentid",
        "academic_department",
        "academic_degree",
        "academic_class",
        "association_memberid",
        "association_class",
        "company_name",
        "company_jobtitle",
        "company_type",
        "contact_type",
        "contact_value"
    );

    var type2_option = new Array(
        "alumni_sex",
        "alumni_status",
        "contact_class"
    );

    var type3_option = new Array(
        "alumni_birthdate",
        "academic_year",
        "company_time",
        "association_time"
    );

    var validate = false;
    var condition_text = "";
    if(in_array(option_value, type1_option)){
        condition_text = "<div>" + option_text + "<input type='text' name='" + option_value + "' value='' /> <input type='checkbox' name='not[]' value='" + option_value + "'> NOT</div>";
        validate = true;
    }else if(in_array(option_value, type2_option)){
        switch(option_value){
            case "alumni_sex":
                condition_text = "<div>" + option_text + "<input type='radio' name='" + option_value + "' value='Male'>Male <input type='radio' name='" + option_value + "' value='Female'>Female</div>";
                break;
            case "alumni_status":
                condition_text = "<div>" + option_text + "<input type='radio' name='" + option_value + "' value='Living'>Living <input type='radio' name='" + option_value + "' value='Dead'>Dead</div>";
                break;
            case "contact_class":
                condition_text = "<div>" + option_text + "<input type='radio' name='" + option_value + "' value='Personal'>Personal <input type='radio' name='" + option_value + "' value='Office'>Office</div>";
                break;
        }
        validate = true;
    }else if(in_array(option_value, type3_option)){
        condition_text = "<div>" + option_text + "<input type='text' name='" + option_value + "_start' value='' /> ~ <input type='text' name='" + option_value + "_end' value='' /> <input type='checkbox' name='not[]' value='" + option_value + "'> NOT</div>";
        validate = true;
    }

    if(validate){

        // add operator to last condition
        var conditions = $('#ams_admin_queryform').find("div");
        if(conditions.length > 0){
            var last_condition = $(conditions[conditions.length - 1]);
            last_condition.find('input[type="button"]').before("<select class='ams_admin_operator' name='bool[]'><option value='AND'>AND</option><option value='OR'>OR</option></select>");
        }

        // add new condition
        $('#ams_admin_queryform').append(condition_text);

        // add delete button to new condition
        var button_delete_condition = "<input class='ams_admin_deletecondition' type='button' value='Delete This Condition' />";
        conditions = $('#ams_admin_queryform').find("div");
        last_condition = $(conditions[conditions.length - 1]);
        last_condition.append(button_delete_condition);
        last_condition.find('input[type="button"]').click(button_delete_condition_click);
    }

    return;
}

$().ready(function(){
    // register the change event of menu
    $('#ams_admin_menu').change(ams_admin_menu);
    $("#ams_admin_menu option:selected").removeAttr("selected");
});
