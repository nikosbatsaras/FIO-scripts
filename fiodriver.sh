#!/usr/bin/env bash

DEVICES=( sdb )
THREADS=1
IODEPTH=( 1 4 16 32 64 )
FIO_SCRIPTS='scripts'

function usage() {
        echo
        echo "Usage:"
        echo "      fiodriver.sh -o <output-dir> [-h]"
        echo
        echo "Options:"
        echo "      -o   Output directory"
        echo "      -h   Show usage"
        echo

        exit 1
}

while getopts ":o:h" opt
do
        case $opt in
		o)
			if [ ! -d "$OPTARG" ]; then
				mkdir "$OPTARG"
			fi
			DIRECTORY="$OPTARG";;
                \?)
                        echo "ERROR: Invalid option: -$OPTARG" >&2; usage;;
                :)
                        echo "ERROR: Option -$OPTARG requires an argument." >&2; usage;;
                h | *)
                        usage;;
        esac
done

if [ -z $DIRECTORY ]; then
        echo "ERROR: Output directory not specified" >&2
        usage
fi

DATE=$(date "+%F_%R")
OUTPUT="${DIRECTORY}/${DATE}"

mkdir "$OUTPUT"

STARTTIME=$(date +%s)

for DEVICE in ${DEVICES[@]}; do
	for IOD in ${IODEPTH[@]}; do
		# RANDOM WRITES
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-write.fio" -o "${OUTPUT}/rand_w_${DEVICE}_${IOD}iodepth_${THREADS}threads"
		# RANDOM READS
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-read.fio"  -o "${OUTPUT}/rand_r_${DEVICE}_${IOD}iodepth_${THREADS}threads"

		# SEQUENTIAL WRITES
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/write.fio" -o "${OUTPUT}/seq_w_${DEVICE}_${IOD}iodepth"
		# SEQUENTIAL READS
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/read.fio"  -o "${OUTPUT}/seq_r_${DEVICE}_${IOD}iodepth"
	done
	# Generate plots
	./plotall.sh "$OUTPUT" "$DEVICE" "${IODEPTH[@]}"
done

ENDTIME=$(date +%s)
ELAPSEDTIME=$(($ENDTIME - $STARTTIME))
FORMATED="$(($ELAPSEDTIME / 3600))h:$(($ELAPSEDTIME % 3600 / 60))m:$(($ELAPSEDTIME % 60))s"

echo
echo
echo "  Overall time elapsed: $FORMATED"
echo
