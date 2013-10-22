/*
	js/profile.js
	Mike Perron (2013)

	Various javascript functionality specific to the profile viewer.
*/

var profile_tabs = ["profile_about", "profile_communications"];
var querystring = get_query_string();

function profile_init(){
	if("tab" in querystring){
		var tab=querystring["tab"];

		if(tab<profile_tabs.length)
			set_visible(profile_tabs[tab]);
	}
}

function set_visible(d){
	var l = profile_tabs.length;
	for(var i=0; i<l; i++){
		document.getElementById(profile_tabs[i]).style.display='none';
	}
	document.getElementById(d).style.display='block';
}


