#!/usr/bin/env bash

block_sizes=( 4 8 16 32 64 128 256 512 1024 2048 4096 8192 )

function usage() {
        echo
        echo "Usage:"
        echo "      runfio.sh -d <device> -n <njobs> -i <iodepth> -f <script> -o <output-dir> [-h]"
        echo
        echo "Options:"
        echo "      -d   Block device to test"
	echo "      -n   Number of FIO processes/threads (numjobs)"
	echo "      -i   Number of outstanding I/Os (iodepth)"
        echo "      -f   Script containing the rest of FIO options"
        echo "      -o   Output directory"
        echo "      -h   Show usage"
        echo

        exit 1
}

while getopts ":d:n:i:f:o:h" opt
do
        case $opt in
                d)
                        if [ ! -b "/dev/$OPTARG" ]; then
                                echo "ERROR: Block device $OPTARG does not exist." >&2; usage
                        fi

                        check=$(mount | grep "$OPTARG")
                        if [ ! "$check" = '' ]; then
                                echo "ERROR: Block device $OPTARG is in use. Use another one."
                                exit 1
                        fi
        
                        blockdevice="$OPTARG";;
                n)
                        njobs="$OPTARG";;
                i)
                        iodepth="$OPTARG";;
                f)
                        if [ ! -f "$OPTARG" ]; then
                                echo "ERROR: File $OPTARG does not exist." >&2; usage
                        fi 
                        file="$OPTARG";;
		o)
			if [ ! -d "$OPTARG" ]; then
				mkdir "$OPTARG"
			fi
			directory="$OPTARG";;
                \?)
                        echo "ERROR: Invalid option: -$OPTARG" >&2; usage;;
                :)
                        echo "ERROR: Option -$OPTARG requires an argument." >&2; usage;;
                h | *)
                        usage;;
        esac
done

if [ -z $blockdevice ]; then
        echo "ERROR: Block device not specified" >&2
        usage
fi
if [ -z $iodepth ]; then
        echo "ERROR: I/O depth not specified" >&2
        usage
fi
if [ -z $njobs ]; then
        echo "ERROR: Number of jobs not specified" >&2
        usage
fi
if [ -z $file ]; then
        echo "ERROR: Script file not specified" >&2
        usage
fi
if [ -z $directory ]; then
        echo "ERROR: Output directory not specified" >&2
        usage
fi

echo
echo "========================================================================"
echo
echo "Starting run with: $file"
echo
echo "    Device:  $blockdevice"
echo "    IODEPTH: $iodepth"
echo "    NUMJOBS: $njobs"
echo
echo -n "    Block Size: "
STARTTIME=$(date +%s)
for bs in ${block_sizes[@]}; do
	if [ $(cat "/sys/block/${blockdevice}/queue/rotational") -eq 0 ]; then
		sudo blkdiscard /dev/"$blockdevice"
	fi
	echo -n "${bs}KB "
	{ sudo SIZE='80%' BLOCK_SIZE="${bs}k" DEVICE="$blockdevice" IODEPTH="$iodepth" NJOBS="$njobs" fio "$file" ; } 2>&1 >> "${directory}/${bs}.txt"
done
echo
ENDTIME=$(date +%s)
ELAPSEDTIME=$(($ENDTIME - $STARTTIME))
FORMATED="$(($ELAPSEDTIME / 3600))h:$(($ELAPSEDTIME % 3600 / 60))m:$(($ELAPSEDTIME % 60))s"
echo
echo "    Benchmark time elapsed: $FORMATED"
echo
echo "========================================================================"
echo

str="$(fio --version)"
version="${str:4:1}"

if [ "$version" -eq 3 ]; then
	check=$(grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep "K")
	if [ "$check" = "" ]; then
		echo "Block Size (KB),Throughput (MB/s)" > "${directory}/out.txt"
	else
		echo "Block Size (KB),Throughput (KB/s)" > "${directory}/out.txt"
	fi
else
	check=$(grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep "K")
	if [ "$check" = "" ]; then
		echo "Block Size (KB),Throughput (MB/s)" > "${directory}/out.txt"
	else
		echo "Block Size (KB),Throughput (KB/s)" > "${directory}/out.txt"
	fi
fi

for bs in ${block_sizes[@]}; do
	echo -n "$bs," >> "${directory}/out.txt"
	if [ "$version" -eq 3 ]; then
		grep 'bw=' "${directory}/${bs}.txt" | awk '{print $2}' | grep -o '[0-9.]*' >> "${directory}/out.txt"
	else
		grep 'aggrb=' "${directory}/${bs}.txt" | awk '{print $3}' | grep -o '[0-9.]*' >> "${directory}/out.txt"
	fi
done
