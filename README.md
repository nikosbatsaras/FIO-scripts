# Description
This is a FIO benchmark suite. Using the above scripts you can generate
datasets and plots regarding device throughput.

# Dependencies
Make sure you have:
- FIO
- Python 3+ (with matplotlib and numpy)

# Run the fiodriver.sh script
First, edit fiodriver.sh to set your configuration. Then you can run the script
like this:
```
Usage:
	fiodriver.sh -o <output-dir> [-h]

Options:
	-o   Output directory
	-h   Show usage
```
An example run is the following:
```bash
fiodriver.sh -o SAMSUNG_850_PRO
```
By default, the script will run with:
- random/sequential reads and writes
- for a variety of different I/O queue depths
- for different block sizes

All output is saved in the 'output-dir' folder (e.g. SAMSUNG_850_PRO). The
script will also generate various plots based on your configuration. For a
finer-grained control of the runs, you can execute the runfio.sh and plotfio.sh
scripts manually.

# Run scripts manually
To run FIO on a device manually use the runfio.sh script:
```
Usage:
       runfio.sh -d <device> -n <njobs> -i <iodepth> -f <script> -o <output-dir> [-h]

Options:
       -d   Block device to test
       -n   Number of FIO processes/threads (numjobs)
       -i   Number of outstanding I/Os (iodepth)
       -f   Script containing the rest of FIO options
       -o   Output directory
       -h   Show usage
```
An example run is the following:
```bash
runfio.sh -d sdb -n 1 -i 32 -f scripts/rand-write.fio -o sdb_random_writes
```
This configuration will run with a variety of different block sizes by default.
Apart from the output produced for each block size, in the end we will have a
csv type file with name "out.txt" holding the throughput achieved for each
block size.

In order to create a plot from the output, you can use the plotfio.py script:
```
Usage:
       plotfio.py [ -h ]
                    -f FILES      [FILES ... ]
                    -l LABELS    [LABELS ... ]
                  [ -m MARKERS  [MARKERS ...]]
                  [ -s SCALE ]
                    -x XLABEL
                    -y YLABEL
                    -o OUTPUTFOLDER
                    -n NAME
                    -t TITLE

Options:
       -h, --help                Show this help message and exit
       -f FILES     [FILES ...]  The out.txt files
       -l LABELS   [LABELS ...]  Label for each curve
       -m MARKERS [MARKERS ...]  Marker for each curve
       -s SCALE                  Scale of y-axis
       -x XLABEL                 Label of x-axis
       -y YLABEL                 Label of y-axis
       -o OUTPUTFOLDER           Ouput folder
       -n NAME                   Name of output plot
       -t TITLE                  Title of output plot

```
An example run is the following:
```bash
plotfio.py -f rand_w_sdb_1iodepth_1threads/out.txt rand_w_sdb_32iodepth_1threads/out.txt \
           -l "iodepth-1" "iodepth-32"                                                   \
           -x "Request Size (KB)"                                                        \
           -y "Throughput (MB/s)"                                                        \
           -o "SAMSUNG_850_PRO"                                                          \
           -n "rand_w_sdb"                                                               \
           -t "Random Writes on Samsung 850 Pro"
```
