import os
import numpy as np
import scipy
import scipy.stats as stats
import matplotlib.pyplot as plt
import seaborn as sns
import pylab

from sklearn.utils import resample
from arch.bootstrap import IIDBootstrap


def compute_avg_var(replicas):
    """
    compute bootstrapped average and variance
    :param replicas, list, values of average dU/dlam in each replica
    :return: turple of floats, average and var of boot strapped result
    """
    if len(replicas) > 1:
        boot = [
            resample(replicas, replace=True, n_samples=len(replicas))
            for x in range(5000)
        ]
        avg_per_boot_sample = np.average(boot, axis=1)
    else:
        print("Warning asked for variance of 1 replica")
        return replicas[0], 0.0

    return np.average(avg_per_boot_sample), np.var(avg_per_boot_sample, ddof=1)


def compute_bs_error(replicas, samples):
    """
    compute bootstrapped specifically for skew and kurt
    """
    if len(replicas) > 1:
        boot = [
            resample(replicas, replace=True, n_samples=samples) for x in range(5000)
        ]
        skew_per_boot_sample = [skew(x) for x in boot]
        kurt_per_boot_sample = [kurt(x) for x in boot]
    else:
        print("Warning asked for variance of 1 replica")
        return replicas[0], 0.0

    return (
        np.average(skew_per_boot_sample),
        np.var(skew_per_boot_sample, ddof=1),
        np.average(kurt_per_boot_sample),
        np.var(kurt_per_boot_sample, ddof=1),
    )


def plot_window_norm_freq(data, ana_dir, skew, kurt, lable=None):
    mu, std = scipy.stats.norm.fit(data)

    ax = sns.histplot(data, stat="density", binwidth=3.5 * (std / len(data) ** (1 / 3)))

    tl = (
        (ax.get_xlim()[1] - ax.get_xlim()[0]) * 0.010 + ax.get_xlim()[0],
        (ax.get_ylim()[1] - ax.get_ylim()[0]) * 0.95 + ax.get_ylim()[0],
    )

    xmin, xmax = plt.xlim()
    x = np.linspace(xmin, xmax, 100)
    p = scipy.stats.norm.pdf(x, mu, std)

    if lable is None:
        # ax.text(
        #     tl[0],
        #     tl[1],
        #     "skew = {}[{}, {}]: kurt = {}[{}, {}]".format(
        #         skew[0], skew[1], skew[2], kurt[0], kurt[1], kurt[2]
        #     ),
        # )
        pass
    if lable is None:
        ax.set(xlabel="Young's Modulus")
    else:
        ax.set(xlabel=lable)

    plt.plot(x, p, "k", linewidth=2)

    plt.savefig(os.path.join(ana_dir, "hist.pdf"))
    plt.close("all")


def load_data(file_name):
    data = []
    with open(file_name) as f:
        for line in f:
            data.append(float(line.strip("\n")))
    return data


def skew(x):
    return scipy.stats.skew(x)


def kurt(x):
    return scipy.stats.kurtosis(x)


def qq(data, analysis_dir):
    stats.probplot(data, dist="norm", plot=pylab)
    plt.title("")
    pylab.savefig(os.path.join(analysis_dir, "qq.pdf"))
    pylab.close("all")


def nulls(data):
    print(
        f"Shapiro: confidence (p-value) that the null hypothesis is false: {stats.shapiro(data)[1]}"
    )
    print(
        f"Person: confidence (p-value) that the null hypothesis is false: {stats.normaltest(data)[1]}"
    )


def convergence(data, sys_name, analysis_dir):
    all_skew = []
    all_kurt = []
    for i in range(len(data) // 5):
        samples = (i + 1) * 5
        sa, sv, ka, kv = compute_bs_error(data, samples)

        all_skew.append([sa, np.sqrt(sv)])
        all_kurt.append([ka, np.sqrt(kv)])

    means = [[x[0] for x in all_skew]]
    means.append([x[0] for x in all_kurt])

    cis = [[[x[0] - x[1], x[0] + x[1]] for x in all_skew]]
    cis.append([[x[0] - x[1], x[0] + x[1]] for x in all_kurt])

    x_axis = [[x * 5 for x in range(len(data) // 5)]]
    x_axis.append([x * 5 for x in range(len(data) // 5)])

    names = ["skewness", "kurtosis"]
    fig, ax = plt.subplots(nrows=1, ncols=1, figsize=(14, 10))

    sns.set_style("whitegrid")
    sns.set_context("paper", font_scale=2.2)

    for mean, ci, xx, name in zip(means, cis, x_axis, names):
        mean = np.array(mean)
        ci = np.array(ci)
        ax.plot(xx, mean, label=name, zorder=20)
        ax.fill_between(xx, [x[0] for x in ci], [x[1] for x in ci], alpha=0.3, zorder=1)
        np.savetxt("xx.csv", xx, delimiter=",")
        np.savetxt("mean.csv", mean, delimiter=",")
        np.savetxt("ci.csv", ci, delimiter=",")

    ax.set_xlabel("Number of Replicas")

    # ax.legend(loc='upper left', bbox_to_anchor=(1.0, 1.025), labelspacing=1.2)
    # ax.legend(loc='upper left', bbox_to_anchor=(1.0, 1.025), labelspacing=1.2)
    # plt.title(sys_name)
    ax.legend()
    ax.grid(True)

    plt.tight_layout()
    plt.savefig(os.path.join(analysis_dir, "convg.pdf"))
    plt.close("all")


def hist(data, analysis_dir):
    data = np.array(data)

    stats_functions = [skew, kurt]
    bs = IIDBootstrap(data)

    stats_estimates = [func(data) for func in stats_functions]

    stats_cis = [
        bs.conf_int(func, reps=5000, method="basic", size=0.95)
        for func in stats_functions
    ]

    skew_vals = [
        round(stats_estimates[0], 2),
        round(stats_cis[0][0][0], 2),
        round(stats_cis[0][1][0], 2),
    ]
    kurt_vals = [
        round(stats_estimates[1], 2),
        round(stats_cis[1][0][0], 2),
        round(stats_cis[1][1][0], 2),
    ]

    plot_window_norm_freq(data, analysis_dir, skew_vals, kurt_vals)


def main(file_names):
    for f in file_names:
        print("Processing {}...".format(f))
        ana_dir = os.path.join("analysis_out", f)
        if not os.path.exists(ana_dir):
            os.mkdir(ana_dir)
        data = load_data(f + ".csv")
        convergence(data, f, ana_dir)
        qq(data, ana_dir)
        nulls(data)
        hist(data, ana_dir)


if __name__ == "__main__":
    ###USER OPTIONS###

    # assume .csv suffix
    files_to_ana = ["e5", "g5"]

    plt.rcParams["figure.figsize"] = 12, 8
    plt.rcParams["font.size"] = 22
    plt.rcParams["font.serif"] = "Computer Modern Roman"
    plt.rcParams["mathtext.fontset"] = "cm"

    ###################
    if not os.path.exists("./analysis_out"):
        os.mkdir("analysis_out")
    main(files_to_ana)
