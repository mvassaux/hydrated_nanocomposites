library(tidyverse)
library(ggpubr)

library(extrafont)
library(fontcm)
library(latex2exp)

options(readr.num_columns = 0)

calculate_mean <- function(graphene, wt, elastic_prop) {
  fname <- str_glue("Data/{graphene}-{wt}-modulus.csv")
  df <- read_csv(fname)
  mean(df[[elastic_prop]])
}
calculate_sd <- function(graphene, wt, elastic_prop) {
  fname <- str_glue("Data/{graphene}-{wt}-modulus.csv")
  df <- read_csv(fname)
  sd(df[[elastic_prop]])
}

create_plot_df <- function(graphene, wt_l, elastic_prop) {
  mean_l <- wt_l |> map_dbl(\(wt) calculate_mean(graphene, wt, elastic_prop))
  sd_l <- wt_l |> map_dbl(\(wt) calculate_sd(graphene, wt, elastic_prop))
  tibble(wt = wt_l, prop_mean = mean_l, prop_sd = sd_l, material = graphene)
}

plot_property <- function(prop_index) {
  graphene_l <- c("Graphene", "Epoxy")
  wt_l <- c(0, 1, 2, 3, 4, 5)
  elastic_prop_l <- c("youngs_modulus", "bulk_modulus", "shear_modulus_1", "shear_modulus_2", "poissons_ratio")
  prop_label_l <- c("Young's Modulus (GPa)", "Bulk Modulus (GPa)", "Shear Modulus 1 (GPa)", "Shear Modulus 2 (GPa)", "Poisson's ratio")

  elastic_prop <- elastic_prop_l[[prop_index]]
  prop_label <- prop_label_l[[prop_index]]

  g_df <- create_plot_df("Graphene", wt_l, elastic_prop)
  e_df <- create_plot_df("Epoxy", wt_l, elastic_prop)

  plot_data <- bind_rows(g_df, e_df)

  p <- ggplot(plot_data, aes(wt, prop_mean, colour = material)) +
    geom_point() +
    geom_line() +
    geom_errorbar(aes(ymin = prop_mean - prop_sd, ymax = prop_mean + prop_sd), width = 0.1) +
    labs(
      x = "Water Content (wt %)",
      y = str_glue("{prop_label}"),
      colour = "Material",
    ) +
    theme_pubr() +
    grids(color = "grey92", linetype = "solid")

  ggsave(str_glue("Output/{elastic_prop}-stress.pdf"))

  p
}

plot_stats <- function(wt, rep_num) {
  material_l <- c("Epoxy", "Graphene")

  mat_df <- material_l |> map(\(m) read_csv(str_glue("Data/{m}-{wt}-modulus.csv"))[["youngs_modulus"]])


  e_df <- tibble(youngs_modulus = sample(mat_df[[1]])[1:rep_num], material = "Epoxy")
  g_df <- tibble(youngs_modulus = sample(mat_df[[2]])[1:rep_num], material = "Graphene")
  data_df2 <- e_df %>% add_row(g_df)
  data_df <- e_df

  h <- 2 * (IQR(data_df[["youngs_modulus"]]) / rep_num^(1 / 3))
  gghistogram(data_df,
    x = "youngs_modulus", y = "density", fill = "material",
    add = "mean", binwidth = h, color = "material", add_density = TRUE, xlab = "Young's Modulus (GPa)", main = str_glue("wt {wt} %, {rep_num} replicas"), add.params = list(linetype = "dashed", color = "black")
  ) + grids(color = "grey92", linetype = "solid")

  ggsave(str_glue("Output/stats/hist-{rep_num}-reps.pdf"))

  ggqqplot(data_df, x = "youngs_modulus", color = "material", main = str_glue("wt {wt} %, {rep_num} replicas")) + grids(color = "grey92", linetype = "solid")
  ggsave(str_glue("Output/stats/qq-{rep_num}-reps.pdf"))
}

plot_rdf <- function(material, wt) {
  at_l <- c("05", "11", "12", "13", "14")
  label_l <- c("Aromatic C", "Amine N", "Water O", "Ether O", "Epoxy O")

  plot_data <- read_csv(str_glue("Data/RDF-Output/{material}-RDF.csv"))

  p <- ggplot(plot_data, aes(r, gr_mean, colour = atom_type)) +
    geom_line() +
    geom_ribbon(aes(ymin = gr_mean - gr_sd, ymax = gr_mean + gr_sd, fill = atom_type), alpha = 0.2) +
    labs(
      x = TeX(r"($r$ (Å))"),
      y = TeX(r"($g(r)$)"),
      colour = "Atom Type",
      title = str_glue("{material} {wt} wt%"),
    ) +
    theme_pubr() +
    grids(color = "grey92", linetype = "solid") +
    scale_color_discrete(labels = label_l) +
    scale_fill_discrete(guide = "none") +
    ylim(0, 25)


  ggsave(str_glue("Output/{material}-{wt}-RDF.pdf"))

  p
}

