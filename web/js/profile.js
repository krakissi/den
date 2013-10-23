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
		else set_visible(profile_tabs[0]);
	} else set_visible(profile_tabs[0]);
}

function set_visible(d){
	var l = profile_tabs.length;
	var tabid;

	for(var i=0; i<l; i++){
		document.getElementById(profile_tabs[i]).style.display='none';
		if(tabid = document.getElementById("tab_"+profile_tabs[i]))
			tabid.style.backgroundColor="#e0e0e0";
	}
	document.getElementById(d).style.display='block';
	if(tabid = document.getElementById("tab_"+d))
		tabid.style.backgroundColor="#ffffff";
}
