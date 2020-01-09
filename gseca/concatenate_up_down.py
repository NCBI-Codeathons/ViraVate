import sys

# input:
# sys.argv[1] - input modified gmt file / up (e.g. 'up_mod.gmt')
# sys.argv[2] - input modified gmt file / down (e.g. 'down_mod.gmt')
# sys.argv[3] - output combined gmt file / down (e.g. 'combined.gmt')

up_lines = []
with open(sys.argv[1], 'r') as gmt:
	for line in gmt:
		up_lines.append(line.rstrip('\n').split('\t'))

for line in up_lines:
	line[0] += '_up'

down_lines = []
with open(sys.argv[2], 'r') as gmt:
	for line in gmt:
		down_lines.append(line.rstrip('\n').split('\t'))

for line in down_lines:
	line[0] += '_down'

try:
	assert len(up_lines) == len(down_lines)
except AssertionError as error:
	print("number of up-regulated genes and down-regulated genes are unequal")
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