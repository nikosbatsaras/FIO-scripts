# Description
This is a FIO benchmark suite. Using the above scripts you can generate
datasets and plots regarding device throughput.

# Dependencies
Make sure you have:
- FIO
- Python 3+ (with matplotlib and numpy)

# Run FIO
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

All output is saved in the <output-dir> folder (e.g. SAMSUNG_850_PRO). The
script will also generate various plots based on your configuration. For a
finer-grained control of the runs, you can execute the runfio.sh and plotfio.sh
scripts manually.
