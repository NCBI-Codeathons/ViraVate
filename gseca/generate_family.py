import pandas as pd
import numpy as np
import sys

# input:
# sys.argv[1] - input modified gmt file / either up or down (e.g. 'up_mod.gmt')
# sys.argv[2] - output gmt file with families / either up or down (e.g. 'up_family.gmt')
# sys.argv[3] - csv table with gene id and family (e.g. 'attribute_list_entries.csv')
# sys.argv[4] - direction (either 'up' or 'down')

# read gmt file
lines = []
with open(sys.argv[1]) as gmt:
	for line in gmt:
		lines.append(line.rstrip('\n').split('\t'))

for line in lines:
	del line[-1]

# right now we have gmt file with first column as gene names
families = pd.read_csv(sys.argv[3])

# create a set of families
family_set = set()

for family in families['Family']:
	family_set.add(family)

family_dict = {}
for family in family_set:
	family_dict[family] = []

for i in range(families.shape[0]):
	family_dict[families['Family'][i]].append(i)

for line in lines:
	del line[0]

# write a gene set per family
family_lines = []
for family in family_set:
	if len(family_dict[family]) >= 5:
		gene_set = set()
		for i in family_dict[family]:
			for j in range(len(lines[i])):
				gene_set.add(lines[i][j])

		gene_dict = {}
		for gene in gene_set:
			gene_dict[gene] = 0
		for i in family_dict[family]:
			for j in range(len(lines[i])):
				gene_dict[lines[i][j]] += 1
		# sort the dictionary by value, in descending order
		sort = sorted(gene_dict.items(), key=lambda item: item[1], reverse=True)

		# set cutoff length
		cutoff_length = max(10, min(len(sort) / 5, 1000))

		family_line = family + "_" + sys.argv[4] + "\t"
		count = 0
		for gene in sort:
			count += 1
			if count > cutoff_length:
				break
			family_line = family_line + gene[0] + '\t'
		family_line.rstrip('\t')
		family_lines.append(family_line)

# write a general gene set
gene_set = set()
for line in lines:
	for i in range(len(line)):
		gene_set.add(line[i])

gene_dict = {}
for gene in gene_set:
	gene_dict[gene] = 0

for line in lines:
	for i in range(1, len(line)):
		gene_dict[line[i]] += 1

sort = sorted(gene_dict.items(), key=lambda item: item[1], reverse=True)

# set cutoff length
cutoff_length = max(10, min(len(sort) / 5, 1000))

family_line = "general_" + sys.argv[4] + "\t"
count = 0
for gene in sort:
	count += 1
	if count > cutoff_length:
		break
	family_line = family_line + gene[0] + '\t'
family_line.rstrip('\t')
family_lines.append(family_line)

# write common genes above cutoff
file_write = open(sys.argv[2], 'w+')
for line in family_lines:
	file_write.write(line + '\n')
file_write.close()