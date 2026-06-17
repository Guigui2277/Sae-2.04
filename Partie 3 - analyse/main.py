import numpy as np
import pandas as pd

fileBase = pd.read_csv("Parcoursup2022.csv", sep=";")
var_expl = fileBase[["Code départemental de l’établissement", 
                     "Capacité de l’établissement par formation", 
                     "Effectif des admis néo bacheliers généraux ayant eu une mention au bac"]]
var_endo = fileBase[["Sélectivité"]]

matr_expl = var_expl.to_numpy()

print(matr_expl)
matr_expl

