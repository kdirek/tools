# -*- coding: utf-8 -*-
"""
Spyder Editor

This script extracts the Densham surgery (A81001).
"""

import pandas as pd
import os

path = "/Users/Kenan/Desktop/hk/"
outpath = "/Users/Kenan/Desktop/hk_out/"
os.chdir(path)


files = [f for f in os.listdir('.') if f.endswith(".CSV")]

cols2 = ['sha', 'pct', 'practice', 'bnf_code', 'bnf_name', 'items', 'nic', 'act_cost', 'quantity', 'period']
practice_code= 'A81001'

for i in files:
    
    data = pd.read_csv(open(os.path.join(path, i), 'r'), header=None, names=cols2, index_col=False, skiprows=1).rename(columns=lambda x: x.strip())
    data = data[data['practice'] == practice_code].copy(deep=True)
    data.to_csv(os.path.join(outpath, i))

