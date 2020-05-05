import argparse
import csv

#levels = ["A1", "A2", "B1"]
levels = ["B2"]
#levels = ["C1","C2"]
lengthVerb = 23
lengthTrans = 16

with open("RussianVerbsClassification.csv", 'r', newline='') as csvfile:
    reader = csv.DictReader(csvfile, delimiter=';')
    i = 0
    bigPairs = 0
    bigPairsA = []
    bigTransFR = 0
    bigTransFRA = []
    bigTransEN = 0
    bigTransENA = []

    allVerbsOrder = []
    allVerbs = {}

    for row in reader:
            i += 1
            verbRank = row['Ранг ГЛ']
            lvl = row['Уровень']
            infinitive = row['Инфинитив']
            pair = row['Пара аспектов']
            transFR = row['По-французски'].split(',')[0]
            transEN = row['По-английски'].split(',')[0]
            verbData = ""

            if lvl in levels:
                if verbRank != "10000":
                    #Verb
                    verb = infinitive
                    if pair != "":
                        verb = pair
                        # Simplify perf/imperf if possible
                        pairA = pair.split('/')
                        imperf = pairA[0]
                        perf = pairA[1]
                        if perf.endswith(imperf):
                            lenPrefix = len(perf) - len(imperf)
                            verb = imperf + '/' + perf[0:lenPrefix] + '-'
                        verb = verb.replace("/", "\slash ")

                    #Translation
                    trans = transFR[0:lengthTrans]

                    if verb not in allVerbsOrder:
                        allVerbsOrder.append(verb)
                    allVerbs[verb] = trans

    allVerbsKeys = allVerbs.keys()
    newVerbsKeys = sorted(allVerbsKeys)

    for verb in newVerbsKeys:
        print(verb + ',' + allVerbs[verb])
