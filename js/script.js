function expandText(id) {
	var theText = document.getElementById(id);
	if (theText.style.display=='block'){
		theText.style.display = 'none';
	}else {
		theText.style.display = 'block';
	}
}