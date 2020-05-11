import argparse
import csv

#levels = ["A1", "A2", "B1"]
#levels = ["B2"]
#levels = ["C1","C2"]
#lengthVerb = 23
#lengthTrans = 16

colSep = ';'
transSepBig = ';'
transSepDst = ','

def genCsv(levels, columnsName, yellowCol):
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
                transFR = row['По-французски'].split(transSepBig)[0]
                transEN = row['По-английски'].split(transSepBig)[0]
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
                        if ',' in transFR:
                            trans = transFR[0:lengthTrans+1]
                            #trans = trans.replace(', ', transSepDst)
                        else:
                            trans = transFR[0:lengthTrans]

                        if verb not in allVerbsOrder:
                            allVerbsOrder.append(verb)
                        allVerbs[verb] = trans

        allVerbsKeys = allVerbs.keys()
        newVerbsKeys = sorted(allVerbsKeys)

        print("verb" + colSep + "transFR")
        for verb in newVerbsKeys:
            print(verb + colSep + allVerbs[verb])

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fiters and Extractions on RussianVerbsClassification.csv')
    parser.add_argument('-l', '--cefr-levels', dest='levels', required=True, nargs='+', help='')
    parser.add_argument('-y', '--yellow', dest='yellow', default=None, help='field to put in a new yellow column')
    args = parser.parse_args()

    levels = args.levels
    yellowCol = args.yellow

    columnsName = ""
    columnsNameA = ["verbs", "transEn", "transFr"]
    if yellowCol != None:
        columnsNameA.append(yellowCol)
    for col in columnsNameA:
        columnsName = columnsName + col + colSep
    columnsName = columnsName[:-length(colSep)]


    genCsv(levels, columnsName, yellow != yellowCol)
