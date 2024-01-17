#include "facts.lp". % all the data is in this file

% -------------------------- HARD CONSTRAINTS --------------------------

% Hard constraints on places: 
%1. Non-service undergraduate level courses cannot occupy a classroom longer than 2 hours consecutively.					
%2. One classroom cannot be occupied by more than one course at a time.					
%3. If a non-service undergraduate level course has splitted into three sections, one hour of lecture must be conducted at BMB1 at least					
%4. If a non-service undergraduate level course has splitted into three sections, one hour must be conducted at BMB1 at least					
					
% Hard constraints on instructors: 
%1. An instructor can give at most one course at a time.
%2. An instructor don't give a course in their busy hour.

% Choice rule for assignment by Ege
{assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} :- 
    course(COURSE), 
    day(DAY), 
    hour(HOUR), 
    place(PLACE), 
    teaches(HOCA, COURSE), 
    has_section(COURSE, SECTION).

% the capacity of the classroom should be greater than or equal to the number of students in the course-section pair. by Ege
:-  assignment(COURSE, _, _, PLACE, _, SECTION),
    section_capacity(COURSE, SECTION, CAPACITY),
    capacity(PLACE, CAPACITY2),
    CAPACITY > CAPACITY2.

% a section is tought by only one instructor. by Ege
:-  assignment(COURSE, _, _, _, HOCA1, SECTION),
    assignment(COURSE, _, _, _, HOCA2, SECTION),
    HOCA1 != HOCA2.

% One classroom cannot be occupied by more than one course at a time. originally by Ege, rewritten by Berkay
:-  day(DAY), hour(HOUR), place(PLACE), #count{COURSE, HOCA, SECTION: assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} > 1.

% An instructor don't give a course in their busy hour. by Ege, edited by Berkay
:- assignment(_, DAY, HOUR, _, HOCA, _),
    busy(HOCA, DAY, HOUR).

% An instructor can give at most one course at a time. originally by Ege, rewritten by Berkay
:-  day(DAY), hour(HOUR), hoca(HOCA), #count{COURSE, PLACE, SECTION: assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} > 1.

% A course-section pair can not happen in more than one place at a time. by Ege
:-  assignment(COURSE, DAY, HOUR, PLACE1, _, SECTION),
    assignment(COURSE, DAY, HOUR, PLACE2, _, SECTION),
    PLACE1 != PLACE2.

% Non-service undergraduate level courses cannot occupy a classroom longer than 2 hours consecutively. by Ege			
:-  assignment(COURSE, DAY, HOUR1, PLACE, HOCA, SECTION),
    assignment(COURSE, DAY, HOUR2, PLACE, HOCA, SECTION),
    not service_course(COURSE),
    undergraduate(COURSE),
    | HOUR1 - HOUR2 | > 1.

% Each section of each course should be assigned exactly as many lecture hours as requested. by Berkay 
:-  total_lecture_hours(COURSE, HOURS), has_section(COURSE, SECTION),
    #count{DAY, HOUR: assignment(COURSE, DAY, HOUR, _, _, SECTION)} != HOURS.

% assign g101 for ceng331, by Kadir
:-  assignment(COURSE, DAY, HOUR1, PLACE, HOCA, SECTION),
    COURSE!=ceng331,
    PLACE=g101.

%If a teacher teaches a course, he/she must be assigned to at least one section of that course. by Ege
:-  teaches(HOCA, COURSE),
    not assignment(COURSE, _, _, _, HOCA, _).


% A must course with 3 hours of lecture cannot be spanned over 3 days. by Emirhan
:-  total_lecture_hours(COURSE, 3),
    assignment(COURSE, DAY1, _, _, _, SECTION),
    assignment(COURSE, DAY2, _, _, _, SECTION),
    assignment(COURSE, DAY3, _, _, _, SECTION),
    undergraduate(COURSE),
    DAY1 != DAY2,
    DAY2 != DAY3,
    DAY1 != DAY3.

% if total_lecture_hours is 3, then there should be two consecutive hours. by Emirhan
:-  total_lecture_hours(COURSE, 3),
    assignment(COURSE, DAY1, HOUR1, _, _, SECTION),
    assignment(COURSE, DAY2, HOUR2, _, _, SECTION),
    undergraduate(COURSE),
    DAY1 == DAY2,
    | HOUR1 - HOUR2 | > 1.

% if two consecutive hours are assigned, there should be in the same place. by Emirhan
:-  assignment(COURSE, DAY1, HOUR1, PLACE1, _, SECTION),
    assignment(COURSE, DAY2, HOUR2, PLACE2, _, SECTION),
    DAY1 == DAY2,
    | HOUR1 - HOUR2 | == 1,
    PLACE1 != PLACE2.

% 2 hours of lecture cannot be spanned over 2 days. by Ege
:- total_lecture_hours(COURSE, 2),
    #count{DAY: assignment(COURSE, DAY, _, _, _, SECTION)} != 1.

% Graduate courses be in a single day. by Ege
:- total_lecture_hours(COURSE, 3),
    graduate(COURSE),
    #count{DAY: assignment(COURSE, DAY, _, _, _, SECTION)} != 1. 

