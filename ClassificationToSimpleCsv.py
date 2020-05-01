import argparse
import csv

levels = ["A1", "A2", "B1"]

with open("RussianVerbsClassification.csv", 'r', newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter=';')
    i = 0
    bigPairs = 0
    bigPairsA = []
    bigTransFR = 0
    bigTransFRA = []
    bigTransEN = 0
    bigTransENA = []

    for row in reader:
            i += 1
            verbRank = row['Ранг ГЛ']
            lvl = row['Уровень']
            pair = row['Пара аспектов']
            transFR = row['По-французски'].split(',')[0]
            transEN = row['По-английски'].split(',')[0]
            if lvl in levels:
                if verbRank != "10000":
                    #print(pair)
                    if len(pair) > 22:
                        bigPairs += 1
                        bigPairsA.append(pair)
                    #print(transFR)
                    #print(transEN)
                    if len(transFR) > 18:
                        bigTransFR += 1
                        bigTransFRA.append(transFR)
                    if len(transEN) > 18:
                        bigTransEN += 1
                        bigTransENA.append(transEN)

    print("num row: " + str(i))
    print("------------------------------------------------")
    print("num pairs > 22 chars: " + str(bigPairs))
    print("big pairs: " + str(bigPairsA))
    print("------------------------------------------------")
    print("num FR translation > 18 chars: " + str(bigTransFR))
    print("big FR translation: " + str(bigTransFRA))
    print("------------------------------------------------")
    print("num EN translation > 18 chars: " + str(bigTransEN))
    print("big EN translation: " + str(bigTransENA))
