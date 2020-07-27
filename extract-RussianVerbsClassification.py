import argparse
import csv
#from RussianWordsClusters import cluster.RussianWordsPairsClusters as rwc
#from RussianWordsClusters import cluster.Relation
#import RussianWordsClusters
from russianwords.clustering import RussianWordsPairsClusters as rwc
from russianwords.clustering import Relation

colSep = ';'
transSepBig = ';'
transSepSmall = ','

def genCsv(levels, order, yellowCol, yellowWhen):
    with open("RussianVerbsClassification.csv", 'r', newline='') as csvfile:
        reader = csv.DictReader(csvfile, delimiter=';')

        allVerbsOrder = []
        allVerbs = {}

        # Build an initial array of verbs
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

                # name of verb is the verb pair if available, else a single verb
                if lvl in levels:
                    if verbRank != "10000":
                        verb = infinitive
                        # Fetch pair if available
                        if pair != "":
                            verb = pair

                        if verb not in allVerbsOrder:
                            allVerbsOrder.append(verb)
                        allVerbs[verb] = {
                                "finalName": verb,
                                "usage": usage,
                                "transFr": transFR,
                                "transEn": transEN,
                                "yellow": yellow
                            }

        newVerbsKeys = []
        if order == 'abc':
            allVerbsKeys = allVerbs.keys()
            newVerbsKeys = sorted(allVerbsKeys)
        elif order == "abc_n_proximity":
            allVerbsKeys = allVerbs.keys()
            newVerbsKeys = sorted(allVerbsKeys)
            verbsClusters = rwc(newVerbsKeys)
            newVerbsKeys = rwc.flatten(verbsClusters.getWordsAndClusters([Relation.STEM, Relation.TRANS], True))
        elif order == "freq": # by frequency
            newVerbsKeys = allVerbsOrder
        elif order == "freq_n_proximity":
            verbsClusters = rwc(allVerbsOrder)
            newVerbsKeys = rwc.flatten(verbsClusters.getWordsAndClusters([Relation.STEM, Relation.TRANS], True))

        # Build lines of verbs
        # TODO Verb pairs have their char '/' turned to a Latex function
        for verb in newVerbsKeys:
            currentVerb = allVerbs[verb]
            finalName = currentVerb["finalName"]

            # Fix pairs perf/imperf
            #   - by keeping only the prefix
            #   - by replacing char '/' by a latex function
            if '/' in finalName:
                pairA = finalName.split('/')
                imperf = pairA[0]
                perf = pairA[1]
                if perf.endswith(imperf):
                    lenPrefix = len(perf) - len(imperf)
                    verb = imperf + '/' + perf[0:lenPrefix] + '-'
                currentVerb["finalName"] = finalName.replace("/", "\slash ")

            line = currentVerb["finalName"] + colSep + currentVerb["usage"] + colSep + currentVerb["transFr"] + colSep + currentVerb["transEn"]
            if yellowCol != None:
                line = line + colSep
                yellowVal = 1 if currentVerb["yellow"] == yellowWhen else 0
                line += str(yellowVal)
            print(line)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Fiters and Extractions on RussianVerbsClassification.csv')
    parser.add_argument('-l', '--cefr-levels', dest='levels', required=True, nargs='+', help='')
    parser.add_argument('-y', '--yellow', dest='yellow', nargs=2, default=None, help='2 strings: the first is the name of the field to use in a new yellow column, the second is the value of the field used to set the yellow field to 1 (else it equals 0)')
    parser.add_argument('-o', '--order', dest='order', nargs='?', choices=['abc', 'abc_n_proximity', 'freq', 'freq_n_proximity'], default='freq', help='order to classify data, either by frequency order or by alphabetical order')
    args = parser.parse_args()

    levels = args.levels
    order = args.order
    yellowCol = args.yellow[0]
    yellowWhen = args.yellow[1]

    columnsName = ""
    columnsNameA = ["verb", "usage", "transFr", "transEn"]
    if yellowCol != None:
        columnsNameA.append("yellow")
    for col in columnsNameA:
        columnsName = columnsName + col + colSep
    columnsName = columnsName[:-len(colSep)]

    print(columnsName)
    genCsv(levels, order, yellowCol, yellowWhen)