% 3 hours of graduate  courses should be consecutive. by Ege
:- total_lecture_hours(COURSE, 3),
    graduate(COURSE),
    assignment(COURSE, DAY, HOUR1, _, _, SECTION),
    assignment(COURSE, DAY, HOUR2, _, _, SECTION),
    | HOUR1 - HOUR2 | > 2.

%If a non-service undergraduate level course has splitted into three sections, one hour must be conducted at BMB1 at least					
:-  undergraduate(COURSE),
    not service_course(COURSE),
    assignment(COURSE, _, _, PLACE, _, SECTION),
    has_section(COURSE, 3),
    #count {COURSE,SECTION : assignment(COURSE, _, _, bmb1, _, SECTION)} < 1.

% If a non-service undergraduate level course has splitted into two sections,all hours must be conducted at BMB1 at least.
% If a non-service undergraduate level course has splitted into two sections,all hours must be conducted at BMB1 for at least one section. by Ege, Anıl, Kadir
:-  undergraduate(COURSE),
    not service_course(COURSE),
    assignment(COURSE, _, _, PLACE, _, SECTION),
    has_section(COURSE, 2),
    not has_section(COURSE, 3),
    total_lecture_hours(COURSE, TOTAL_HOUR),
    #count {COURSE : assignment(COURSE, _, _, bmb1, _, 1)} < TOTAL_HOUR,
    #count {COURSE : assignment(COURSE, _, _, bmb1, _, 2)} == TOTAL_HOUR.

:-  undergraduate(COURSE),
    not service_course(COURSE),
    assignment(COURSE, _, _, PLACE, _, SECTION),
    has_section(COURSE, 2),
    not has_section(COURSE, 3),
    total_lecture_hours(COURSE, TOTAL_HOUR),
    #count {COURSE : assignment(COURSE, _, _, bmb1, _, 1)} == TOTAL_HOUR,
    #count {COURSE : assignment(COURSE, _, _, bmb1, _, 2)} < TOTAL_HOUR.

% courses offered to the same cohort should have fewer gaps (time slots without lectures) between them. by Ege, Anıl, Kadir
% :-  undergraduate(COURSE1),
%     undergraduate(COURSE2),
%     grade(COURSE1, GRADE),
%     grade(COURSE2, GRADE),
%     assignment(COURSE1, DAY, HOUR1, _, _, _),
%     assignment(COURSE2, DAY, HOUR2, _, _, _),
%     COURSE1 != COURSE2,
%     | HOUR1 - HOUR2 | > 3.

% -------------------------- SOFT CONSTRAINTS --------------------------
% 1. Minimize the number of gaps between courses offered to the same cohort
% 2. Minimize the number of gaps between classes given by the same instructor
% 3. Minimize the number of days that an instructor has to be in the campus

% minimize the number of gaps between courses offered to the same cohort. by Emirhan

#minimize{| HOUR1 - HOUR2 | : 
          assignment(COURSE1, DAY, HOUR1, _, _, _), 
          assignment(COURSE2, DAY, HOUR2, _, _, _),
          grade(COURSE1, GRADE),
          grade(COURSE2, GRADE),
          undergraduate(COURSE1),
          undergraduate(COURSE2),
          COURSE1 != COURSE2}.

% minimize the number of gaps between classes given by the same instructor. by Emirhan

#minimize{| HOUR1 - HOUR2 | + | HOUR1 - HOUR2 | + | HOUR1 - HOUR2 | : 
          assignment(COURSE, DAY, HOUR1, _, HOCA, SECTION1), 
          assignment(COURSE, DAY, HOUR2, _, HOCA, SECTION2),
          SECTION1 != SECTION2}.

#minimize{| HOUR1 - HOUR2 | + | HOUR1 - HOUR2 | + | HOUR1 - HOUR2 | : 
          assignment(COURSE1, DAY, HOUR1, _, HOCA, _), 
          assignment(COURSE2, DAY, HOUR2, _, HOCA, _),
          COURSE1 != COURSE2}.

% minimize the number of days that an instructor has to be in the campus. by Emirhan

day_penalty(HOCA, PENALTY) :- 
    assignment(_, DAY1, _, _, HOCA, _),
    PENALTY = #count{DAY2 : assignment(_, DAY2, _, _, HOCA, _), DAY1 != DAY2}.

#minimize{PENALTY : assignment(_, _, _, _, HOCA, _), day_penalty(HOCA, PENALTY)}.
          

% No lecture at 12.40. by Ege
:-  assignment(_, _, HOUR, _, _, _),
    HOUR == 12.


% Same sections for a year's courses shouldn't conflict. by Ege
:-  assignment(COURSE1, DAY, HOUR1, _, _, SECTION),
    assignment(COURSE2, DAY, HOUR2, _, _, SECTION),
    grade(COURSE1, GRADE),
    grade(COURSE2, GRADE),
    COURSE1 != COURSE2,
    HOUR1 == HOUR2.



#show assignment/6.
