#include "facts.lp".

% Choice rule for assignment by Ege
{assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} :- 
    course(COURSE), 
    day(DAY), 
    hour(HOUR), 
    place(PLACE), 
    teaches(HOCA, COURSE), 
    has_section(COURSE, SECTION).

% :- #count {A : assignment(A, _, _, _, _, _)} < 30. % I couldn't find how to force assignment count to be the biggest number possible, for now I just put 35

% the capacity of the classroom should be greater than or equal to the number of students in the course-section pair. by Ege
:-  assignment(COURSE, _, _, PLACE, _, SECTION),
    section_capacity(COURSE, SECTION, CAPACITY),
    capacity(PLACE, CAPACITY2),
    CAPACITY > CAPACITY2.

% a section is thaugt by only one instructor. by Ege
:-  assignment(COURSE, _, _, _, HOCA1, SECTION),
    assignment(COURSE, _, _, _, HOCA2, SECTION),
    HOCA1 != HOCA2.

% One classroom cannot be occupied by more than one course at a time. originally by Ege, rewritten by Berkay
:-  day(DAY), hour(HOUR), place(PLACE), #count{COURSE, HOCA, SECTION: assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} > 1.

% % An instructor don't give a course in their busy hour. by Ege, edited by Berkay
:- assignment(_, DAY, HOUR, _, HOCA, _),
    busy(HOCA, DAY, HOUR).

% An instructor can give at most one course at a time. originally by Ege, rewritten by Berkay
:-  day(DAY), hour(HOUR), hoca(HOCA), #count{COURSE, PLACE, SECTION: assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} > 1.

%% A course-section pair can not happen in more than one place at a time. by Ege
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

% % if  total_lecture_hours is 3, then there should be two consecutive hours. by Emirhan
:-  total_lecture_hours(COURSE, 3),
    assignment(COURSE, DAY1, HOUR1, _, _, SECTION),
    assignment(COURSE, DAY2, HOUR2, _, _, SECTION),
    undergraduate(COURSE),
    DAY1 == DAY2,
    | HOUR1 - HOUR2 | > 1.

% % if two consecutive hours are assigned, there should be in the same place. by Emirhan
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


% Hard constraints on places: 
%1. Non-service undergraduate level courses cannot occupy a classroom longer than 2 hours consecutively.					
%2. One classroom cannot be occupied by more than one course at a time.					
%3. If a non-service undergraduate level course has splitted into three sections, one hour of lecture must be conducted at BMB1 at least					
%4. If a non-service undergraduate level course has splitted into three sections, one hour must be conducted at BMB1 at least					
					
% Hard constraints on instructors: 
%1. An instructor can give at most one course at a time.
%2. An instructor don't give a course in their busy hour.

#show assignment/6.
