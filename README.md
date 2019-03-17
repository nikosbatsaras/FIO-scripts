# Description
This is a FIO benchmark suite. Using the above scripts you can generate
datasets and plots regarding device throughput.

# Dependencies
Make sure you have:
- FIO
- Python 3+ (with matplotlib and numpy)

# Simple Benchmarks
In this section, we showcase a sample run to peak at how a device is behaving
in terms of throughput. If you want a more complete set of runs, follow the
next section, 'Complete Benchmarks'.
## Run
In order to perform some simple runs you can use the runfio.sh script:
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

# Complete Benchmarks
In this section, we showcase how to perform a more complete set of benchmarks.
## Run
First, edit the fiodriver.sh script to set your configuration. The script can
be used like this:
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
You can perform runs to get a dataset of:
- Random/Sequential Reads and Writes
- for a variety of different I/O Queue Depths
- for different block sizes
- on several devices

## Plot
In order to create a plot from the output, you can use the plotfio.py script:
```
Usage:
       plotfio.py [ -h ]
                    -f FILES      [FILES ... ] 
                    -l LABELS    [LABELS ... ]
		  [ -m MARKERS [MARKERS  ...]]
		  [ -s SCALE ]
		    -x XLABEL
		    -y YLABEL
		    -o OUTPUTFOLDER
		    -n NAME
		    -t TITLE

Options:
       -h, --help                Show this help message and exit
       -f FILES [FILES ...]      The out.txt files
       -l LABELS [LABELS ...]    Label for each curve
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
The 'out.txt' files are the ones that plotfio.py needs.

## TODO
-  Automate plotting
