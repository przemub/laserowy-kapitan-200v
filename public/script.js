function work(e) {
	e.preventDefault();
	
	var chosenSources = [];
	var sourceCheckboxes = document.getElementsByName("source");
	for (var i = 0; i < sourceCheckboxes.length; i++)
		if (sourceCheckboxes[i].checked)
			chosenSources.push(sourceCheckboxes[i].value);
		
	if (chosenSources.length == 0)
		return false;
	
	var http = new XMLHttpRequest();
	http.open("GET", "/api/" + chosenSources.join(), true);
	http.send();
	
	http.onload = function() {
		var output = document.getElementById("output");
		output.value = http.responseText;
		output.scrollTop = 0;
		output.scrollIntoView();
	}
	
	return false;
}
