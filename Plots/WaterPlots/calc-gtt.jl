using LsqFit
using DataFrames
using CSV

using Plots

pgfplotsx()

celcius_to_kelvin(temp) = temp + 273.15

function calculate_tg(df)

    temp_range = df[!, "Temp"]
    average_density = df[!, "Mean"]

    T0 = temp_range[13]
    rho0 = average_density[13]
    # T_0, rho_0, a, b, c
    phi0 = [T0, rho0, 0.00001, 0.00001, 0.5]

    @. model(T, phi) =
        phi[2] - phi[3] * (T - phi[1]) -
        phi[4] * (0.5 * (T - phi[1]) + sqrt((T - phi[1])^2 / 4 + exp(phi[5])))

    parabola_temp = range(temp_range[1], temp_range[end], step = 0.01)

    fit = curve_fit(model, temp_range, average_density, phi0)
    parabolaRho = model(parabola_temp, coef(fit))
    final_phi = coef(fit)
    tg = final_phi[1]
    sigma = stderror(fit)

    [tg, sigma[1]]

end

function plot_up()

    plot(
        xlabel = "Deformation of Box Length (%)",
        ylabel = "Young's Modulus (GPa)",
        legend = :topright,
    )

    up_l_l = [0.005, 0.01, 0.02, 0.03, 0.04, 0.05]
    up_percent_l = map(u -> u * 100, up_l_l)
    comp_l = [
        2.950054795550884,
        2.995757120174143,
        2.883261277337939,
        2.833686919817287,
        2.789793292576296,
        2.69187540507486,
    ]
    error_l = [
        0.20517284313676,
        0.13593298905948148,
        0.0875314882718179,
        0.05358015063560783,
        0.06669283351389962,
        0.051700909012843556,
    ]


    plot!(up_percent_l, comp_l, yerr = error_l, label = "")

    savefig("Output/σ-up.pdf")


    nothing
end

function plot_time()
    plot(
        xlabel = "Simulation Time (ns)",
        ylabel = "Young's Modulus (GPa)",
        legend = :topright,
    )

    len_l = [0.2, 0.4, 0.6, 0.8, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 5.0, 6.0]
    time_m = 0.1
    # 6*(2*(nequil+nrun))
    # or 6*4*nrum
    x_l = map(t -> 6 * 4 * t * 0.1, len_l)
    comp_l = [
        3.433537703341512,
        3.1882848951261535,
        3.1101535175721127,
        2.979281908643448,
        2.903105186362492,
        2.750091997310515,
        2.691075974978936,
        2.629168574634594,
        2.585364304217597,
        2.46176742704544,
        2.494198769767904,
        2.378165662667681,
        2.3976373361253898,
    ]
    error_l = [
        0.04518879561255882,
        0.10462529054147578,
        0.08798765083215604,
        0.06542314914670301,
        0.06747664609758668,
        0.09292427103796999,
        0.05895237583754088,
        0.08633619119677986,
        0.08898196404559901,
        0.08029436302228518,
        0.07577645176902108,
        0.13438968002096213,
        0.11064965006311832,
    ]

    plot!(x_l, comp_l, yerr = error_l, label = "")

    savefig("Output/σ-len.pdf")


    nothing
end


plot_up()
plot_time()


wt_l = collect(0:5)

material = "Epoxy"
tg = reduce(
    hcat,
    map(
        wt -> calculate_tg(DataFrame(CSV.File("Data/$(material)-$(wt)-density.txt"))),
        wt_l,
    ),
)

e_df = DataFrame(wt = wt_l, tg = tg[1, :], sd = tg[2, :], material = material)


material = "Graphene"
tg = reduce(
    hcat,
    map(
        wt -> calculate_tg(DataFrame(CSV.File("Data/$(material)-$(wt)-density.txt"))),
        wt_l,
    ),
)
g_df = DataFrame(wt = wt_l, tg = tg[1, :], sd = tg[2, :], material = material)


df = reduce(vcat, [e_df, g_df])
CSV.write("Data/tg-wt.csv", df)
