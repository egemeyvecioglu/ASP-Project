"use strict";

/* keeps track of drawn blocks. an array of DOM elements. */
var blocks = [];

/* keeps track of current possible schedules.
 * elements of schedules are arrays of time periods, which has elements like
 * {"d": day, "s": start, "e": end, "c": color, "t": text}. */
var schedules = [];
var current_schedule = 0;

/* color palette. course colors are selected with get_color() from this. */
var palette = ["#fcdfdf", "#fcebdf", "#dffce1", "#dffcfa", "#dff3fc", "#dfe6fc", "#e4dffc", "#f0dffc"];

/* shuffle palette, get next color. if we run out of colors, shuffle again.
 * http://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array */
function shuffle(a) {
    var j, x, i;
    for (i = a.length; i; i--) {
        j = ~~(Math.random() * i);
        x = a[i - 1];
        a[i - 1] = a[j];
        a[j] = x;
    }
}

var current_color = 0;
shuffle(palette);

function get_color(){
	if (current_color >= palette.length) {
		shuffle(palette);
		current_color = 0;
	}
	return palette[current_color++];
}

/* tetick will keep track of schedule time in minutes.
 * we call this to translate the inner representation to something like 16:30. */
function to_clock(min){
	var a = (min % 60).toString();
	if (a.length == 1) a = "0" + a;
	return Math.floor(min/60).toString() + ":" + a;
}

/* by default, 08:40 to 17:30 */
var day_start = 520, day_end = 1050;

/* draw a block on the table col "day"- from start to end.
 * assumes end > start, if not, weird results can emerge.
 * returns the dom element it makes. */
function block(day, place, start, end, text){
	var out = document.createElement("div");
	out.className += "block";
	out.style.backgroundColor = get_color();
	var tempHeight = (100 * (end - start) / (day_end - day_start));
	tempHeight = tempHeight;
	out.style.height = tempHeight.toString() + "%";
	out.style.top = (100 * (start - day_start) / (day_end - day_start)).toString() + "%";
	out.innerHTML = text + "<br>" + to_clock(start) + " - "  + to_clock(end);
	document.getElementById(day).querySelector("." + place).appendChild(out);
	blocks.push(out);
	return out;
}

/* navigate schedules. */
function prev(){
	current_schedule--;
	if (current_schedule < 0)
		current_schedule = schedules.length - 1;
	draw();
}
function next(){
	current_schedule++;
	if (current_schedule >= schedules.length)
		current_schedule = 0;
	draw();
}
document.getElementById("prev").onclick = prev;
document.getElementById("next").onclick = next;
document.onkeydown = function(ev){
	if(ev.keyCode == "37") prev();
	if(ev.keyCode == "39") next();
};

/* draw the current state on the schedule.
 * first we get the latest hour on the schedule and adjust day_end. it defaults to 1050.
 * this can be easily extended to have adjustable day_start too, it is just that I have never seen a course before 8:40.
 * then we draw don't fills, then if state is not blank, we draw courses. there are don't fills in
 * schedules, we ignore them while drawing. */
function draw(){
	var i;

	/* clear the schedule by deleting all drawn blocks. */
	for (i=0; i < blocks.length; i++)
		blocks[i].remove();
	blocks = [];

	if (current_schedule >= schedules.length)
		current_schedule = 0;

	var sch = schedules[current_schedule];
	if(sch && sch.length) {
		for(i=0; i<sch.length; i++)
			if (sch[i].e > day_end)
				day_end = sch[i].e;

		for(i=0; i<sch.length; i++){
			if(!sch[i].t) continue;
			var a = block(sch[i].day, sch[i].place, sch[i].s, sch[i].e, sch[i].t);
		}
		document.getElementById("counter").innerHTML = (current_schedule+1).toString() + " / " + schedules.length;
	}
	document.getElementById("start_time").innerHTML = to_clock(day_start);
	document.getElementById("end_time").innerHTML = to_clock(day_end);
}

/* main */
const fileSelector = document.getElementById('file_selector');
fileSelector.addEventListener('change', () => {
	const [file] = fileSelector.files;
	const reader = new FileReader();
	reader.addEventListener(
		"load",
		() => {
			const lines = reader.result.split("\n");

			for (var lineIndex = 3; lineIndex < lines.length && lines[lineIndex].slice(0, 6) == "Answer"; lineIndex += 2) {
				const line = lines[lineIndex + 1];
				const assignments = line.split(' ');

				var new_schedule = [];
				for (var assignmentIndex = 0; assignmentIndex < assignments.length; assignmentIndex++) {
					const assignment = assignments[assignmentIndex];
					const assignment_information = assignment.match(/\w+/g);
					
					const course_code = assignment_information[1].toUpperCase();
					const day = assignment_information[2];
					const start_hour = parseInt(assignment_information[3]);
					const place = assignment_information[4];
					const lecturer = assignment_information[5];
					const section = assignment_information[6];

					new_schedule.push({
						s: start_hour * 60 + 40,
						e: start_hour * 60 + 90,
						day: day,
						place: place,
						t: course_code + "." + section + "<br>" + lecturer
					})
				}
				schedules.push(new_schedule)
			}

			draw();
		},
		false,
	);
	reader.readAsText(file);
});
