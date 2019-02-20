#!/usr/bin/env bash

FIO_DIR='/path/to/FIO/directory'
FIO_OUT="/path/to/output/directory"

./plotfio.py -f                                                     \
	"${FIO_DIR}"/HDD/rand_w_sdb_1iodepth_1threads/out.txt       \
	"${FIO_DIR}"/HDD/rand_w_sdb_32iodepth_1threads/out.txt      \
	"${FIO_DIR}"/SSD/rand_w_sdb_1iodepth_1threads/out.txt       \
	"${FIO_DIR}"/SSD/rand_w_sdb_32iodepth_1threads/out.txt      \
	"${FIO_DIR}"/NVME/rand_w_nvme1n1_1iodepth_1threads/out.txt  \
	"${FIO_DIR}"/NVME/rand_w_nvme1n1_32iodepth_1threads/out.txt \
	-l                                                          \
	"HDD-iodepth-1" "HDD-iodepth-32"                            \
	"SSD-iodepth-1" "SSD-iodepth-32"                            \
	"NVME-iodepth-1" "NVME-iodepth-32"                          \
	-x "Request Size (KB)"                                      \
	-y "Throughput (MB/s)"                                      \
	-o "$FIO_OUT"                                               \
	-n "rand_w"                                                 \
	-t "Random writes"                                          \
	-s "MB"

./plotfio.py -f                                                     \
	"${FIO_DIR}"/HDD/rand_r_sdb_1iodepth_1threads/out.txt       \
	"${FIO_DIR}"/HDD/rand_r_sdb_32iodepth_1threads/out.txt      \
	"${FIO_DIR}"/SSD/rand_r_sdb_1iodepth_1threads/out.txt       \
	"${FIO_DIR}"/SSD/rand_r_sdb_32iodepth_1threads/out.txt      \
	"${FIO_DIR}"/NVME/rand_r_nvme1n1_1iodepth_1threads/out.txt  \
	"${FIO_DIR}"/NVME/rand_r_nvme1n1_32iodepth_1threads/out.txt \
	-l                                                          \
	"HDD-iodepth-1" "HDD-iodepth-32"                            \
	"SSD-iodepth-1" "SSD-iodepth-32"                            \
	"NVME-iodepth-1" "NVME-iodepth-32"                          \
	-x "Request Size (KB)"                                      \
	-y "Throughput (MB/s)"                                      \
	-o "$FIO_OUT"                                               \
	-n "rand_r"                                                 \
	-t "Random reads"                                           \
	-s "MB"

./plotfio.py -f                                           \
	"${FIO_DIR}"/HDD/seq_w_sdb_1iodepth/out.txt       \
	"${FIO_DIR}"/HDD/seq_w_sdb_32iodepth/out.txt      \
	"${FIO_DIR}"/SSD/seq_w_sdb_1iodepth/out.txt       \
	"${FIO_DIR}"/SSD/seq_w_sdb_32iodepth/out.txt      \
	"${FIO_DIR}"/NVME/seq_w_nvme1n1_1iodepth/out.txt  \
	"${FIO_DIR}"/NVME/seq_w_nvme1n1_32iodepth/out.txt \
	-l                                                \
	"HDD-iodepth-1" "HDD-iodepth-32"                  \
	"SSD-iodepth-1" "SSD-iodepth-32"                  \
	"NVME-iodepth-1" "NVME-iodepth-32"                \
	-x "Request Size (KB)"                            \
	-y "Throughput (MB/s)"                            \
	-o "$FIO_OUT"                                     \
	-n "seq_w"                                        \
	-t "Sequential writes"                            \
	-s "MB"

./plotfio.py -f                                           \
	"${FIO_DIR}"/HDD/seq_r_sdb_1iodepth/out.txt       \
	"${FIO_DIR}"/HDD/seq_r_sdb_32iodepth/out.txt      \
	"${FIO_DIR}"/SSD/seq_r_sdb_1iodepth/out.txt       \
	"${FIO_DIR}"/SSD/seq_r_sdb_32iodepth/out.txt      \
	"${FIO_DIR}"/NVME/seq_r_nvme1n1_1iodepth/out.txt  \
	"${FIO_DIR}"/NVME/seq_r_nvme1n1_32iodepth/out.txt \
	-l                                                \
	"HDD-iodepth-1" "HDD-iodepth-32"                  \
	"SSD-iodepth-1" "SSD-iodepth-32"                  \
	"NVME-iodepth-1" "NVME-iodepth-32"                \
	-x "Request Size (KB)"                            \
	-y "Throughput (MB/s)"                            \
	-o "$FIO_OUT"                                     \
	-n "seq_r"                                        \
	-t "Sequential reads"                             \
	-s "MB"
