import csv
from unidecode import unidecode


hocas = []

i_names = []
i_course1 = []
i_course2 = []

c_codes = []
c_names = []
c_blockables = []
c_splittings = []
c_service_courses = []
c_levels = []
c_types = []
c_capacities = []
c_hours = []


def parse_csv_instructors(filename='instructors.csv'):
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        # next(reader)
        for row in reader:
            i_names.append(unidecode(row[0].lower().translate({ord(char): '_' for char in ' '}).translate({ord(char): None for char in '.'})))
            i_course1.append("ceng" + str(float(row[1]))[4:-2])
            try:
                i_course2.append("ceng" + str(float(row[2]))[4:-2])
            except:
                i_course2.append(-1)


def parse_csv_courses(filename='courses.csv'):
    with open(filename, 'r') as f:
        reader = csv.reader(f)
        # next(reader)
        for row in reader:
            c_codes.append("ceng" + row[0][4:])
            c_names.append(row[1])
            c_blockables.append(row[2])
            c_splittings.append(row[3])
            c_service_courses.append(row[4])
            c_levels.append(row[5].lower())
            c_types.append(row[6].lower())
            c_capacities.append(int(float(row[7])))
            c_hours.append(int(float(row[8])))

if __name__ == '__main__':
    # Open CSV file
    with open('problem-data.csv', 'r') as csv_file:
        reader = csv.reader(csv_file, delimiter=',', quotechar='|')
        database = open('knowledge_base.lp', 'w')

        # Read time slot names
        time_slots = []
        for column in csv_file.readline().split(";")[3:]:
            time_slots.append(column.lower().translate({ord(char): None for char in ' -:'}))
        
        print("day(mon).", file=database)
        print("day(tue).", file=database)
        print("day(wed).", file=database)
        print("day(thu).", file=database)
        print("day(fri).", file=database)
        print("hour(8..16).", file=database)

        # lecture(ahmetOguzAkyuz, 1)
        #start from second row
        while row := csv_file.readline():
            row = row.split(";")
            hoca_name = unidecode(row[0].lower().translate({ord(char): '_' for char in ' '}).translate({ord(char): None for char in '.'}))

            busy_hours = []
            
            #read course name from first column
            course1_name = row[1][4:]
            course2_name = row[2][4:]

            for col in range(3, len(row)):
                #read course hours from other columns
                date = row[col]

                if date == 'Yes':
                    busy_hours.append(time_slots[col - 3])
                    
            print("hoca({hoca_name}).".format(hoca_name=hoca_name), file=database)
            for busy_hour in busy_hours:
                if(int(busy_hour[3:5])<17):
                    print("busy({hoca}, {day}, {hour}).".format(hoca=hoca_name, day=busy_hour[:3],hour=int(busy_hour[3:5])), file=database)

    parse_csv_instructors()
    parse_csv_courses()
    
    for i in range(len(i_names)):
        if i_course1[i] != -1:
            decl = "teaches({}, {}).".format(i_names[i], i_course1[i])
            print(decl, file=database)
        if i_course2[i] != -1:
            decl = "teaches({}, {}).".format(i_names[i], i_course2[i])
            print(decl, file=database)

    
    for i in range(len(i_names)):
        if i_course1[i] != -1:
            decl = "teaches({}, {}).".format(i_names[i], i_course1[i])
            print(decl, file=database)
        if i_course2[i] != -1:
            decl = "teaches({}, {}).".format(i_names[i], i_course2[i])
            print(decl, file=database)

    
    for i in range(len(c_codes)):
        decl = "course({}).".format(c_codes[i])
        print(decl, file=database)

    for i in range(len(c_codes)):
        decl = "{}({}).".format(c_levels[i].lower(), c_codes[i])
        print(decl, file=database)

    for i in range(len(c_codes)):
        decl = "{}({}).".format(c_types[i].lower(), c_codes[i])
        print(decl, file=database)
    
    prev_code = None
    repetition = 1
    for i in range(len(c_codes)):
        # decl = "section_capacity({}, {})".format(c_codes[i],c_capacities[i])
        # print(decl, file=database)
        if c_codes[i] == prev_code:
            repetition += 1
        else:
            prev_code = c_codes[i]
            repetition=1
        decl = "section_capacity({}, {}, {}).".format(c_codes[i],repetition,c_capacities[i])
        print(decl, file=database)

    prev_code = None
    for i in range(len(c_codes)):
        if c_codes[i] == prev_code:
            repetition += 1
        else:
            prev_code = c_codes[i]
            decl = "total_lecture_hours({}, {}).".format(c_codes[i],c_hours[i])
            print(decl, file=database)

    prev_code = None
    repetition = 1
    for i in range(len(c_codes)):
        if c_codes[i] == prev_code:
            repetition += 1
        else:
            prev_code = c_codes[i]
            repetition=1
        decl = "has_section({}, {}).".format(c_codes[i],repetition)
        print(decl, file=database)

    for i in range(len(c_codes)):
        if c_service_courses[i] == "Yes":
            print("service_course({course_code})".format(course_code=c_codes[i]), file=database)
    


    # prev_code = None
    # repetition = 1
    # for i in range(len(c_codes)):
    #     if c_codes[i] == prev_code:
    #         repetition += 1
    #     else:
    #         prev_code = c_codes[i]
    #         repetition=1
    #     decl = "course({}, {}, {}, {}, {}, {}).".format(c_codes[i],c_levels[i],c_types[i],c_capacities[i],c_hours[i] ,repetition)

    #     if c_service_courses[i] == "Yes":
    #         print("service_course({course_code})".format(course_code=c_codes[i]), file=database)
    #     print(decl, file=database)
