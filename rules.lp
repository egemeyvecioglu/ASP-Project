#include "facts.lp".

% Choice rule for assignment by Ege
{assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION)} :- 
    course(COURSE), 
    day(DAY), 
    hour(HOUR), 
    place(PLACE), 
    teaches(HOCA, COURSE), 
    has_section(COURSE, SECTION).
:- #count {A : assignment(A, _, _, _, _, _)} < 30. % I couldn't find how to force assignment count to be the biggest number possible, for now I just put 35

% Each course-section pair should be assigned total_lecture_hours times. by Ege
% THIS DOES NOT WORK
% :-  total_lecture_hours(COURSE, TOTAL),
%     has_section(COURSE, SECTION),
%     #count {A, B : assignment(A, _, _, _, _, B), A = COURSE, B = SECTION} != TOTAL.


% the capacity of the classroom should be greater than or equal to the number of students in the course-section pair. by Ege
:-  assignment(COURSE, _, _, PLACE, _, SECTION),
    section_capacity(COURSE, SECTION, CAPACITY),
    capacity(PLACE, CAPACITY2),
    CAPACITY > CAPACITY2.

% % One classroom cannot be occupied by more than one course at a time. Ege
:-  assignment(COURSE1, DAY, HOUR, PLACE, HOCA1, SECTION1), 
    assignment(COURSE2, DAY, HOUR, PLACE, HOCA2, SECTION2),
    COURSE1 != COURSE2,
    HOCA1 != HOCA2,
    SECTION1 != SECTION2.

% % An instructor don't give a course in their busy hour. by Ege
:- assignment(_, DAY1, HOUR1, _, HOCA, _),
    busy(HOCA, DAY2, HOUR2),
    DAY1 = DAY2,
    HOUR1 = HOUR2.

% % An instructor can give at most one course at a time. by Ege
:-  assignment(COURSE1, DAY, HOUR, _, HOCA, SECTION1),
    assignment(COURSE2, DAY, HOUR, _, HOCA, SECTION2),
    COURSE1  != COURSE2,
    SECTION1 != SECTION2.

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


% % One classroom cannot be occupied by more than one course at a time. by anil eren gocer
% COURSE1 = COURSE2, HOCA1 = HOCA2, SECTION1 = SECTION2 :- 
%     assignment(COURSE1, DAY1, HOUR1, PLACE1, HOCA1, SECTION1), 
%     assignment(COURSE2, DAY2, HOUR2, PLACE2, HOCA2, SECTION2),
%     DAY1 = DAY2,
%     HOUR1 = HOUR2,
%     PLACE1 = PLACE2.

% % An instructor can give at most one course at a time. by anil eren gocer
% COURSE1 = COURSE2, SECTION1 = SECTION2 :-
%     assignment(COURSE1, DAY1, HOUR1, PLACE1, HOCA1, SECTION1),
%     assignment(COURSE2, DAY2, HOUR2, PLACE2, HOCA2, SECTION2),
%     DAY1 = DAY2,
%     HOUR1 = HOUR2,
%     HOCA1 = HOCA2.

% % An instructor don't give a course in their busy hour. by anil eren gocer
% not busy(HOCA, DAY, HOUR) :- 
%     assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION),
%     course(COURSE), 
%     day(DAY), 
%     hour(HOUR), 
%     place(PLACE), 
%     teaches(HOCA, COURSE), 
%     has_section(COURSE, SECTION). 

% Hard constraints on places: 
%1. Non-service undergraduate level courses cannot occupy a classroom longer than 2 hours consecutively.					
%2. One classroom cannot be occupied by more than one course at a time.					
%3. If a non-service undergraduate level course has splitted into three sections, one hour of lecture must be conducted at BMB1 at least					
%4. If a non-service undergraduate level course has splitted into three sections, one hour must be conducted at BMB1 at least					
					
% Hard constraints on instructors: 
%1. An instructor can give at most one course at a time.
%2. An instructor don't give a course in their busy hour.

#show assignment/6.