plot_tg_wt <- function() {
  tg_df <- read_csv("Data/tg-wt.csv", col_types = list(col_integer()))
  tg_df

  p <- ggplot(tg_df, aes(wt, tg, colour = material)) +
    geom_point() +
    geom_line() +
    geom_errorbar(aes(ymin = tg - sd, ymax = tg + sd), width = 0.1) +
    labs(
      x = TeX(r"(Water Content (wt\%))"),
      y = TeX(r"(Glass Transition Temperature (K))"),
      colour = "Material",
    ) +
    theme_pubr() +
    grids(color = "grey92", linetype = "solid")

  ggsave(str_glue("Output/Tg-wt.pdf"))
  p
}

plot_gtt <- function(g_material, wt_l) {
  all_tg_df <- read_csv("Data/tg-wt.csv", col_types = list(col_character()))
  df_l <- wt_l |> map(\(wt) read_csv(str_glue("Data/{g_material}-{wt}-density.txt"), col_types = list(col_integer())) %>% add_column(material = g_material, wt = as.character(wt)))

  density_df <- bind_rows(df_l)

  tg_df <- all_tg_df %>% filter(material == g_material)

  p <- ggplot(density_df, aes(Temp, Mean, colour = wt)) +
    geom_line() +
    geom_errorbar(aes(ymin = Mean - SD, ymax = Mean + SD), width = 0.1) +
    labs(
      x = TeX(r"(Temperature (K))"),
      y = TeX(r"(Density ($\textrm{g}/\textrm{cm}^{3}$))"),
      colour = "Water Content (wt%)"
    ) +
    theme_pubr() +
    grids(color = "grey92", linetype = "solid") +
    geom_vline(aes(xintercept = tg, colour = wt), tg_df, linetype = "dashed") +
    ylim(0.8, 1.2)

  ggsave(str_glue("Output/{g_material}-Tg.pdf"))

  p
}

rep_tibble <- function(df, elastic_prop, rep, graphene) {
  data_df <- df %>% filter(wrep == rep)
  tibble(rep = as.character(rep), prop_mean = mean(data_df[[elastic_prop]]), prop_sd = sd(data_df[[elastic_prop]]), material = graphene)
}

all_reps_plot <- function(wt, elastic_prop) {
  rep_l <- seq(0, 9)
  graphene_l <- c("Graphene", "Epoxy")

  graphene <- graphene_l[1]
  df <- read_csv(str_glue("Data/{graphene}-{wt}-modulus.csv"))
  g_df <- rep_l %>%
    map(\(rep) rep_tibble(df, elastic_prop, rep, graphene)) %>%
    bind_rows()

  graphene <- graphene_l[2]
  df <- read_csv(str_glue("Data/{graphene}-{wt}-modulus.csv"))
  e_df <- rep_l %>%
    map(\(rep) rep_tibble(df, elastic_prop, rep, graphene)) %>%
    bind_rows()

  plot_df <- bind_rows(g_df, e_df)

  p <- ggplot(plot_df, aes(rep, prop_mean, colour = material)) +
    geom_point() +
    geom_errorbar(aes(ymin = prop_mean - prop_sd, ymax = prop_mean + prop_sd), width = 0.1) +
    labs(
      x = TeX(r"(Unique Replica ID)"),
      y = TeX(r"(Young's Modulus (GPa))"),
      colour = "Material",
    ) +
    theme_pubr() +
    grids(color = "grey92", linetype = "solid") +
    ylim(2.05, 2.55)

  ggsave(str_glue("Output/wt-{wt}-rep-{elastic_prop}.pdf"))
}

wt <- 5
g_df <- tibble(ym = read_csv(str_glue("Data/Graphene-{wt}-modulus.csv"))[["youngs_modulus"]])
e_df <- tibble(ym = read_csv(str_glue("Data/Epoxy-{wt}-modulus.csv"))[["youngs_modulus"]])
write_csv(g_df, "g5.csv", col_names = FALSE)
write_csv(e_df, "e5.csv", col_names = FALSE)
