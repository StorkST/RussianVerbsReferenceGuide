import argparse
import csv

colSep = ';'
transSepBig = ';'
transSepSmall = ','

def genCsv(levels, yellowCol, order):
    with open("RussianVerbsClassification.csv", 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';')

        allVerbsOrder = []
        allVerbs = {}

        for row in reader:
                verbRank = row['Ранг ГЛ']
                lvl = row['Уровень']
                infinitive = row['Инфинитив']
                pair = row['Пара аспектов']
                usage = row['Подробности'].split('-')[0]
                transFR = row['По-французски'].split(transSepBig)[0]
                transEN = row['По-английски'].split(transSepBig)[0]
                yellow = None
                if yellowCol != None:
                    yellow = row[yellowCol]

                if lvl in levels:
                    if verbRank != "10000":
                        verb = infinitive
                        # Fetch pair if available
                        if pair != "":
                            verb = pair
                            # Try to simplify pair perf/imperf if possible
                            # by keeping only the prefix
                            pairA = pair.split('/')
                            imperf = pairA[0]
                            perf = pairA[1]
                            if perf.endswith(imperf):
                                lenPrefix = len(perf) - len(imperf)
                                verb = imperf + '/' + perf[0:lenPrefix] + '-'
                            verb = verb.replace("/", "\slash ")

                        if verb not in allVerbsOrder:
                            allVerbsOrder.append(verb)
                        allVerbs[verb] = {
                                "usage": usage,
                                "transFr": transFR,
                                "transEn": transEN,
                                "yellow": yellow
                        }

        newVerbsKeys = []
        if order == 'abc':
            allVerbsKeys = allVerbs.keys()
            newVerbsKeys = sorted(allVerbsKeys)
        else: # by frequency
            newVerbsKeys = allVerbsOrder

        for verb in newVerbsKeys:
            p = allVerbs[verb]
            line = verb + colSep + p["usage"] + colSep + p["transFr"] + colSep + p["transEn"]
            if yellowCol != None:
                line = line + colSep + p["yellow"]
            print(line)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fiters and Extractions on RussianVerbsClassification.csv')
    parser.add_argument('-l', '--cefr-levels', dest='levels', required=True, nargs='+', help='')
    parser.add_argument('-y', '--yellow', dest='yellow', nargs = '?', default=None, help='field to put in a new yellow column')
    parser.add_argument('-o', '--order', dest='order', nargs='?', choices=['freq', 'abc'], default='freq', help='order to classify data, either by frequency order or by alphabetical order')
    args = parser.parse_args()

    levels = args.levels
    yellowCol = args.yellow
    order = args.order

    columnsName = ""
    columnsNameA = ["verbs", "usage", "transFr", "transEn"]
    if yellowCol != None:
        columnsNameA.append("yellow")
    for col in columnsNameA:
        columnsName = columnsName + col + colSep
    columnsName = columnsName[:-len(colSep)]

    print(columnsName)
    genCsv(levels, yellowCol, order)
