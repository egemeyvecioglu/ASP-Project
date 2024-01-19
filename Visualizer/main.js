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

var day_names = ["mon", "tue", "wed", "thu", "fri"];
var place_names = ["bmb1", "bmb2", "bmb3", "bmb4", "bmb5", "bmb_a101", "g101"];

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
			if (!sch[i].t)
				continue;
			block(sch[i].day, sch[i].place, sch[i].s, sch[i].e, sch[i].t);
		}
		document.getElementById("counter").innerHTML = (current_schedule+1).toString() + " / " + schedules.length;
	}
	document.getElementById("start_time").innerHTML = to_clock(day_start);
	document.getElementById("end_time").innerHTML = to_clock(day_end);
}

const hoca_constant_name_mapping = new Map([
	["gokturk_ucoluk", "Göktürk Üçoluk"],
	["sinan_kalkan", "Sinan Kalkan"],
	["ahmet_oguz_akyuz", "Ahmet Oğuz Akyüz"],
	["ayse_nur_birturk", "Ayşenur Birtürk"],
	["ayse_yasemin_seydim", "Ayşe Yasemin Seydim"],
	["cevat_sener", "Cevat Şener"],
	["emre_akbas", "Emre Akbaş"],
	["erol_sahin", "Erol Şahin"],
	["ertan_onur", "Ertan Onur"],
	["faruk_polat", "Faruk Polat"],
	["faruk_tokdemir", "Faruk Tokdemir"],
	["fatos_tunay_yarman_vural", "Fatoş Tunay Yarman Vural"],
	["fehime_nihan_cicekli", "Fehime Nihan Çiçekli"],
	["ferda_nur_alpaslan", "Ferda Nur Alpaslan"],
	["gokturk_ucoluk", "Göktürk Üçoluk"],
	["hakan_yildiz", "Hakan Yıldız"],
	["hande_alemdar", "Hande Alemdar"],
	["ismail_hakki_toroslu", "İsmail Hakkı Toroslu"],
	["ismail_sengor_altingovde", "İsmail Sengör Altıngövde"],
	["mehmet_halit_s_oguztuzun", "Mehmet Halit S. Oğuztüzün"],
	["murat_manguoglu", "Murat Manguoğlu"],
	["onur_tolga_sehitoglu", "Onur Tolga Şehitoğlu"],
	["pelin_angin", "Pelin Angın"],
	["pinar_karagoz", "Pınar Karagöz"],
	["ramazan_gokberk_cinbis", "Ramazan Gökberk Cinbiş"],
	["seyda_ertekin_bolelli", "Şeyda Ertekin Bolelli"],
	["seyyit_alper_sert", "Seyyit Alper Sert"],
	["sinan_kalkan", "Sinan Kalkan"],
	["uluc_saranli", "Uluç Saranlı"],
	["yusuf_sahillioglu", "Yusuf Sahillioğlu"]
]) 

/* main */
const fileSelector = document.getElementById('file_selector');
fileSelector.addEventListener('change', () => {
	const [file] = fileSelector.files;
	const reader = new FileReader();
	reader.addEventListener(
		"load",
		() => {
			const lines = reader.result.split("\n");

			for (var lineIndex = 3; lineIndex < lines.length && lines[lineIndex].slice(0, 6) == "Answer"; lineIndex += 3) {
				const line = lines[lineIndex + 1];
				const assignments = line.split(' ');

				const new_schedule_map = new Map();    // A map for each day
				day_names.forEach((day_name) => {
					const daily_schedule_map = new Map();    // A map for each place
					place_names.forEach((place_name) => {
						daily_schedule_map.set(place_name, new Array(9))    // 9 hours per day
					});

					new_schedule_map.set(day_name, daily_schedule_map);
				});

				for (var assignmentIndex = 0; assignmentIndex < assignments.length; assignmentIndex++) {
					const assignment = assignments[assignmentIndex];
					const assignment_information = assignment.match(/\w+/g);
					
					const course_code = assignment_information[1].toUpperCase();
					const day = assignment_information[2];
					const start_hour = parseInt(assignment_information[3]);
					const place = assignment_information[4];
					const lecturer = hoca_constant_name_mapping.get(assignment_information[5]);
					const section = assignment_information[6];
					
					new_schedule_map.get(day).get(place)[start_hour - 8] = {
						s: start_hour * 60 + 40,
						e: start_hour * 60 + 90,
						day: day,
						place: place,
						t: course_code + "." + section + "<br>" + lecturer
					};
				}

				var new_schedule = [];
				new_schedule_map.forEach(daily_schedule => daily_schedule.forEach(lesson => {
					lesson.forEach((lesson) => {
						if (new_schedule.length)    // If any other lessons were added to the schedule
						{
							const previous_lesson = new_schedule[new_schedule.length - 1];
							if (previous_lesson.e == lesson.s - 10
								&& previous_lesson.day == lesson.day
								&& previous_lesson.t == lesson.t)
								previous_lesson.e = lesson.e;
							else
								new_schedule.push(lesson);
						}
						else
							new_schedule.push(lesson);
					})
				}));

				schedules.push(new_schedule)
			}

			draw();
		},
		false,
	);
	reader.readAsText(file);
});
