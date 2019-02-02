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
next section about 'Complete Benchmarks'.
## Run
In order to perform some simple runs you can do the following:
```bash
runfio.sh -d sdb -n 16 -i 32 -f rand-write.fio -o sdb_random_writes
```
This essentially means:
- FIO will run on /dev/sdb
- There will be 16 threads producing I/O
- The device will have 32 outstanding I/O requests
- The I/O is random writes
- Output results in sdb_random_writes folder (create if not exist)

This configuration will run with a variety of different block sizes by default.
Apart from the output produced for each block size, in the end we will have a
csv type file with name "out.txt" holding the throughput achieved for each
block size.

## Plot
In order to create a plot from the output, you can do:
```bash
plotfio.py -r sdb_random_writes/out.txt -o . -n "SDB_RAND_W" -t "Random Writes with 32 IO Queue Depth"
```
This will read the "out.txt" from the previous run and produce a plot:
- In the current directory
- With a name: "SDB_RAND_W.eps"
- And a plot title: "Random Writes with 32 IO Queue Depth"

If you've performed a sequential run as well, you can do:
```bash
plotfio.py -r sdb_random_writes/out.txt -s sdb_sequential_writes/out.txt -o . -n "SDB_W" -t "Writes with 32 IO Queue Depth"
```
This will plot two curves, one for random and one for sequential I/O.

# Complete Benchmarks
In this section, we showcase how to perform a more complete set of benchmarks.
The whole process is automated by the scripts provided.
## Run
TODO
## Plot
TODO
