from statistics import mean
import sys

def diff(lst):
    numbers = sorted(lst)
    res = ((numbers[-1] - numbers[0])/numbers[0])
    return res*100


lst = []
results = open(sys.argv[1], "r")
new = open("multiplied-"+sys.argv[1], "w+")
for line in results:
    if (line.strip("\n")):
        if not(line.startswith("A") or line.startswith("D")):
            multiplied = round(int(line.strip())*int(sys.argv[2]))
            lst.append(int(multiplied))
            new.write(str(multiplied)+ "\n")
    
print(mean(lst))
new.write("\nAverage: " + str(mean(lst)))
new.write("\nDelta: " + str(diff(lst))+'%')
