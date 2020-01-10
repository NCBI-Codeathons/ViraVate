#!/usr/bin/env python3
import numpy as np
import pandas as pd
import sys

# input:
# sys.argv[1] : input csv file from GSECA
# sys.argv[2] : output csv file for interpretation result

# read result csv file from GSECA
output = pd.read_csv(sys.argv[1])

# check if the format is appropriate (7 ups, 7 downs per dataset)
try:
	assert output.shape[0] % 14 == 0
except AssertionError as error:
	print("inconsistent data")
	exit(1)

# 0~2: down/low - negative directional match
# 3~6: down/high
# 7~9: up/low
# 10~13: up/high - positive directional match
gene_list = []
columns = ["gene_name", "up_pv", "down_pv", "significant"]
for i in range(int(output.shape[0] / 14)):
	gene = ["", 0, 0, False]
	gene[0] = output['gene_set'][14 * i].rsplit(' ', 1)[0]
	gene[1] = min(output['pv'][14 * i + 10 : 14 * i + 14])
	gene[2] = min(output['pv'][14 * i: 14 * i + 3])
	gene[3] = True if gene[1] < 0.01 and gene[2] < 0.01 else False
	gene_list.append(gene)

# write result to csv
gene_interpretation = pd.DataFrame(gene_list, columns=columns).set_index('gene_name')

gene_interpretation.to_csv(sys.argv[2])
