import numpy as np
import numpy.linalg as la
import pandas as pd
import matplotlib.pyplot as plt

#=============Partie A==================#
fileBase = pd.read_csv("Parcoursup2022.csv", sep=";")
var_expl = fileBase[["Code départemental de l’établissement", 
                     "Capacité de l’établissement par formation", 
                     "Effectif des admis néo bacheliers généraux ayant eu une mention au bac"]]
var_endo = fileBase[["Sélectivité"]]


def conversion():
    global var_expl
    dt_integer = var_expl.copy()
    dt_integer["Code départemental de l’établissement"] = dt_integer["Code départemental de l’établissement"].replace(to_replace={"2A":"20", "2B":"20"})
    dt_integer["Code départemental de l’établissement"] = pd.to_numeric(dt_integer["Code départemental de l’établissement"])
    return dt_integer

var_expl = conversion()


#=============Partie B==================#
def boite_moustache_capacite(fileBase):
    plt.boxplot([fileBase[fileBase["Sélectivité"] == "formation non sélective"]["Capacité de l’établissement par formation"],
             fileBase[fileBase["Sélectivité"] == "formation sélective"]["Capacité de l’établissement par formation"]],
            labels=["Non sélective", "Sélective"], showfliers=False)
    plt.title("la sélectivité selon la capacité de la formation")
    plt.savefig('boiteMoustacheCapacite.png')
    plt.show()
    
def boite_moustache_mention(fileBase):
    plt.boxplot([fileBase[fileBase["Sélectivité"] == "formation non sélective"]["Effectif des admis néo bacheliers généraux ayant eu une mention au bac"],
             fileBase[fileBase["Sélectivité"] == "formation sélective"]["Effectif des admis néo bacheliers généraux ayant eu une mention au bac"]],
            labels=["Non sélective", "Sélective"], showfliers=False)
    plt.title("la sélectivité selon le nombre de mention obtenus par les néo bacheliers")
    plt.savefig('boiteMoustacheMention.png')
    plt.show()    

def nuagePointsCapa(matr_expl):
    x = matr_expl[:,1]
    y = matr_expl[:,0]
    plt.title("la capacité par rapport à la région")
    plt.scatter(x,y)
    plt.ylabel("code départemental")
    plt.xlabel("Capacité des formation")
    plt.savefig("PointsCapa.png")
    plt.show()
    
def nuagePointsMention(matr_expl):
    x = matr_expl[:,2]
    y = matr_expl[:,0]
    plt.title("la mention par rapport à la région")
    plt.scatter(x,y)
    plt.ylabel("code départemental")
    plt.xlabel("Nombre de mentions obtenus")
    plt.savefig("PointsMention.png")
    plt.show()
    
#=============Partie C==================#
var_endo_replace = var_endo.replace(to_replace={'formation non sélective': 0, 'formation sélective': 1})

matr_expl = var_expl.to_numpy()
matr_endo = var_endo_replace.to_numpy()

matr_og = np.ones((matr_expl.shape[0], 4))
matr_og[:,1] = matr_expl[:,0]
matr_og[:,2] = matr_expl[:,1]
matr_og[:,3] = matr_expl[:,2]

def transpose(matr):
    return np.transpose(matr)

def inverse(matr):
    return la.inv(matr)

def calculRegression(matr, matrEndo):
    tCalc = np.dot(transpose(matr), matr)
    inver = inverse(tCalc)
    
    calculA = np.dot(inver, transpose(matr))
    matrA = np.dot(calculA, matrEndo)
    return matrA
    
#=============Partie D==================#
def calculErreur(matr, matrCompl, matrEndo):
    taille = matrCompl.shape[0]
    Ypred = np.dot(matrCompl, matr)
    auCarre = np.sum((Ypred-matrEndo)**2)
    Erreur = auCarre/taille
    return Erreur

def coefCorr(matr,matrCompl, matrEndo):
    erreur = calculErreur(matr, matrCompl, matrEndo)
    return np.sqrt(1-(erreur/np.var(matrEndo)))

#=============Appel des fonctions et export de la dataframe sous csv==================#

boite_moustache_capacite(fileBase)
boite_moustache_mention(fileBase)
nuagePointsCapa(matr_expl)
nuagePointsMention(matr_expl)
#on rend l'affichage propre
print("")
#résultats des calculs
print("Les valeurs de la régression linéaire : ")
print(calculRegression(matr_og, matr_endo))
print("Le coefficient de corrélation : ")
print(coefCorr(calculRegression(matr_og, matr_endo), matr_og, matr_endo))

vue = pd.DataFrame({"Code départemental de l’établissement" : var_expl["Code départemental de l’établissement"], 
                    "Capacité de l’établissement par formation" : var_expl["Capacité de l’établissement par formation"], 
                    "Effectif des admis néo bacheliers généraux ayant eu une mention au bac" : var_expl["Effectif des admis néo bacheliers généraux ayant eu une mention au bac"],
                   "Sélectivité" : var_endo["Sélectivité"]})

vue.to_csv("vue_attributs_choisis.csv", sep=';', index=False)

