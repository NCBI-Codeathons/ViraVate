#!/usr/bin/env python3
import pandas as pd
import sys

# input:
# sys.argv[1] - input gmt file / either up or down (e.g. 'up.gmt')
# sys.argv[2] - output gmt file / either up or down (e.g. 'up_mod.gmt')
lines = []
with open(sys.argv[1]) as gmt:
	for line in gmt:
		lines.append(line.rstrip('\n').split('\t'))

for line in lines:
	del line[1]

up_mod = open(sys.argv[2], 'w')
for line in lines:
	new_line = ""
	for content in line:
		new_line = new_line + content + '\t'
	new_line.rstrip('\t')
	new_line = new_line + "\n"
	up_mod.write(new_line)
up_mod.close()