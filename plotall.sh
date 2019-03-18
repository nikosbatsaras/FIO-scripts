#!/usr/bin/env bash

args=("$@")
FIO_DIR="${args[0]}"
FIO_OUT="${args[0]}"
DEV="${args[1]}"
THREADS="${args[2]}"
IODEPTHS=("${args[@]:3}")

LABELS=( )
for (( i=0; i<${#IODEPTHS[@]}; i++ )); do
	LABELS+=( "iodepth-${IODEPTHS[i]}" )
done

FILES_W=( )
FILES_R=( )
FILES_RAND_W=( )
FILES_RAND_R=( )

for IODEPTH in ${IODEPTHS[@]}; do
	FILES_W+=( "${FIO_DIR}/seq_w_${DEV}_${IODEPTH}iodepth/out.txt" )
	FILES_R+=( "${FIO_DIR}/seq_r_${DEV}_${IODEPTH}iodepth/out.txt" )
	FILES_RAND_W+=( "${FIO_DIR}/rand_w_${DEV}_${IODEPTH}iodepth_${THREADS}threads/out.txt" )
	FILES_RAND_R+=( "${FIO_DIR}/rand_r_${DEV}_${IODEPTH}iodepth_${THREADS}threads/out.txt" )
done

# RANDOM WRITES
./plotfio.py                           \
	-f "${FILES_RAND_W[@]}"        \
	-l "${LABELS[@]}"              \
	-x "Request size (KB)"         \
	-y "Throughput (MB/s)"         \
	-o "$FIO_OUT"                  \
	-n "${DEV}_rand_w"             \
	-t "${DEV} random writes"      \
	-s "MB"

# RANDOM READS
./plotfio.py                           \
	-f "${FILES_RAND_R[@]}"        \
	-l "${LABELS[@]}"              \
	-x "Request size (KB)"         \
	-y "Throughput (MB/s)"         \
	-o "$FIO_OUT"                  \
	-n "${DEV}_rand_r"             \
	-t "${DEV} random reads"       \
	-s "MB"

# SEQUENTIAL WRITES
./plotfio.py                           \
	-f "${FILES_W[@]}"             \
	-l "${LABELS[@]}"              \
	-x "Request size (KB)"         \
	-y "Throughput (MB/s)"         \
	-o "$FIO_OUT"                  \
	-n "${DEV}_seq_w"              \
	-t "${DEV} sequential writes"  \
	-s "MB"

# SEQUENTIAL READS
./plotfio.py                           \
	-f "${FILES_R[@]}"             \
	-l "${LABELS[@]}"              \
	-x "Request size (KB)"         \
	-y "Throughput (MB/s)"         \
	-o "$FIO_OUT"                  \
	-n "${DEV}_seq_r"              \
	-t "${DEV} sequential reads"   \
	-s "MB"
