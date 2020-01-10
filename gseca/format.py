import os
import sys

path = sys.argv[1]

out_file = open(sys.argv[2], 'w')
for filename in os.listdir(path):
	line = filename.rsplit('.', 1)[0] + '\t'
	with open(path + "/" + filename, 'r') as txt:
		for gene in txt:
			line += gene.rstrip('\n') + '\t'
	line.rstrip('\t')
	line = line + "\n"
	out_file.write(line)
out_file.close()