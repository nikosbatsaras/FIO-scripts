#!/usr/bin/env python3

import matplotlib.pyplot as plt
import numpy as np
import csv, argparse

parser = argparse.ArgumentParser()
parser.add_argument('-f', dest="files", type=str, nargs='+', required=True, help='The out.txt files')
parser.add_argument('-l', dest="labels", type=str, nargs='+', required=True, help='Label for each curve')
parser.add_argument('-m', dest="markers", type=str, nargs='+', required=False, help='Marker for each curve')
parser.add_argument('-s', dest="scale", type=str, required=False, help='Scale of y-axis')
parser.add_argument('-x', dest="xlabel", type=str, required=True, help='Label of x-axis')
parser.add_argument('-y', dest="ylabel", type=str, required=True, help='Label of y-axis')
parser.add_argument('-o', dest="outputfolder", required=True, help="Ouput folder")
parser.add_argument('-n', dest="name", required=True, help="Name of output plot")
parser.add_argument('-t', dest="title", required=True, help="Title of output plot")
args = parser.parse_args()

scale = None

if args.scale is not None:
    scale = args.scale

index = 0

for f in args.files:
    with open(f, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        header = next(reader, None)

        x, y = [], []
        for row in reader:
            x.append(int(row[0]))

            if scale == "MB":
                if "MB" in header[1]:
                    y.append(float(row[1]))
                elif "KB" in header[1]:
                    y.append(float(row[1]) / float(1024))

            elif scale == "GB":
                if "MB" in header[1]:
                    y.append(float(row[1]) / float(1024))
                elif "KB" in header[1]:
                    y.append(float(row[1]) / float(1024*1024))

            else:
                    y.append(float(row[1]))

        N  = len(x)
        x2 = np.arange(N)

        if args.markers is not None:
            plt.plot(x2, y, marker=args.markers[index], markersize=7, fillstyle='none', label=args.labels[index])
        else:
            plt.plot(x2, y, label=args.labels[index])

        plt.xticks(x2, x, rotation=90)

        index += 1

plt.xlabel(args.xlabel)
plt.ylabel(args.ylabel)

plt.xlim(left=0)
plt.ylim(bottom=0)

plt.title(args.title)
plt.legend()

plt.tight_layout()

#plt.show()
plt.savefig(args.outputfolder+"/"+args.name+".eps", format="eps")
