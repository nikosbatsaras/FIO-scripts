#!/usr/bin/env bash

FIO_DIR='/path/to/FIO/directory'
FIO_OUT="/path/to/output/directory"

DIRS=( HDD SSD NVME )
DEVS=( sdb sdb nvme1n1 )
IODEPTHS=( 1 4 16 32 64 )

LABELS=( )
for (( i=0; i<${#IODEPTHS[@]}; i++ )); do
	LABELS+=( "iodepth-${IODEPTHS[i]}" )
done

for (( i=0; i<${#DIRS[@]}; i++ )); do
	FILES_W=( )
	FILES_R=( )
	FILES_RAND_W=( )
	FILES_RAND_R=( )

	for IODEPTH in ${IODEPTHS[@]}; do
		FILES_W+=( "${FIO_DIR}"/"${DIRS[i]}"/seq_w_"${DEVS[i]}"_"${IODEPTH}"iodepth/out.txt )
		FILES_R+=( "${FIO_DIR}"/"${DIRS[i]}"/seq_r_"${DEVS[i]}"_"${IODEPTH}"iodepth/out.txt )
		FILES_RAND_W+=( "${FIO_DIR}"/"${DIRS[i]}"/rand_w_"${DEVS[i]}"_"${IODEPTH}"iodepth_1threads/out.txt )
		FILES_RAND_R+=( "${FIO_DIR}"/"${DIRS[i]}"/rand_r_"${DEVS[i]}"_"${IODEPTH}"iodepth_1threads/out.txt )
	done

	# RANDOM WRITES
	./plotfio.py                               \
		-f "${FILES_RAND_W[@]}"            \
		-l "${LABELS[@]}"                  \
		-x "Request size (KB)"             \
		-y "Throughput (MB/s)"             \
		-o "$FIO_OUT"                      \
		-n "${DIRS[i]}_rand_w"             \
		-t "${DEVS[i]} random writes"      \
		-s "MB"

	# RANDOM READS
	./plotfio.py                               \
		-f "${FILES_RAND_R[@]}"            \
		-l "${LABELS[@]}"                  \
		-x "Request size (KB)"             \
		-y "Throughput (MB/s)"             \
		-o "$FIO_OUT"                      \
		-n "${DIRS[i]}_rand_r"             \
		-t "${DEVS[i]} random reads"       \
		-s "MB"

	# SEQUENTIAL WRITES
	./plotfio.py                               \
		-f "${FILES_W[@]}"                 \
		-l "${LABELS[@]}"                  \
		-x "Request size (KB)"             \
		-y "Throughput (MB/s)"             \
		-o "$FIO_OUT"                      \
		-n "${DIRS[i]}_seq_w"              \
		-t "${DEVS[i]} sequential writes"  \
		-s "MB"

	# SEQUENTIAL READS
	./plotfio.py                               \
		-f "${FILES_R[@]}"                 \
		-l "${LABELS[@]}"                  \
		-x "Request size (KB)"             \
		-y "Throughput (MB/s)"             \
		-o "$FIO_OUT"                      \
		-n "${DIRS[i]}_seq_r"              \
		-t "${DEVS[i]} sequential reads"   \
		-s "MB"
done
