({
	doInit : function(cmp) {

    var recordId = cmp.get("v.recordId");
    var output = '{"record": "' + recordId + '"}';
    cmp.set("v.parameters", output);

}
})