#!/usr/bin/env python

import numpy as np

def stress_out(rep_path):
    cunits = "GPa"

    C = np.loadtxt(f"{rep_path}/EConstant.txt", delimiter=",")
    C_all = np.zeros((6, 6), dtype=np.float64)

    # Output final values

    C_all[0, 0] = C[0, 0]
    C_all[1, 1] = C[1, 1]
    C_all[2, 2] = C[2, 2]

    C_all[0, 1] = 0.5 * (C[0, 1] + C[1, 0])
    C_all[0, 2] = 0.5 * (C[0, 2] + C[2, 0])
    C_all[1, 2] = 0.5 * (C[1, 2] + C[2, 1])

    C_all[3, 3] = C[3, 3]
    C_all[4, 4] = C[4, 4]
    C_all[5, 5] = C[5, 5]

    C_all[0, 3] = 0.5 * (C[0, 3] + C[3, 0])
    C_all[0, 4] = 0.5 * (C[0, 4] + C[4, 0])
    C_all[0, 5] = 0.5 * (C[0, 5] + C[5, 0])

    C_all[1, 3] = 0.5 * (C[1, 3] + C[3, 1])
    C_all[1, 4] = 0.5 * (C[1, 4] + C[4, 1])
    C_all[1, 5] = 0.5 * (C[1, 5] + C[5, 1])

    C_all[2, 3] = 0.5 * (C[2, 3] + C[3, 2])
    C_all[2, 4] = 0.5 * (C[2, 4] + C[4, 2])
    C_all[2, 5] = 0.5 * (C[2, 5] + C[5, 2])

    C_all[3, 4] = 0.5 * (C[3, 4] + C[4, 3])
    C_all[3, 5] = 0.5 * (C[3, 5] + C[5, 3])
    C_all[4, 5] = 0.5 * (C[4, 5] + C[5, 4])

    # print("=========================================")
    # print("Components of the Elastic Constant Tensor")
    # print("=========================================")

    # print(C)
    # print(C_all)

    # Average moduli for cubic crystals

    C11cubic = (C_all[0, 0] + C_all[1, 1] + C_all[2, 2]) / 3
    C12cubic = (C_all[0, 1] + C_all[0, 2] + C_all[1, 2]) / 3
    C44cubic = (C_all[3, 3] + C_all[4, 4] + C_all[5, 5]) / 3

    bulkmodulus = (C11cubic + 2 * C12cubic) / 3
    shearmodulus1 = C44cubic
    shearmodulus2 = (C11cubic - C12cubic) / 2
    poissonratio = 1 / (1 + C11cubic / C12cubic)

    youngmodulus = 3 * bulkmodulus * (1 - 2 * poissonratio)

    # print("=========================================")
    # print("Average properties for a cubic crystal")
    # print("=========================================")

    # print(f"Bulk Modulus = {bulkmodulus} {cunits}")
    # print(f"Shear Modulus 1 = {shearmodulus1} {cunits}")
    # print(f"Shear Modulus 2 = {shearmodulus2} {cunits}")
    # print(f"Poisson Ratio = {poissonratio}")

    # print(f"Young Modulus = {youngmodulus} {cunits}")

    with open(f"{rep_path}/p_properties.txt", "w") as f:
        f.write(
            "youngs_modulus,bulk_modulus,shear_modulus_1,shear_modulus_2,poissons_ratio\n"
        )
        f.write(
            f"{youngmodulus},{bulkmodulus},{shearmodulus1},{shearmodulus2},{poissonratio}\n"
        )


for r in range(200):
    print(f"rep-{r}")
    stress_out(f"rep-{r}")
