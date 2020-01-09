import sys

# input:
# sys.argv[1] - input modified gmt file / up (e.g. 'up_family.gmt')
# sys.argv[2] - input modified gmt file / down (e.g. 'down_family.gmt')
# sys.argv[3] - output combined gmt file / down (e.g. 'combined_family.gmt')

up_lines = []
with open(sys.argv[1], 'r') as gmt:
	for line in gmt:
		up_lines.append(line.rstrip('\n').split('\t'))

up_lines.sort()

down_lines = []
with open(sys.argv[2], 'r') as gmt:
	for line in gmt:
		down_lines.append(line.rstrip('\n').split('\t'))

down_lines.sort()

try:
	assert len(up_lines) == len(down_lines)
except AssertionError as error:
	print("number of up-regulated families and down-regulated families are unequal")
	exit(1)

mod = open(sys.argv[3], 'w')
for i in range(len(up_lines)):
	up_line = up_lines[i]
	down_line = down_lines[i]
	line = ""
	for content in up_line:
		line = line + content + '\t'
	line.rstrip('\t')
	line = line + "\n"
	mod.write(line)
	line = ""
	for content in down_line:
		line = line + content + '\t'
	line.rstrip('\t')
	line = line + "\n"
	mod.write(line)
mod.close()