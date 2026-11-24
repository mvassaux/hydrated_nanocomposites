#!/usr/bin/env python

import numpy as np

rep_num = 100

rep_l = list(np.arange(0, rep_num))
seed_l = list(np.random.randint(1, high=800000, size=len(rep_l)))

assert len(rep_l) == len(seed_l)

print("# variables\n")
print("variable rep world " + " ".join(list(map(str, rep_l))))
print("variable vseed world " + " ".join(list(map(str, seed_l))))
print("\ninclude			elastic-input.dat")
