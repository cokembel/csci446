// submit.js

function submission() {
	var currentFeeling=document.forms["feelingForm"]["currentFeeling"].value;

	if(currentFeeling == '') {
		alert("Surely you feel something!");
	}
}