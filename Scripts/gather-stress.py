#!/usr/bin/env python

import numpy as np
import pandas as pd

material_l = ["Graphene" "Epoxy"]
wt_l = [0, 1, 2, 3, 4, 5]
rep_l = [1, 1, 1, 1, 10, 10]


def gen_paths(path, num_reps=1):
    return list(
        map(lambda rep: f"{path}/rep-{rep}/p_properties.txt", range(0, num_reps))
    )


def gather_reps(material, wt, wrep):
    mod_paths = [f"{material}/wt-0{wt}.0/Modulus/{wrep}"]

    rep_paths = []
    for path in mod_paths:
        rep_paths = rep_paths + gen_paths(path, 100)

    df = pd.concat(list(map(lambda path: pd.read_csv(path), rep_paths)))
    df["wrep"] = wrep

    return df


def gather_property(material, wt, num_reps):
    print(f"{material} 0{wt}.0%")

    df = pd.concat(
        list(map(lambda wrep: gather_reps(material, wt, wrep), range(num_reps)))
    )

    return df


m = "Graphene"
g_rep_l = [1, 5, 3, 1, 10, 10]
g_df_lst = list(
    map(lambda wt, num_reps: gather_property(m, wt, num_reps), wt_l, g_rep_l)
)

for n, wt in enumerate(wt_l):
    g_df_lst[n].to_csv(f"Output/{m}-{wt}-modulus.csv", index=False)

m = "Epoxy"
e_rep_l = [2, 1, 1, 1, 10, 10]
e_df_lst = list(
    map(lambda wt, num_reps: gather_property(m, wt, num_reps), wt_l, e_rep_l)
)

for n, wt in enumerate(wt_l):
    e_df_lst[n].to_csv(f"Output/{m}-{wt}-modulus.csv", index=False)
