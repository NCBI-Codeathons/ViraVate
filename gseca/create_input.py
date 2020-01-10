#!/usr/bin/env python3
import os
import sys

path = sys.argv[1]

for filename in os.listdir(path):
	out_file_m = open(filename.rsplit('.', 1)[0] + "_M.tsv", 'w')
	out_file_l = open(filename.rsplit('.', 1)[0] + "_L.tsv", 'w')
	line = open(path + "/" + filename).readline().rstrip('\n').split('\t')
	for case in line:
		if case == "infected":
			out_file_l.write("CASE" + '\n')
		elif case == "control":
			out_file_l.write("CNTR" + '\n')
		else:
			out_file_l.write(case + '\n')
	out_file_l.close()
	with open(path + "/" + filename, 'r') as txt:
		for gene in txt:
			out_file_m.write(gene)
	out_file_m.close()