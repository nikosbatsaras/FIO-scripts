#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import csv, argparse

parser = argparse.ArgumentParser()
parser.add_argument('-r', dest="randfile", required=False, help="Input file with rand data")
parser.add_argument('-s', dest="seqfile", required=False, help="Input file with seq data")
parser.add_argument('-o', dest="outputfolder", required=True, help="Ouput folder")
parser.add_argument('-n', dest="name", required=True, help="Name of output plot")
parser.add_argument('-t', dest="title", required=True, help="Title of output plot")
args = parser.parse_args()

files = []

if args.randfile is not None:
    files.append(args.randfile)

if args.seqfile is not None:
    files.append(args.seqfile)

if not files:
    print("ERROR: No files were given!")
    exit()

for f in files:
    csvfile = open(f, 'r')

    reader = csv.reader(csvfile, delimiter=',')
    header = next(reader, None)

    x, y = [], []
    for row in reader:
        x.append(int(row[0]))
        y.append(float(row[1]))

    N  = len(x)
    x2 = np.arange(N)

    if f == args.randfile:
        plt.plot(x2, y, label="Random")
    elif f == args.seqfile:
        plt.plot(x2, y, label="Sequential")

    plt.xticks(x2, x, rotation=90)

    csvfile.close()

plt.xlim(xmin=0)
plt.ylim(ymin=0)
plt.xlabel(header[0])
plt.ylabel(header[1])

plt.title(args.title)
plt.legend()

plt.show()
#plt.savefig(args.outputfolder+"/"+args.name+".eps", format="eps")
