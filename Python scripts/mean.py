from statistics import mean
import sys

lst = []

results = open(sys.argv[1], "r")
for line in results:
    lst.append(int(line))
    
print("\nAverage: " + str(mean(lst)))
