import argparse
import csv

#levels = ["A1", "A2", "B1"]
levels = ["B2"]
#levels = ["C1","C2"]
lengthVerb = 23
lengthTrans = 17

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
                    if len(pair) > lengthVerb:
                        pairA = pair.split('/')
                        imperf = pairA[0]
                        perf = pairA[1]
                        if not (perf.endswith(imperf) and (len(perf) + 2) <= lengthVerb):
                            bigPairs += 1
                            bigPairsA.append(pair)
                    #print(transFR)
                    #print(transEN)
                    if len(transFR) > lengthTrans:
                        bigTransFR += 1
                        bigTransFRA.append(transFR)
                    if len(transEN) > lengthTrans:
                        bigTransEN += 1
                        bigTransENA.append(transEN)

    print("num row: " + str(i))
    print("------------------------------------------------")
    print("num pairs > " + str(lengthVerb) + " chars: " + str(bigPairs))
    print("big pairs: " + str(bigPairsA))
    print("longest pairs: ")
    ordBigPairsA = sorted(bigPairsA, key=len)
    for pair in ordBigPairsA:
        print(pair + ";" + str(len(pair)))

    print("------------------------------------------------")
    print("num FR translation > " + str(lengthTrans) + " chars: " + str(bigTransFR))
    print("big FR translation: " + str(bigTransFRA))
    print("------------------------------------------------")
    print("num EN translation > " + str(lengthTrans) + " chars: " + str(bigTransEN))
    print("big EN translation: " + str(bigTransENA))
