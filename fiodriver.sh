#!/usr/bin/env bash

DEVICES=( sdb )
THREADS=8
IODEPTH=( 1 4 16 32 64 )
FIO_SCRIPTS='FIO-scripts'

for DEVICE in ${DEVICES}; do
	# RANDOM WRITES
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-write.fio" -o "rand_w_${DEVICE}_${IOD}iodepth_${THREADS}threads"
	done

	# SEQUENTIAL WRITES
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/write.fio" -o "seq_w_${DEVICE}_${IOD}iodepth"
	done

	# RANDOM READS
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n "$THREADS" -i "$IOD" -f "${FIO_SCRIPTS}/rand-read.fio" -o "rand_r_${DEVICE}_${IOD}iodepth_${THREADS}threads"
	done

	# SEQUENTIAL WRITES
	for IOD in ${IODEPTH[@]}; do
		./runfio.sh -d "$DEVICE" -n 1 -i "$IOD" -f "${FIO_SCRIPTS}/read.fio" -o "seq_r_${DEVICE}_${IOD}iodepth"
	done
done
