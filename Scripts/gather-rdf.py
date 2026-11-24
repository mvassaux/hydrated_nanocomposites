#!/usr/bin/env python

import numpy as np
import pandas as pd


def read_rdf_file(at_file):
    with open(at_file) as f:
        last_at = list(map(lambda l: l.split(), f.readlines()[-100:]))

    aid = list(map(lambda l: float(l[0]), last_at))
    r = list(map(lambda l: float(l[1]), last_at))
    gr = list(map(lambda l: float(l[2]), last_at))
    coordr = list(map(lambda l: float(l[3]), last_at))
    df = pd.DataFrame({"id": aid, "r": r, "gr": gr, "coordr": coordr, "at": at})

    return df


def average_at_reps(at, rdf_path, rep_num):
    rep_l = list(range(rep_num))
    rep_path_l = list(map(lambda rep: f"{rdf_path}/{rep}/at-{at}.rdf", rep_l))
    df_l = list(map(read_rdf_file, rep_path_l))

    r_mean = df_l[1]["r"]

    gr_l = list(map(lambda df: df["gr"].to_numpy(), df_l))
    gr_df = pd.DataFrame(np.stack(gr_l))

    gr_mean = gr_df.mean(axis=0).to_numpy()
    gr_sd = gr_df.std(axis=0).to_numpy()

    coordr_l = list(map(lambda df: df["coordr"].to_numpy(), df_l))
    coordr_df = pd.DataFrame(np.stack(coordr_l))

    coordr_mean = coordr_df.mean(axis=0).to_numpy()
    coordr_sd = coordr_df.std(axis=0).to_numpy()

    average_df = pd.DataFrame(
        {
            "r": r_mean,
            "gr_mean": gr_mean,
            "gr_sd": gr_sd,
            "coordr_mean": coordr_mean,
            "coordr_sd": coordr_sd,
            "material": material,
            "atom_type": at,
        }
    )

    return average_df


def single_at_reps(at, rdf_path, rep_num):
    rep_l = list(range(rep_num))
    rep_path_l = list(map(lambda rep: f"{rdf_path}/{rep}/at-{at}.rdf", rep_l))
    df_l = list(map(read_rdf_file, rep_path_l))

    return df_l[1]


material = "Graphene"
rdf_path = f"{material}-wt-05.0-RDF/RDF"
rep_num = 10


at_l = ["05", "11", "12", "13", "14"]
label_l = ["Aromatic C", "Amine N", "Water O", "Ether O", "Epoxy O"]

full_df_l = []

for idx in range(5):
    print(idx)
    print(label_l[idx])

    at = at_l[idx]
    average_df = average_at_reps(at, rdf_path, rep_num)
    full_df_l.append(average_df)

full_df = pd.concat(full_df_l)
full_df.to_csv(f"Output/{material}-RDF.csv", index=False)

material = "Graphene"
rdf_path = f"{material}-wt-05.0-RDF/RDF"
rep_num = 10


at_l = ["05", "11", "12", "13", "14"]
label_l = ["Aromatic C", "Amine N", "Water O", "Ether O", "Epoxy O"]

full_df_l = []

for idx in range(5):
    print(idx)
    print(label_l[idx])

    at = at_l[idx]
    average_df = average_at_reps(at, rdf_path, rep_num)
    full_df_l.append(average_df)

full_df = pd.concat(full_df_l)
full_df.to_csv(f"Output/{material}-RDF.csv", index=False)

material = "Epoxy"
rdf_path = f"{material}-wt-05.0-RDF/RDF"
rep_num = 10


at_l = ["05", "11", "12", "13", "14"]
label_l = ["Aromatic C", "Amine N", "Water O", "Ether O", "Epoxy O"]

full_df_l = []

for idx in range(5):
    print(idx)
    print(label_l[idx])

    at = at_l[idx]
    average_df = average_at_reps(at, rdf_path, rep_num)
    full_df_l.append(average_df)

full_df = pd.concat(full_df_l)
full_df.to_csv(f"Output/{material}-RDF.csv", index=False)
