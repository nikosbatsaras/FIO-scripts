#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import csv, argparse, re

parser = argparse.ArgumentParser()
parser.add_argument('-f', dest="files", type=str, nargs='+', help='The out.txt files')
parser.add_argument('-o', dest="outputfolder", required=True, help="Ouput folder")
parser.add_argument('-n', dest="name", required=True, help="Name of output plot")
parser.add_argument('-t', dest="title", required=True, help="Title of output plot")
args = parser.parse_args()

for f in args.files:
    with open(f, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        header = next(reader, None)

        x, y = [], []
        for row in reader:
            x.append(int(row[0]))
            y.append(float(row[1]))

        N  = len(x)
        x2 = np.arange(N)

        plt.plot(x2, y, label="IODEPTH: " + re.findall(r'\d+', f)[0])
        plt.xticks(x2, x, rotation=90)

plt.xlabel(header[0])
plt.ylabel(header[1])

plt.xlim(xmin=0)
plt.ylim(ymin=0)

plt.title(args.title)
plt.legend()

plt.show()
#plt.savefig(args.outputfolder+"/"+args.name+".eps", format="eps")
