#include "facts.lp".

assignment(COURSE, DAY, HOUR, PLACE, HOCA, SECTION) :- 
    course(COURSE), 
    day(DAY), 
    hour(HOUR), 
    place(PLACE), 
    teaches(HOCA, COURSE), 
    has_section(COURSE, SECTION). 

COURSE1 = COURSE2, HOCA1 = HOCA2, SECTION1 = SECTION2:- 
    assignment(COURSE1, DAY1, HOUR1, PLACE1, HOCA1, SECTION1), 
    assignment(COURSE2, DAY2, HOUR2, PLACE2, HOCA2, SECTION2),
    DAY1 = DAY2,
    HOUR1 = HOUR2,
    PLACE1 = PLACE2.



% hard constraints: 
%1. Non-service undergraduate level courses cannot occupy a classroom longer than 2 hours consecutively.					
%2. One classroom cannot be occupied by more than one course at a time.					
%3. If a non-service undergraduate level course has splitted into three sections, one hour of lecture must be conducted at BMB1 at least					
%4. If a non-service undergraduate level course has splitted into three sections, one hour must be conducted at BMB1 at least					
					
#show assignment/6.
