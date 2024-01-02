with open('out.txt', 'r') as f:
    #read only the 5th line

    data = f.readlines()[4]
#split data from spaces
data = data.split()

#sort the data based on the course
data.sort()

print(len(data))

#write to csv file
import csv
with open('out.csv', 'w', newline='') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['Course', 'Day', 'Hour', 'Place', 'Teacher', 'Section'])
    for i in range(0, len(data)):
        data2 = data[i].split(',')
        print(data2)
        writer.writerow([data2[0][11:], data2[1], data2[2], data2[3], data2[4], data2[5][:-1]])

