import sys

def diff(lst):
    numbers = sorted(lst)
    res = ((numbers[-1] - numbers[0])/numbers[0])
    return res*100



lst = []
results = open(sys.argv[1], "r")
for line in results:
    lst.append(int(line))
print(str(diff(lst))+'%')

